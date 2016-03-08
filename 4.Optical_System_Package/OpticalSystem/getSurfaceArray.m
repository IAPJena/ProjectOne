function [ surfaceArray, nSurface ] = getSurfaceArray( optSystem,surfIndex )
    %GETSURFACEARRAY Returns the surface array of an optical system. The
    %surface coordinate transformation matrices are updated if they were
    %not updated.
    
    if nargin == 1
        surfIndex = 0;
    end
    updatedSurfaceArray = optSystem.SurfaceArray;
    
    if surfIndex
        % Return the required surface
        surfaceArray = updatedSurfaceArray(surfIndex);
    else
        surfaceArray = updatedSurfaceArray;
    end
    nSurface = length(surfaceArray);
end

