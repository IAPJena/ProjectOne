function showChild(parentWindow,childWindow)
% Make the given child window visible.
% Member of ParentWindow class
    set(childWindow.ChildHandles.FigureHandle,'Visible','On');
end