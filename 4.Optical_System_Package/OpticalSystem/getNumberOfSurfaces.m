function [ nSurface, surfaceArray ] = getNumberOfSurfaces( optSystem )
    %GETNUMBEROFSURFACES returns the number of surfaces. The surface array
    %is also returned as second argument.
    surfaceArray = getSurfaceArray(optSystem);
    nSurface = length(surfaceArray);
end

