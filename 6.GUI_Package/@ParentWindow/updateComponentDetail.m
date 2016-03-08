function updateComponentDetail( parentWindow,selectedComponentIndex )
    %UPDATESURFACEORCOMPONENTDETAIL Displays the current selected surface
    %or component detail
    
    aodHandles = parentWindow.ParentHandles;
    [ currentOpticalSystem,saved] = getCurrentOpticalSystem (parentWindow);
     selectedComponent = currentOpticalSystem.OpticalElementArray{selectedComponentIndex};
%     selectedComponent = currentOpticalSystem.ComponentArray(selectedComponentIndex);
    
    % Display component parmeters
    [ paramNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedComponent,'Basic');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    componentParametersTableDisplay_Basic = [paramNames,paramValuesDisp,editColumn];
    set(aodHandles.tblComponentBasicParameters, ...
        'Data', componentParametersTableDisplay_Basic);
    
    [ paramNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedComponent,'TiltDecenter');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    componentParametersTableDisplay_TiltDecenter = [paramNames,paramValuesDisp,editColumn];
    set(aodHandles.tblComponentTiltDecenterParameters, ...
        'Data', componentParametersTableDisplay_TiltDecenter);
    parentWindow.ParentHandles = aodHandles;
end

