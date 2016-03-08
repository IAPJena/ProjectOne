function closeChild(childWindow)
    % Closes the given child window
    % Member of ChildWindow class
    
    % The close window callback removes the child window from the list in
    % the opened menu
    try
        close(childWindow.ChildHandles.FigureHandle);
        childWindow.delete;
    catch
        RemoveFromOpenedWindowsList( parentWindow,childWindow);
        delete(childWindow);
    end
end

