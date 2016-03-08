function hideChild(childWindow)
    % Hides the given child window
    % Member of ChildWindow class
    set(childWindow.ChildHandles.FigureHandle,'Visible','off');
end