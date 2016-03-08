function [ nSurface ] = getComponentNumberOfSurfaces( currentComponent )
    %getComponentNumberOfSurfaces returns the number of surfaces
    
    nSurface = length(getComponentSurfaceArray(currentComponent));
    
end

