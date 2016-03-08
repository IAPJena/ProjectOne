function hidden = hideChild(parentWindow,childWindow)
% Hides the given child window from the parent window.
% Member of ParentWindow class

    set(childWindow.ChildHandles.FigureHandle,'Visible','off');
    hidden = 1;
end  