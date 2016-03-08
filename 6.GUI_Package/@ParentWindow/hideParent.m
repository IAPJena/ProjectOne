function hidden = hideParent(parentWindow)
% Hides the parent window.
% Member of ParentWindow class

    set(parentWindow.ParentHandles.FigureHandle,'Visible','off');
    hidden = 1;
end