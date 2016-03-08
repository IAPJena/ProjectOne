function [ updatedOpticalSystem ] = updateOpticalSystem( opticalSystem, unconditionalUpdate )
    %UPDATEOPTICALSYSTEM If the user chnges some parameters of optical
    %system, this function updates the floating aperture sizes and surface
    %array coordinate transformation matrices of the system.
    
    if nargin < 1
        opticalSystem = OpticalSystem;
    end
    if nargin < 2
        unconditionalUpdate = 0;
    end
    
    % Update surface array and coordinate trasnformation matrices for each
    % surface
    if ~unconditionalUpdate && isfield(opticalSystem,'IsUpdatedSurfaceArray') && ...
            opticalSystem.IsUpdatedSurfaceArray
        updatedOpticalSystem = opticalSystem;
    else
        
        nElement = length(opticalSystem.OpticalElementArray);
        totalSurfaceArray = [];
        elementToSurfaceMap = cell(nElement,1);
        for ee = 1:nElement
            currentElement = opticalSystem.OpticalElementArray{ee};
            if isempty(totalSurfaceArray)
                nSurfBefore = 0;
            else
                nSurfBefore = length(totalSurfaceArray);
            end
            
            if isSurface(currentElement)
                totalSurfaceArray = [totalSurfaceArray,currentElement];
            elseif isComponent(currentElement)
                currentSurfaceArray = getComponentSurfaceArray(currentElement);
                stopSurfaceInComponentIndex = currentElement.StopSurfaceIndex;
                if stopSurfaceInComponentIndex
                    currentSurfaceArray(stopSurfaceInComponentIndex).StopSurfaceIndex = 1;
                end
                totalSurfaceArray = [totalSurfaceArray,currentSurfaceArray];
            else
            end
            nSurfAfter = length(totalSurfaceArray);
            elementToSurfaceMap{ee} = [nSurfBefore+1:nSurfAfter];
            surfaceToElementMap(nSurfBefore+1:nSurfAfter) = num2cell(ee*ones(1,nSurfAfter-nSurfBefore));
        end
        updatedSurfaceArray = updateSurfaceCoordinateTransformationMatrices(totalSurfaceArray);
        
        opticalSystem.SurfaceArray = updatedSurfaceArray;
        opticalSystem.ElementToSurfaceMap = elementToSurfaceMap;
        opticalSystem.SurfaceToElementMap = surfaceToElementMap;
        % Set flaoting apertures
        updatedOpticalSystem = setFloatingApertures( opticalSystem );
        updatedOpticalSystem.IsUpdatedSurfaceArray = 1;
    end
end