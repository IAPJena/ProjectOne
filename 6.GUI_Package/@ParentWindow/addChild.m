function added = addChild(parentWindow,childWindow)
% Member of ParentWindow class
% Used to add a child window to the parent window.

    nChildren = size(parentWindow.ParentHandles.ChildWindows,2);
    parentWindow.ParentHandles.ChildWindows(nChildren+1) = childWindow;

    parentWindow.AddToOpenedWindowsList(childWindow);
    childWindow.ChildHandles.Index = ...
        parentWindow.ParentHandles.NextChildIndex;
    parentWindow.ParentHandles.NextChildIndex = ...
        parentWindow.ParentHandles.NextChildIndex + 1;
    added = 1;
end