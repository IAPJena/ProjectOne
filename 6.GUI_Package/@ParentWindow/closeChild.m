function closed = closeChild(parentWindow,childWindow)
% Closes the given child window from the parent window.
% Member of ParentWindow class
    delete(childWindow.ChildHandles.FigureHandle);
    RemoveFromOpenedWindowsList(parentWindow,childWindow);
    closed = 1;
end  