function [ incidenceAngleSigned ] = getAllSurfaceIncidenceAngle( allSurfaceRayTraceResult,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices)
    %getAllSurfaceIncidenceAngle: Returns the Incidence Angle of a specific
    % ray specified by (rayPupilIndex,rayFieldIndex,rayWavIndex) for all surfaces
    % Input:
    %   allSurfaceRayTraceResult: vector of raytrace result (size = nSurf)
    %   (rayPupilIndex,rayFieldIndex,rayWavIndex) : Indices specifying a given
    %   ray
    % Output:
    %   incidenceAngle: is (1 X nSurface X nPupilPointsRequested X nFieldRequested X nWavRequested)
    
    if nargin == 0
        disp(['Error: The function  getAllSurfaceIncidenceAngle requires ',...
            'atleast the surface trace result struct as argument.']);
        incidenceAngleSigned = NaN;
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
    
    requestedResultFieldName2 = 'IncidentRayDirection';
    requestedFieldFirstDim2 = 3;
    incidentRayDirection = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName2,requestedFieldFirstDim2,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    % now compute the IncidenceAngle
    incidenceAngle = computeAngleBetweenVectors (surfaceNormal,incidentRayDirection);
    % Add signs to the angles
    % +Ve angles: CCW when observed from (SurfaceNormal X RayDirection)
    % pointing to the direction with -ve x component
    % -Ve angles: CW when observed from (SurfaceNormal X RayDirection)
    % pointing to the direction with -ve x component
    % This makes the angles valid for rays in yz planes with conventional sign convention.
    
    normalToPlaneOfPropagationIncident = compute3dCross(surfaceNormal,incidentRayDirection);
    incidenceAngleSigned = incidenceAngle.* -sign(normalToPlaneOfPropagationIncident(1,:,:));
end

