function [ eixtAngleSigned ] = getAllSurfaceExitAngle( allSurfaceRayTraceResult,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices)
    %getAllSurfaceExitAngle: Returns the Exit Angle of a specific
    % ray specified by (rayPupilIndex,rayFieldIndex,rayWavIndex) for all surfaces
    % Input:
    %   allSurfaceRayTraceResult: vector of raytrace result (size = nSurf)
    %   (rayPupilIndex,rayFieldIndex,rayWavIndex) : Indices specifying a given
    %   ray
    % Output:
    %   exitAngles: is (1 X nSurface X nPupilPointsRequested X nFieldRequested X nWavRequested)
    
    if nargin == 0
        disp(['Error: The function  getAllSurfaceExitAngle requires ',...
            'atleast the surface trace result struct as argument.']);
        eixtAngleSigned = NaN;
        return;
    elseif nargin == 1
        rayPupilIndices = 0; % All
        rayFieldIndices = 0; % All
        rayWavelengthIndices = 0; % All
    elseif nargin == 2
        rayFieldIndices = 0; % All
        rayWavelengthIndices = 0; % All
    elseif nargin == 3
        rayWavelengthIndices = 0; % All
    else
        
    end
    
    % Compute the surface normal and incidence ray direction
    requestedResultFieldName1 = 'SurfaceNormal';
    requestedFieldFirstDim1 = 3;
    surfaceNormal = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName1,requestedFieldFirstDim1,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    requestedResultFieldName2 = 'ExitRayDirection';
    requestedFieldFirstDim2 = 3;
    exitRayDirection = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName2,requestedFieldFirstDim2,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    % now compute the ExitAngle
    exitAngle = computeAngleBetweenVectors (surfaceNormal,exitRayDirection);
    % Add signs to the angles
    % +Ve angles: CCW when observed from (SurfaceNormal X RayDirection)
    % from direction with -ve x component
    % -Ve angles: CW when observed from (SurfaceNormal X RayDirection)
    % from direction with -ve x component
    % This makes the angles valid for rays in yz planes with conventional sign convention.
    
    normalToPlaneOfPropagationExit = compute3dCross(surfaceNormal,exitRayDirection);
    eixtAngleSigned = exitAngle.* -sign(normalToPlaneOfPropagationExit(1,:,:));
end

