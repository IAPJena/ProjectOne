function rayPathMatrix = computeRayPathMatrix2(optSystem,initialRayBundle)
    % computeRayPathMatrix2: computes the ray path coordinates for all field
    % rays in the initial ray bundle. Then the output rayPathMatrix will be
    % of 3D dimension. (3 X nSurf X nRays)
        
    [ rayTraceOptionStruct ] = RayTraceOptionStruct( );
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 1;
    
    % The polarizedRayTraceResult will be a a vector of RayTraceResult
    % object of size = nSurf.
    [rayTracerResult] = rayTracer(optSystem,initialRayBundle,rayTraceOptionStruct);
    
    nSurface = length(rayTracerResult);
    [ exitRayPositions ] = getAllSurfaceExitRayPosition( rayTracerResult);
    [ rayIntersectionPoints ] = getAllSurfaceRayIntersectionPoint( rayTracerResult);
    
    % The intersection points and positions are in LensUnit
    rayPathMatrix(:,[1:2:2*nSurface],:) = rayIntersectionPoints;
    rayPathMatrix(:,[2:2:2*nSurface],:)  = exitRayPositions;
    
    %
end
