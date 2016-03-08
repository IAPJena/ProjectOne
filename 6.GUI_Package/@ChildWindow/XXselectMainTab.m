function selectMainTab(childWindow,ind)
    % Programatically clicks the main tab of the child window with the given index
    % Member of AODChildWindow class
    selectedTabBtnHeight = 0.045;
    selectedTabBtnWidth = 0.12;
    selectedTabBtnColor = [240,240,240]./256;
    tabBtnHeight = 0.04;
    tabBtnWidth = 0.12;
    tabBtnColor = [200,200,200]./256;
    
    for k = 1:childWindow.AODChildHandles.nMainTab
        set(childWindow.AODChildHandles.panelMainTab(k),'Visible', 'off');
        set(get(childWindow.AODChildHandles.panelMainTab(k),'Children'),'Visible', 'off');
        set(childWindow.AODChildHandles.btnMainTab(k),...
            'BackgroundColor',tabBtnColor,...
            'Position', [(k-1)*tabBtnWidth, 0.955, tabBtnWidth, tabBtnHeight]);
    end
    set(childWindow.AODChildHandles.panelMainTab(ind),'Visible', 'on');
    set(get(childWindow.AODChildHandles.panelMainTab(ind),'Children'),'Visible', 'on');
    set(childWindow.AODChildHandles.btnMainTab(ind),...
        'BackgroundColor',selectedTabBtnColor,...
        'Position', [(ind-1)*selectedTabBtnWidth, 0.955, selectedTabBtnWidth, selectedTabBtnHeight]);
end