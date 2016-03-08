function closed = closeParent(parentWindow)
% Closes the current parent window.
% Member of ParentWindow class

    closeAllChildWindows(parentWindow);
    delete(parentWindow.ParentHandles.FigureHandle);
    closed = 1;
end