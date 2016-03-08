function opened = openSavedOpticalSystem(parentWindow,savedOpticalSystem,fullFileName)
    % extract all data from a given OpticalSystem object "savedOpticalSystem"
    % and load it to surface data editor and configuration window.
    % Member of ParentWindow class
    
    resetParentParameters( parentWindow );
    aodHandles = parentWindow.ParentHandles;
    if fullFileName
        % Change the title bar to optical system name
        [pathStr,name,ext] = fileparts(fullFileName);
        aodHandles.IsSaved = 1;
    else
        aodHandles.IsSaved = 0; 
        pathStr = '';
        name = 'Untitled';
        ext = '.mat';
    end
    
    aodHandles.PathName = pathStr;
    aodHandles.FileName = [name,ext];
    set(aodHandles.FigureHandle,'Name',[aodHandles.PathName,aodHandles.FileName]);
    aodHandles.OpticalSystem = savedOpticalSystem;
    
    parentWindow.ParentHandles = aodHandles;

    %% System Configuration Data
    updateSystemConfigurationWindow( parentWindow );
    % Update the surface or component editor panel
    updateOpticalElementEditorPanel(parentWindow);
    % Display the system layout and general system parameters
    updateQuickLayoutPanel(parentWindow,1)
    opened = 1;
end