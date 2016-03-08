function [ nNonDummySurface ] = getNumberOfNonDummySurfaces( optSystem )
    %GETNUMBEROFNONDUMMYSURFACES returns the number of non dummy surface
    %arrays
        nNonDummySurface = length(getNonDummySurfaceArray(optSystem));
end

