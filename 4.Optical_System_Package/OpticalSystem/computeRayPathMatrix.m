function rayPathMatrix = computeRayPathMatrix(optSystem,wavelengthIndices,...
        fieldIndices,PupSamplingType,nPupilPoints1,nPupilPoints2)
    % computeRayPathMatrix: computes the ray path coordinates for all field
    % points and wavelengths by performing multiple ray trace. The
    % wavInd,fldInd can be vectors. Then the output rayPathMatrix will be
    % of 5D dimension. (3 X nSurf X nPupilPoints X nFieldPoints X nWav)

    lensUnitFactor = getLensUnitFactor(optSystem);
    
    [ rayTraceOptionStruct ] = RayTraceOptionStruct( );
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 1;

    % The polarizedRayTraceResult will be a a vector of RayTraceResult
    % object of size = nSurf.
    [polarizedRayTracerResult] = multipleRayTracer(optSystem,wavelengthIndices, ...
        fieldIndices,nPupilPoints1,nPupilPoints2,PupSamplingType,rayTraceOptionStruct);
    
    nSurface = length(polarizedRayTracerResult);
    [ exitRayPositions ] = getAllSurfaceExitRayPosition( polarizedRayTracerResult);
    [ rayIntersectionPoints ] = getAllSurfaceRayIntersectionPoint( polarizedRayTracerResult);
    
    % The intersection points and positions are in LensUnit
    rayPathMatrix(:,[1:2:2*nSurface],:,:,:) = rayIntersectionPoints;
    rayPathMatrix(:,[2:2:2*nSurface],:,:,:)  = exitRayPositions;
end
