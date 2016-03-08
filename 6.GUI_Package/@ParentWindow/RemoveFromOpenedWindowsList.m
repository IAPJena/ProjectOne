function removed =  RemoveFromOpenedWindowsList( parentWindow,childWindow)
    % removeFromOpenedWindowList: remove the current window from opened window
    % list menu
    % Member of ParentWindow class
    
    aodHandles = parentWindow.ParentHandles;
    childWindowIndex = childWindow.ChildHandles.Index;
    
    myMenuTag = ['menuOpenedWindows',num2str(childWindowIndex)];
    myMenuObject = findobj('tag',myMenuTag);
    delete(myMenuObject);
    removed = 1;
end