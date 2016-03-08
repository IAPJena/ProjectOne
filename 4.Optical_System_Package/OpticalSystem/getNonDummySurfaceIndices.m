function [ NonDummySurfaceIndices,surfaceArray,nSurface ] = getNonDummySurfaceIndices( optSystem )
    %getNonDummySurfaceIndices Returns the surface array which are not dummy
    [nSurface, surfaceArray ] = getNumberOfSurfaces(optSystem);
    NonDummySurfaceIndices = [];
    [~,dummySurfaceIndex] = ismember('Dummy',GetSupportedSurfaceTypes);
    for kk = 1:nSurface
        if ~(surfaceArray(kk).Type == dummySurfaceIndex) %strcmpi(surfaceArray(kk).Type,'Dummy')
            NonDummySurfaceIndices = [NonDummySurfaceIndices,kk];
        end
    end
end

