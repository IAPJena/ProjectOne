function drawn = plotPupilPolarizationEllipseMap(optSystem,surfIndex,...
        wavelengthIndices,fieldIndices,sampleGridSize,polarizationProfileType,...
        polarizationProfileParameters,plotPanelHandle)
    % Plot polarization ellipse map in the pupil of the system for given
    % input polarization states. NB. initialPolVector is defined in the global
    % xyz coordinate of the opt system  
    % As Jones vector represent only globally polarized light (fully polarized).
    % Locally polarized (partially polarized) light can not be used here.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 21,2014   Worku, Norman G.     Vectorized version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Default Inputs
    if nargin < 7
        disp('Error: The function requires atleast 6 arguments, optSystem,',...
            ' surfIndex, wavLen, fieldPointXY, sampleGridSize and polVector');
        return;
    elseif nargin == 7
        plotPanelHandle = uipanel('Parent',figure('Name','Pupil Polarization Ellipse Map'),...
            'Units','normalized','Position',[0,0,1,1]);
    end
    
    %     cla(axesHandle,'reset')
    nSurf = getNumberOfSurfaces(optSystem);
    PupSamplingType = 'Cartesian';
    numberOfRays = sampleGridSize^2;
    endSurface = surfIndex;
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderPolarization = 1;
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 0;
    rayTraceOptionStruct.ComputeOpticalPathLength = 1;
    
    [polarizedRayTracerResult,pupilMeshGrid,outsidePupilIndices] = multipleRayTracer(optSystem,wavelengthIndices,...
        fieldIndices,sampleGridSize,sampleGridSize,PupSamplingType,rayTraceOptionStruct,endSurface);%
    
    nRay = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfPupilPoints;
    nField = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfFieldPoints;
    nWav = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfWavelengths;
    
    % Take the ray trace result at surface 1 and last surface : surfIndex
    rayTracerResultFirstSurf = polarizedRayTracerResult(1);
    if length(polarizedRayTracerResult) > 1
        rayTracerResultLastSurf = polarizedRayTracerResult(2);
    else
        rayTracerResultLastSurf = polarizedRayTracerResult(1);
    end
        
    
    
    % Spatial Distribution of Polarization Ellipse in a given surface
    
    % Connect the polarization definition function
    polarizationDefinitionHandle = str2func(getSupportedPolarizationProfiles(polarizationProfileType));
    returnFlag = 2; %
    inputDataStruct = struct;
    inputDataStruct.xMesh = pupilMeshGrid(:,:,1);
    inputDataStruct.yMesh = pupilMeshGrid(:,:,2);
    inputDataStruct.BeamCenter = [0,0];
    [ returnDataStruct ] = polarizationDefinitionHandle(returnFlag,polarizationProfileParameters,inputDataStruct);
    jonesVector = returnDataStruct.JonesVector;
    polDistributionType = returnDataStruct.PolarizationDistributionType;
    coordinate = returnDataStruct.CoordinateSystem;
    % For global polarized it will be just a single vector but for locally
    % polarized it will be matrix of size = pupil points
    matrixOfJonesVector = jonesVector;
    
    
    switch lower(polDistributionType)
        case ('global')
            jonesVectorNew = matrixOfJonesVector;
        case ('local')
            % Take only the polarization of those rays inside the pupil (for which
            % ray trace result exist)
            Jx = matrixOfJonesVector(:,:,1);
            Jx(outsidePupilIndices) = [];
            Jy = matrixOfJonesVector(:,:,2);
            Jy(outsidePupilIndices) = [];
            jonesVectorNew = [Jx(:),Jy(:)]';
    end
    % The matrix of jones vector is assumed to be defined over the entrance pupil
    entrancePupilRadius = (getEntrancePupilDiameter(optSystem))/2;
    
    % Convert the Jones vector to the polarizationVector in
    % XYZ global coordinate
    rayDirection = [rayTracerResultFirstSurf.ExitRayDirection];
    if strcmpi(coordinate,'SP')
        jonesVectorSP = (jonesVectorNew);
        initialPolVectorXYZ = convertJVToPolVector...
            (jonesVectorSP,rayDirection);
    elseif strcmpi(coordinate,'XY')
        % From dispersion relation the Z component of field can be
        % computed from the x and y components in linear
        % isotropic media+
        kx = rayDirection(1,:);
        ky = rayDirection(2,:);
        kz = rayDirection(3,:);
        
        if size(jonesVectorNew,2) == 1
            jonesVectorNew = jonesVectorNew*ones(1,nRay);
        end
        fieldEx = jonesVectorNew(1,:);
        fieldEy = jonesVectorNew(2,:);
        
        fieldEz = - (kx.*fieldEx + ky.*fieldEy)./(kz);
        
        initialPolVectorXYZ = [fieldEx;fieldEy;fieldEz];
    else
        
    end
    
    wavelengthInM = getSystemWavelengths(optSystem,wavelengthIndices);
    [ finalPolarizationVector ] = computeFinalPolarizationVector(...
        rayTracerResultLastSurf,initialPolVectorXYZ, wavelengthInM);
    
    ellipseParametersAfterSurface = computeEllipseParameters...
        ( finalPolarizationVector);
    
    % Plot ellipse
    wavIndex = 1;
    fieldIndex = 1;
    subplotPanel = uipanel('Parent',plotPanelHandle,...
        'Units','Normalized',...
        'Position',[(wavIndex-1)/nWav,(nField-fieldIndex)/nField,...
        min([1/nWav,1/nField]),min([1/nWav,1/nField])],...
        'Title',['WaveLen Index : ', num2str(wavIndex),...
        ' & Field Index : ',num2str(fieldIndex)]);
    subplotAxes = axes('Parent',subplotPanel,...
        'Units','Normalized',...
        'Position',[0,0,1,1]);
    
    a = ellipseParametersAfterSurface(1,:);
    b = ellipseParametersAfterSurface(2,:);
    direction = ellipseParametersAfterSurface(3,:);
    phi = ellipseParametersAfterSurface(4,:);
    
    % center coordinates
    centerX = pupilMeshGrid(:,:,1);
    centerY = pupilMeshGrid(:,:,2);
    centerXLinear = centerX(:);
    centerYLinear = centerY(:);
    % Remove those coordinates outside aperture
    centerXLinear(outsidePupilIndices) = [];
    centerYLinear(outsidePupilIndices) = [];
    % normalize to pupil radius
    cx = (centerXLinear)'*sampleGridSize./entrancePupilRadius;
    cy = (centerYLinear)'*sampleGridSize./entrancePupilRadius;
    plotEllipse(a',b',cx',cy',phi',direction',subplotAxes);
    %     plot_ellipse(subplotAxes,a,b,cx,cy,phi,direction);
    
    set(gcf,'Name',['Pupil Polarization Ellipse Map at surface : ',num2str(surfIndex)]);
    drawn = 1;
    % axis equal;
end
