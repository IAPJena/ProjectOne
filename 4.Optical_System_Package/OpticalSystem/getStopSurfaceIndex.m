function [stopIndex, specified,surfaceArray, nSurface] = getStopSurfaceIndex(optSystem)
    % getStopIndex: gives the stop index surface set by user
    stopIndex = 0;
    specified = 0;
    [nSurface, surfaceArray ] = getNumberOfSurfaces(optSystem);
    for kk=1:1:nSurface
        curentSurf = surfaceArray(kk);
        if curentSurf.StopSurfaceIndex
            stopIndex = kk;
            specified = 1;
            return;
        end
    end
    
    if stopIndex == 0
        % If stop index not given by user then compute it
        givenStopIndex = 0;
        [ stopIndex,stopClearAperture] = computeSystemStopIndex(optSystem,givenStopIndex);
    end
end