function [ finalKostenbauderMatrix, interfaceKostenbauderMatrices,mediumKostenbauderMatrices ] = ...
        computeKostenbauderMatrix( optSystem,startSurf,startSurfInclusive,...
        endSurf, endSurfInclusive,pilotRay )
    %computeKostenbauderMatrix Computes the ray pulse matrix of an optical system
    %or part of the optical system
    
    % First trace pilot ray with central wavelength and then compute the matrix
    % for each surface and multiply.
    c =  299792458;
    format longE
    format compact
    
    % Default inputs
    if nargin == 0
        disp('Error: The function computeSystemKostenbauderMatrix requires atleast the optical system object.');
        finalKostenbauderMatrix = NaN;
        interfaceKostenbauderMatrices = NaN;
        mediumKostenbauderMatrices = NaN;
        return;
    elseif nargin == 1
        startSurf = 1;
        startSurfInclusive = 0;
        
        endSurf = optSystem.NumberOfSurfaces;
        endSurfInclusive = 0;
        % Take the chief ray as pilot ray
        pilotRay = getChiefRay(optSystem);
    elseif nargin == 2
        startSurfInclusive = 0;
        endSurf = optSystem.NumberOfSurfaces;
        endSurfInclusive = 0;
        % Take the chief ray as pilot ray
        pilotRay = getChiefRay(optSystem);
    elseif nargin == 3
        endSurf = optSystem.NumberOfSurfaces;
        endSurfInclusive = 0;
        % Take the chief ray as pilot ray
        pilotRay = getChiefRay(optSystem);
    elseif nargin == 4
        endSurfInclusive = 0;
        % Take the chief ray as pilot ray
        pilotRay = getChiefRay(optSystem);
    elseif nargin == 5
        % Take the chief ray as pilot ray
        pilotRay = getChiefRay(optSystem);
    else
        
    end
    % Just take the first ray if more than one rays are input
    pilotRay = pilotRay(1);
    
    % trace the pilot ray
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.RecordIntermediateResults = 1;
    rayTraceOptionStruct.ComputeRefractiveIndexFirstDerivative = 1;
    rayTraceOptionStruct.ComputeRefractiveIndexSecondDerivative = 1;
    
    pilotRayTraceResult = rayTracer(optSystem,pilotRay,rayTraceOptionStruct);
    
    % Get the path lengths after each surface
    allPathLength = getAllSurfaceGeometricalPathLength(pilotRayTraceResult,0,0,0);
    pathLengthFromPrevSurf  = allPathLength*getLensUnitFactor(optSystem);
    L = [pathLengthFromPrevSurf,0];
    % Get the angle of incidence and exit rays for each surface
    % Take negative of the angles as the kostenbauder matrix computation
    % assumes the positive angle = CCW when seen from -ve x axis
    % Whereas the ray trace result gives +vw angle for CCW when seen from +ve x
    % axis
    
    ang1 = getAllSurfaceIncidenceAngle(pilotRayTraceResult,0,0,0);; %[pilotRayTraceResult.IncidenceAngle];
    ang2 = getAllSurfaceExitAngle(pilotRayTraceResult,0,0,0);;%[pilotRayTraceResult.ExitAngle];
    % Get the refractive indices, 1st and 2nd order derivatev of n with
    % respect to wavelength for medium after each surface
    n = [pilotRayTraceResult.RefractiveIndex];
    dndl = [pilotRayTraceResult.RefractiveIndexFirstDerivative];
    d2ndl2 = [pilotRayTraceResult.RefractiveIndexSecondDerivative];
    
    % Compute the centeral frequency
    f0 = c/pilotRay.Wavelength;
    % Initialize the ray pulse matrix to identity matrix
    tempK = eye(4);
    [ NonDummySurfaceArray,nNonDummySurface,NonDummySurfaceIndices,...
        surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem );
    
    startNonDummyIndex = find(NonDummySurfaceIndices>=startSurf);
    startNonDummyIndex = startNonDummyIndex(1);
    endNonDummyIndex = find(NonDummySurfaceIndices<=endSurf);
    endNonDummyIndex = endNonDummyIndex(end);
    lensUnit = getLensUnitFactor(optSystem);
    for surfaceIndex = startNonDummyIndex:1:endNonDummyIndex
        if (surfaceIndex == startNonDummyIndex && surfaceIndex < endNonDummyIndex ...
                && ~startSurfInclusive)||surfaceIndex == 1
            interfaceKostenbauderMatrices(:,:,surfaceIndex) = eye(4);
        elseif surfaceIndex == endNonDummyIndex && surfaceIndex > startNonDummyIndex ...
                && ~endSurfInclusive
            interfaceKostenbauderMatrices(:,:,surfaceIndex) = eye(4);
        else
            surfaceParameters = NonDummySurfaceArray(surfaceIndex).UniqueParameters;
            switch lower(GetSupportedSurfaceTypes(NonDummySurfaceArray(surfaceIndex).Type))
                case lower('IdealLens')
                    focalLength = surfaceParameters.FocalLength*lensUnit;
                    interfaceKostenbauderMatrices(:,:,surfaceIndex) =...
                        [1,0,0,0;...
                        -1/focalLength,1,0,0;...
                        0,0,1,0;...
                        0,0,0,1];
                case lower('Kostenbauder')
                    % NB: The ABCD parameters in kostenbuder surface are given in
                    % lens unit so should be changed back to SI unit for further
                    % computation
                    interfaceKostenbauderMatrices(:,:,surfaceIndex) =...
                        [surfaceParameters.A,surfaceParameters.B*lensUnit,0,surfaceParameters.E*lensUnit;...
                        surfaceParameters.C/lensUnit,surfaceParameters.D,0,surfaceParameters.F;...
                        surfaceParameters.G/lensUnit,surfaceParameters.H,1,surfaceParameters.I;...
                        0,0,0,1];
                otherwise % case lower('Standard')
                    radius = getRadiusOfCurvature(NonDummySurfaceArray(surfaceIndex))*lensUnit;
                    diffOrder = getDiffractionOrder(NonDummySurfaceArray(surfaceIndex));
                    %     diffOrder = -1;
                    if strcmpi(NonDummySurfaceArray(surfaceIndex).Glass.Name,'Mirror')
                        reflection = 1;
                    else
                        reflection = 0;
                    end
                    interfaceKostenbauderMatrices(:,:,surfaceIndex) = computeInterfaceKostenbauderMatrix( ...
                        ang1(surfaceIndex),ang2(surfaceIndex),...
                        n(surfaceIndex-1),n(surfaceIndex),...
                        dndl(surfaceIndex-1),dndl(surfaceIndex),f0,reflection,radius,diffOrder );
                    
            end
            
        end
        if surfaceIndex == endNonDummyIndex
            mediumKostenbauderMatrices(:,:,surfaceIndex) =  eye(4);
        else
            mediumKostenbauderMatrices(:,:,surfaceIndex) = computeMediumKostenbauderMatrix( L(surfaceIndex+1),f0,d2ndl2(surfaceIndex) );
        end
        
        tempK = mediumKostenbauderMatrices(:,:,surfaceIndex)*interfaceKostenbauderMatrices(:,:,surfaceIndex)*tempK;
    end
    finalKostenbauderMatrix = tempK;
    
end

