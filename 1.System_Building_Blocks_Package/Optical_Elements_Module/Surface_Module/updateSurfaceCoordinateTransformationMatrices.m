function updatedSurfaceArray = updateSurfaceCoordinateTransformationMatrices(surfaceArray)
    %updateSurfaceCoordinateTransformationMatrices Computes the surface
    %coordinate transformation matrices of each surface from the given
    %parameters of the surface thickness, tilt and decenter parameters.
    % If the first surface is an object surface then the reference will be
    % the second surface but otherwise the first surface is used as
    % global reference.
    
    if surfaceArray(1).IsObject
        % Object surface
        objThickness = abs(surfaceArray(1).Thickness);
        if objThickness > 10^10 
            % Replace Inf with INF_OBJ_Z = with small thickness for graphing
            % The tickness is computed so that the surface lies to the
            % right of all initial rays
            
            objThickness = -0;
        end
        % since global coord but shifted by objThickness
        refCoordinateTM = ...
            [1,0,0,0;
            0,1,0,0;
            0,0,1,-objThickness;
            0,0,0,1];
    else
        refCoordinateTM = ...
            [1,0,0,0;
            0,1,0,0;
            0,0,1,0;
            0,0,0,1];
    end
    
    updatedSurfaceArray = surfaceArray;
    nSurface = length(surfaceArray);
    
    surfaceCoordinateTM = refCoordinateTM;
    referenceCoordinateTM = refCoordinateTM;
    % set surface property
    updatedSurfaceArray(1).SurfaceCoordinateTM = surfaceCoordinateTM;
    updatedSurfaceArray(1).ReferenceCoordinateTM = referenceCoordinateTM;
    for ss = 2:nSurface
        currentSurface = updatedSurfaceArray(ss);
        previousSurface = updatedSurfaceArray(ss-1);
        % Update the surface coordinates and positions
        % compute position from decenter and thickness

        prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
        prevThickness = previousSurface.Thickness;
        if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
            prevThickness = 0;
        end
        [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
            currentSurface,prevRefCoordinateTM,prevThickness);
        % set surface property
        currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
        currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
        updatedSurfaceArray(ss) = currentSurface;
    end
    
end

