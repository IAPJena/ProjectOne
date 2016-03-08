function updateMulticonfigurationMenu(parentWindow)
    %UPDATEMULTCONFIGURATIONMENU Summary of this function goes here
    %   Detailed explanation goes here
    
    aodHandles = parentWindow.ParentHandles;
    allOpticalSystems = aodHandles.OpticalSystem;
    nConfiguration = length(allOpticalSystems);
    currentConfig = aodHandles.CurrentConfiguration;
    
    delete((aodHandles.menuSelectConfigurationList));
    delete((aodHandles.menuRemoveConfigurationList));
    for kk = 1:nConfiguration
        lensName = [num2str(kk),' : ',allOpticalSystems(kk).LensName];
        
        aodHandles.menuSelectConfigurationList(kk) = uimenu( ...
            'Parent', aodHandles.menuSelectConfiguration, ...
            'Tag', ['menuSelectConfigurationList',num2str(kk)], ...
            'Label', lensName, ...
            'Separator','off',...
            'Callback', {@menuSelectConfigurationList_Callback,kk,parentWindow});
        if kk == currentConfig
            set(aodHandles.menuSelectConfigurationList(kk),'Checked', 'on');
        else
            set(aodHandles.menuSelectConfigurationList(kk),'Checked', 'off');
        end
        aodHandles.menuRemoveConfigurationList(kk) = uimenu( ...
            'Parent', aodHandles.menuRemoveConfiguration, ...
            'Tag', ['menuRemoveConfigurationList',num2str(kk)], ...
            'Label', lensName, ...
            'Separator','off',...
            'Callback', {@menuRemoveConfigurationList_Callback,kk,parentWindow});
        if kk == currentConfig
            set(aodHandles.menuRemoveConfigurationList(kk),'Checked', 'on');
        else
            set(aodHandles.menuRemoveConfigurationList(kk),'Checked', 'off');
        end
    end
    parentWindow.ParentHandles = aodHandles;
end

function menuSelectConfigurationList_Callback(hObject,~,kk,parentWindow)
    parentWindow.ParentHandles.CurrentConfiguration = kk;
    updateMulticonfigurationMenu(parentWindow);
    updateSystemConfigurationWindow( parentWindow );
    updateQuickLayoutPanel(parentWindow,1);
end
function menuRemoveConfigurationList_Callback(hObject,~,kk,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    allOpticalSystems = aodHandles.OpticalSystem;
    nConfiguration = length(allOpticalSystems);
    currentConfiguration = aodHandles.CurrentConfiguration;
    if nConfiguration > 1
        if kk < currentConfiguration || (kk == currentConfiguration && kk == nConfiguration) % The current configuration index
            % shall be shifted to keep currently displayed configuration unchanged
            aodHandles.CurrentConfiguration = kk-1;
        end
        allOpticalSystems(kk) = [];
        aodHandles.OpticalSystem = allOpticalSystems;
    end
    parentWindow.ParentHandles = aodHandles;
    updateMulticonfigurationMenu(parentWindow);
    updateSystemConfigurationWindow( parentWindow );
    updateQuickLayoutPanel(parentWindow,1);
    
end