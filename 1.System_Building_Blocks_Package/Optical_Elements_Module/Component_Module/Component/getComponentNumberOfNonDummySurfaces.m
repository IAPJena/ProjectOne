function [ nNonDummySurface ] = getComponentNumberOfNonDummySurfaces( currentComponent )
    %getComponentNumberOfNonDummySurfaces returns the number of non dummy surface
    %arrays
        nNonDummySurface = length(getComponentNonDummySurfaceArray(currentComponent));
end

