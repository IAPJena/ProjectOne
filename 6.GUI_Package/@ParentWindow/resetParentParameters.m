function resetParentParameters( parentWindow )
    % RESETOTHERPARAMETERS resets parameters of the parentWindow
    % Member of ParentWindow class
    set(parentWindow.ParentHandles.FigureHandle,'Name','Untitled');
    parentWindow.ParentHandles.ChildWindows = ChildWindow.empty; 
    % Close all child windows
    closeAllChildWindows(parentWindow);
    parentWindow.ParentHandles.NextChildIndex = 1; 
    parentWindow.ParentHandles.SelectedElementIndex = 1;
end

