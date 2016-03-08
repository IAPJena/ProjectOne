function updateOpticalElementEditorPanel( parentWindow , selectedIndex)
    %UPDATESURFACEORCOMPONENTEDITORPANEL Updates the surface or component
    %editor windows
    
    if nargin == 1
        selectedIndex = 1;
    end
    % Update the multi configuration menu
    updateMulticonfigurationMenu(parentWindow);
    
    aodHandles = parentWindow.ParentHandles;
    
    elementCellArray = aodHandles.OpticalSystem.OpticalElementArray;
    selectedElement = elementCellArray{selectedIndex};
    currentConfig = aodHandles.CurrentConfiguration;
    [ currentOpticalSystem,saved] = getCurrentOpticalSystem (parentWindow);
    aodHandles.OpticalSystem(currentConfig) = currentOpticalSystem;
    
    if isSurface(selectedElement)
        set(aodHandles.panelSurfaceDetail,'visible','on');
        set(aodHandles.panelComponentDetail,'visible','off');
         nSurfaceInElement = 1;
        %     updateSurfaceDetail( parentWindow,selectedIndex )
    elseif isComponent(selectedElement)
        set(aodHandles.panelSurfaceDetail,'visible','off');
        set(aodHandles.panelComponentDetail,'visible','on');
        nSurfaceInElement = length(getComponentSurfaceArray(selectedElement));
        %     updateComponentDetail( parentWindow,selectedIndex )
    else
        
    end
    
    nElement = length(elementCellArray);
    elementListTable = generateOpticalElementListTable(elementCellArray);
    set(aodHandles.tblOpticalElementList, 'Data', elementListTable);
    set(aodHandles.panelOpticalElementEditorMain,'Visible','On');
    
    stopElementIndex = getStopElementIndex(elementCellArray);
    stopSurfaceIndex = elementCellArray{stopElementIndex}.StopSurfaceIndex;
   
    
    set(aodHandles.popStopElementIndex,'string',num2cell([1:nElement]),'Value',stopElementIndex);
    set(aodHandles.popStopSurfaceInComponentIndex,'string',num2cell([1:nSurfaceInElement]),'Value',stopSurfaceIndex);
    
    parentWindow.ParentHandles = aodHandles;
    
    

    updateOpticalElementDetail( parentWindow,selectedIndex )
    
    aodHandles.OpticalSystem(currentConfig) = currentOpticalSystem;
    parentWindow.ParentHandles =  aodHandles;
end

function elementListTable = generateOpticalElementListTable(elementArray)
    nElement = length(elementArray);
    elementListTable = cell(nElement,4);
    for kk = 1:nElement
        if isComponent(elementArray{kk})
            elemType = 2; % Comp
            compSurf = 'COMP'; % Comp
            if elementArray{kk}.StopSurfaceIndex
                compType = elementArray{kk}.Type;
                elemTypeDisp = GetSupportedComponentTypes(compType);
                elem = 'STOP';
                comment = 'Stop component';
            else
                compType = elementArray{kk}.Type;
                elemTypeDisp = GetSupportedComponentTypes(compType);
                elem = '';
                comment = elementArray{kk}.Comment;
            end
        elseif isSurface(elementArray{kk})
            elemType = 1; % Surf
            compSurf = 'SURF'; % Surf
            if elementArray{kk}.IsObject
                surfType = 1; %'OBJECT';
                elemTypeDisp = 'OBJECT';
                elem = 'OBJ';
                comment = 'Object';
            elseif elementArray{kk}.IsImage
                surfType = 1; %'IMAGE';
                elemTypeDisp = 'IMAGE';
                elem = 'IMG';
                comment = 'Image';
            elseif elementArray{kk}.StopSurfaceIndex
                surfType = elementArray{kk}.Type;
                elemTypeDisp = GetSupportedSurfaceTypes(surfType);
                elem = 'STOP';
                comment = 'Stop surface';
            else
                surfType = elementArray{kk}.Type;
                elemTypeDisp = GetSupportedSurfaceTypes(surfType);
                elem = '';
                comment = elementArray{kk}.Comment;
            end
        else
            
        end
        elementListTable(kk,:) = {elem,compSurf,elemTypeDisp,comment};
    end
end

