function childWindow = findChild(parentWindow,childIndex)
% Find a given child from the parent window using the child index.
% Member of ParentWindow class

    nChildren = size(parentWindow.ParentHandles.ChildWindows,2);
    childWindow = ChildWindow.empty;
    for k = 1 : nChildren
        currentChildWindow = parentWindow.ParentHandles.ChildWindows(k);
        if isvalid(currentChildWindow) % Undeleted valid object
            if currentChildWindow.ChildHandles.Index == childIndex
                childWindow = currentChildWindow;
            end            
        end
    end 
end