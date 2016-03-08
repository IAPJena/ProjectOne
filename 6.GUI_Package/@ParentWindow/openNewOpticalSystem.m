function [ opened ] = openNewOpticalSystem(parentWindow)
% openNewOpticalSystem: Close all windows and Initialize a new optical system
% Member of ParentWindow class
    parentWindow.ParentHandles.SelectedElementIndex = 2;
    parentWindow.ParentHandles.CanAddElement = 0;
    parentWindow.ParentHandles.CanRemoveElement = 0;
    % Define initial surface Array
    defaultOpticalSystem = OpticalSystem;
    parentWindow.ParentHandles.OpticalSystem = defaultOpticalSystem;
    closeAllChildWindows(parentWindow);    
    resetParentParameters(parentWindow);
    
    updateOpticalElementEditorPanel( parentWindow );
    updateSystemConfigurationWindow( parentWindow );  
    selectedElementIndex = 2;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    opened = 1;
end

