function [ closed ] = closeAllWindows(parentWindow)
    %closeAllWindows: Closes all windows opened including the main window
    % Member of ParentWindow class

    nChildren = size(parentWindow.ParentHandles.ChildWindows,2);
    for k = 1 : nChildren
        currentChildWindow = parentWindow.ParentHandles.ChildWindows(k);
        if isvalid(currentChildWindow) % Undeleted valid object
            delete(currentChildWindow.ChildHandles.FigureHandle);
            delete(currentChildWindow);
        end
    end
    delete(parentWindow.ParentHandles.FigureHandle);
    parentWindow.delete;           
    closed = 1;
end