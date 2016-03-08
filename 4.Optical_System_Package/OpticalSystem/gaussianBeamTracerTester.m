function [ outputGaussianBeamArray ] = gaussianBeamTracerTester( optSystem,initialGaussianBeamParameters,...
        recordRayTraceResults)
    %GAUSSIANBEAMTRACER Traces gaussian beam from start surface to end surface
    % and returns the output gaussian beam for each surface.
    % initialGaussianBeamParameters = [waistX,waistY,distanceFromWaist,fieldIndex,wavelngthIndex]
    % All in lens unit
    
    % Currently the central ray of the initial gaussian beampasses through the
    % center of the entrance pupil (That is how zemax defins gaussian central
    % ray by just specifying the field index and wavelength index). This
    % assumption helps in defining the moving coordinate system with +x and +y
    % directions defined for the beam at each surface by the marginal ray from
    % the starting position to final position). But ingeneral if um just
    % concerned with the gaussian beam parameters at a given surface I don't
    % need such assumption.
    
    lensUnitFactor = getLensUnitFactor(optSystem);
    wavelengthUnitFactor = getWavelengthUnitFactor(optSystem);
    if nargin == 0
        disp('Error: The function gaussianBeamTracer needs atleast the optical system object.');
        outputGaussianBeamArray = NaN;
        return
    elseif nargin == 1
        % defaults gaussian: waist size of 0.05 lens units and
        % surface 1 to waist distance of zero; Field index = 1; wavlength index
        % = 1;
        
        fieldIndex = 3;
        %fieldIndex = 1;
        wavelengthIndex = 2;
        
        % For gaussian the waist should be atleast 3 * the wavelength, lets
        % take 10*wavelength
        %         wavelength = getSystemWavelength(optSystem,wavelengthIndex)*wavelengthUnitFactor;
        %         waistX = wavelength*1000 ;
        %         waistY = wavelength*1000 ;
        
        % Lets take 1 mm by 1 mm gaussian
        waistX = 10^-3;
        waistY = 2*10^-3;
        distanceFromWaist = 0*lensUnitFactor;
        
        initialGaussianBeamParameters = [waistX,waistY,distanceFromWaist,fieldIndex,wavelengthIndex];
        recordRayTraceResults = 1;
    elseif nargin == 2
        recordRayTraceResults = 1;
    else
    end
    
    [ NonDummySurfaceArray,nNonDummySurface,NonDummySurfaceIndices,...
        surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem );
    
    startSurface = 1;
    endSurface = nSurface;
    
    surfIndicesAfterStartSurface = find(NonDummySurfaceIndices>=startSurface);
    startNonDummyIndex = surfIndicesAfterStartSurface(1);
    surfIndicesBeforeEndSurface = find(NonDummySurfaceIndices<=endSurface);
    endNonDummyIndex = surfIndicesBeforeEndSurface(end);
    
    if NonDummySurfaceArray(1).Thickness > 10^10
        objectThickness = 0;
    else
        objectThickness = NonDummySurfaceArray(1).Thickness*lensUnitFactor;
    end
    
    waistX = initialGaussianBeamParameters(1);
    waistY = initialGaussianBeamParameters(2);
    distanceFromWaist = initialGaussianBeamParameters(3);
    
    % Compute the central ray from field and wavelength indices so that it can
    % be used in all following analysis
    fieldIndex = initialGaussianBeamParameters(4);
    wavelengthIndex = initialGaussianBeamParameters(5);
    
    switch (optSystem.FieldType)
        case 1 % lower('ObjectHeight')
            % Convert the values from lens unit to meter
            fieldPointXYInSI =((optSystem.FieldPointMatrix(fieldIndex,1:2))')*...
                lensUnitFactor;
        case 2 % lower('Angle')
            % Leave in degrees
            fieldPointXYInSI = ((optSystem.FieldPointMatrix(fieldIndex,1:2))');
    end
    wavLenInM = optSystem.WavelengthMatrix(wavelengthIndex,1)*...
        getWavelengthUnitFactor(optSystem);
    cheifRay = getChiefRay(optSystem,fieldPointXYInSI,wavLenInM );
    
    % To keep the orientation of +ve x and y axis we also trace the two
    % marifginal rays y, mariginal x, mariginal y
    AngleFromYinRad_ForPx1Py0  = pi/2;
    AngleFromYinRad_ForPx0Py1 = 0;
    xMariginalRay = getMariginalRay(optSystem,fieldPointXYInSI,wavLenInM,...
        AngleFromYinRad_ForPx1Py0);
    yMariginalRay = getMariginalRay(optSystem,fieldPointXYInSI,wavLenInM,...
        AngleFromYinRad_ForPx0Py1);
    
    chiefAndMariginalRays = convertRayArrayToRayBundle([cheifRay,xMariginalRay,yMariginalRay]);
    
    rayTraceOptionStruct = RayTraceOptionStruct( );
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = recordRayTraceResults;
    
    chiefAndMariginalRayTraceResult = rayTracer(optSystem,chiefAndMariginalRays,...
        rayTraceOptionStruct);
    
    
    centralRayIntersection = getAllSurfaceRayIntersectionPoint(chiefAndMariginalRayTraceResult,1,1,1);
    mariginalRayXIntersection = getAllSurfaceRayIntersectionPoint(chiefAndMariginalRayTraceResult,2,1,1);
    mariginalRayYIntersection = getAllSurfaceRayIntersectionPoint(chiefAndMariginalRayTraceResult,3,1,1);

    centralRayDirection = getAllSurfaceExitRayDirection(chiefAndMariginalRayTraceResult,1,1,1);
    mariginalRayXDirection = getAllSurfaceExitRayDirection(chiefAndMariginalRayTraceResult,2,1,1);
    mariginalRayYDirection = getAllSurfaceExitRayDirection(chiefAndMariginalRayTraceResult,3,1,1);

    % Determine the local x and y direction from the mariginal rays
    linePlaneIntersectionX = computeLinePlaneIntersection(mariginalRayXIntersection,...
        mariginalRayXDirection,centralRayIntersection,centralRayDirection);
    localXDirection = linePlaneIntersectionX - centralRayIntersection;
    localXDirection = normalize2DMatrix(localXDirection);
    
    linePlaneIntersectionY = computeLinePlaneIntersection(mariginalRayYIntersection,...
        mariginalRayYDirection,centralRayIntersection,centralRayDirection);
    localYDirection = linePlaneIntersectionY - centralRayIntersection;
    localYDirection = normalize2DMatrix(localYDirection);
    
    % Change tha local x and y directions of the image plane to the prev
    % surface since we want the local axis before the image surface not after
    localXDirection(:,end) = localXDirection(:,end-1);
    localYDirection(:,end) = localYDirection(:,end-1);
    
    % Define the initial gaussian beam just before the start surface
    initialGaussianBeam = ScalarGaussianBeamSet();
    centralRay = cheifRay;
    % change the position of the central ray to the 2nd surface
    % intersection
    centralRay.Position =  centralRayIntersection(:,2)*lensUnitFactor;
    
    initialGaussianBeam.CentralRayPosition = centralRay.Position;
    initialGaussianBeam.CentralRayDirection = centralRay.Direction;
    initialGaussianBeam.CentralRayWavelength = centralRay.Wavelength;
    initialGaussianBeam.WaistRadiusInX = waistX;
    initialGaussianBeam.WaistRadiusInY = waistY;
    initialGaussianBeam.DistanceFromWaist = distanceFromWaist;
    initialGaussianBeam.LocalXDirection = localXDirection(:,1);
    initialGaussianBeam.LocalYDirection = localYDirection(:,1);
    
    % All rays in waist x , waist y, divergence x, divergence y
    [waistAndDivergenceRaysAtObjectSurface] = ...
        getGaussianBeamWaistAndDivergenceRaysAtObjectSurface(initialGaussianBeam,objectThickness);
    
    rayTraceOptionStruct = RayTraceOptionStruct( );
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = recordRayTraceResults;
    
    waisAndMariginalRaysTraceResult = rayTracer(optSystem,...
        waistAndDivergenceRaysAtObjectSurface,rayTraceOptionStruct);
    
    % calculate gaussian beam parameters
    wavelength = initialGaussianBeam.CentralRayWavelength;
    
    waistRayXIntersection = getAllSurfaceRayIntersectionPoint(waisAndMariginalRaysTraceResult,1);
    waistRayYIntersection = getAllSurfaceRayIntersectionPoint(waisAndMariginalRaysTraceResult,2);
    divergenceRayXIntersection = getAllSurfaceRayIntersectionPoint(waisAndMariginalRaysTraceResult,3);
    divergenceRayYIntersection = getAllSurfaceRayIntersectionPoint(waisAndMariginalRaysTraceResult,4);
    
    waistRayXDirection = getAllSurfaceExitRayDirection(waisAndMariginalRaysTraceResult,1);
    waistRayYDirection = getAllSurfaceExitRayDirection(waisAndMariginalRaysTraceResult,2);
    divergenceRayXDirection = getAllSurfaceExitRayDirection(waisAndMariginalRaysTraceResult,3);
    divergenceRayYDirection = getAllSurfaceExitRayDirection(waisAndMariginalRaysTraceResult,4);
    
    %     refractiveIndices = [chiefAndMariginalRayTraceResult(:,1).RefractiveIndex];
    refractiveIndices = getAllSurfaceRefractiveIndex(chiefAndMariginalRayTraceResult,1);
    
    % transform the 3d ray data to 2d
    [ heightOfDivergenceRayInX,angleOfDivergenceRayInX ] = transform3DRayDataTo2DCoordinate( ...
        centralRayDirection,centralRayIntersection,divergenceRayXDirection,divergenceRayXIntersection,...
        centralRayIntersection,localXDirection,localYDirection);
    [ heightOfDivergenceRayInY,angleOfDivergenceRayInY ] = transform3DRayDataTo2DCoordinate( ...
        centralRayDirection,centralRayIntersection,divergenceRayYDirection,divergenceRayYIntersection,...
        centralRayIntersection,localXDirection,localYDirection);
    
    [ heightOfWaistRayInX,angleOfWaistRayInX ] = transform3DRayDataTo2DCoordinate( ...
        centralRayDirection,centralRayIntersection,waistRayXDirection,waistRayXIntersection,...
        centralRayIntersection,localXDirection,localYDirection);
    [ heightOfWaistRayInY,angleOfWaistRayInY ] = transform3DRayDataTo2DCoordinate( ...
        centralRayDirection,centralRayIntersection,waistRayYDirection,waistRayYIntersection,...
        centralRayIntersection,localXDirection,localYDirection);
    
    heightOfDivergenceRayInX = heightOfDivergenceRayInX(1,:);
    heightOfDivergenceRayInY = heightOfDivergenceRayInY(2,:);
    heightOfWaistRayInX = heightOfWaistRayInX(1,:);
    heightOfWaistRayInY = heightOfWaistRayInY(2,:);
    angleOfDivergenceRayInX = angleOfDivergenceRayInX(1,:);
    angleOfDivergenceRayInY = angleOfDivergenceRayInY(2,:);
    angleOfWaistRayInX = angleOfWaistRayInX(1,:);
    angleOfWaistRayInY = angleOfWaistRayInY(2,:);
    
    sizeX = sqrt(heightOfWaistRayInX.^2+heightOfDivergenceRayInX.^2);
    sizeY = sqrt(heightOfWaistRayInY.^2+heightOfDivergenceRayInY.^2);
    
    wiastX = (heightOfWaistRayInX.*angleOfDivergenceRayInX - ...
        angleOfWaistRayInX.*heightOfDivergenceRayInX)./...
        sqrt(angleOfWaistRayInX.^2+angleOfDivergenceRayInX.^2);
    wiastY = (heightOfWaistRayInY.*angleOfDivergenceRayInY - ...
        angleOfWaistRayInY.*heightOfDivergenceRayInY)./...
        sqrt(angleOfWaistRayInY.^2+angleOfDivergenceRayInY.^2);
    
    
    
    positionX = (heightOfDivergenceRayInX.*angleOfDivergenceRayInX + ...
        heightOfWaistRayInX.*angleOfWaistRayInX)./...
        (angleOfWaistRayInX.^2+angleOfDivergenceRayInX.^2);
    positionY = (heightOfDivergenceRayInY.*angleOfDivergenceRayInY + ...
        heightOfWaistRayInY.*angleOfWaistRayInY)./...
        (angleOfWaistRayInY.^2+angleOfDivergenceRayInY.^2);
    
    rayleighX = ((pi*(wiastX*lensUnitFactor).^2)./...
        (wavelength./refractiveIndices))/lensUnitFactor;
    rayleighY = ((pi*(wiastY*lensUnitFactor).^2)./...
        (wavelength./refractiveIndices))/lensUnitFactor;
    
    radiusX = positionX.*(1+(rayleighX./positionX).^2);
    radiusY = positionY.*(1+(rayleighY./positionY).^2);
    
    divAngleX = atan(wiastX./rayleighX);
    divAngleY = atan(wiastY./rayleighY);
    
    
    clc
    format shortE
    format compact
    
    
    disp('General Gaussian Beam Parameters');
    disp(['Path Name: ',optSystem.PathName]);
    disp(['File Name: ',optSystem.FileName]);
    disp(['Date: ',date]);
    
    disp(' ');
    
    disp('Note 1: All the data listed for x and y directions are measured in');
    disp('the moving coordinate system with the XY plane beign perpendicular');
    disp('to the central ray of the gaussian beam.');
    disp('Note 2: +Ve X and +Ve Y directions are assumed to be in the vector ');
    disp('pointing from the chief ray coordinate to the mariginal ray coordinates');
    disp('of the two mariginal ray (px = 0, py = 1 and px = 1, py = 0 respectively)');
    disp('measured in the imaginary transversal XY plane.');
    disp(' ');
    disp(['Units for size,waist,waist position, radius and rayleigh are in lens units.(But in Zemax is always mm)']);
    disp(['Units for divergence semi angle are radians.(Same as in Zemax)']);
    disp(' ');
    
    disp('Input Beam Parameters');
    disp(['Field Index: ',num2str(fieldIndex)]);
    disp(['Field Value (SI Unit): [',num2str(fieldPointXYInSI(1)),',',...
        num2str(fieldPointXYInSI(2)),']']);
    disp(['Field Type: ',getSupportedFieldTypes(optSystem.FieldType)]);
    disp(['Wavelength Index: ',num2str(wavelengthIndex)]);
    disp(['Wavelength Value: ',num2str(wavLenInM),' meters']);
    
    disp(['Waist In X :',num2str(waistX),' meters.']);
    disp(['Waist In Y :',num2str(waistY),' meters.']);
    disp(['Distance From Waist :',num2str(distanceFromWaist),' meters.']);
    
    disp(' ');
    disp('Y Direction Fundamental Mode Results');
    disp('-----------------------------------------------------------------------------------------------');
    disp('    Surface        Size        Waist      Position      Radius     Divergence     Rayleigh');
    disp('-----------------------------------------------------------------------------------------------');
    for k=2:1:endNonDummyIndex
        disp([k-1,sizeY(k),wiastY(k),positionY(k),radiusY(k),divAngleY(k),rayleighY(k)]);
    end
    disp(' ');
    disp('X Direction Fundamental Mode Results');
    disp('----------------------------------------------------------------------------------------------');
    disp('    Surface        Size        Waist      Position      Radius     Divergence     Rayleigh');
    disp('----------------------------------------------------------------------------------------------');
    for k=2:1:endNonDummyIndex
        disp([k-1,sizeX(k),wiastX(k),positionX(k),radiusX(k),divAngleX(k),rayleighX(k)]);
    end
    
end

