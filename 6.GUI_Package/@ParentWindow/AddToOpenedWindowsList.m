function added = AddToOpenedWindowsList(parentWindow,childWindow)
    % Member of ParentWindow class
    % Used to add the current window to opened window list.
    
    aodHandles = parentWindow.ParentHandles;
    childId = childWindow.ChildHandles.Index;
    
    %     nChildrensOpened = length (aodHandles.ChildWindow);
    aodHandles.menuOpenedWindows(childId) = uimenu( ...
        'Parent', aodHandles.menuWindows, ...
        'Tag', ['menuOpenedWindows',num2str(childWindow.ChildHandles.Index)], ...
        'Label', [childWindow.ChildHandles.Name,' ',num2str(childWindow.ChildHandles.Index)], ...
        'Separator','on',...
        'Checked', 'off', ...
        'Callback', {@menuOpenedWindows_Callback,childId,parentWindow});
    
    parentWindow.ParentHandles = aodHandles;
    added = 1;
end

function menuOpenedWindows_Callback(~,~,childIndex,parentWindow)
    childWin = findChild(parentWindow,childIndex);
    try
        if ~isempty(childWin)&& strcmpi(get(childWin.ChildHandles.FigureHandle,'Visible'),'on')
            figure(childWin.ChildHandles.FigureHandle);
        end
    catch
        RemoveFromOpenedWindowsList( parentWindow,childWin);
        delete(childWin);
    end
end