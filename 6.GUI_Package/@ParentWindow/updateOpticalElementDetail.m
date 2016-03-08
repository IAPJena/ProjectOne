function updateOpticalElementDetail( parentWindow,selectedElementIndex )
    %updateOpticalElementDetail Displays the current selected surface or
    %component detail
    
    aodHandles = parentWindow.ParentHandles;
    [ currentOpticalSystem,saved] = getCurrentOpticalSystem (parentWindow);
    
    selectedElement = currentOpticalSystem.OpticalElementArray{selectedElementIndex};
    
    if isSurface(selectedElement)
    % Display surface parmeters
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedElement,'Basic');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_Basic = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceBasicParameters, ...
        'Data', surfaceParametersTableDisplay_Basic);
    
    
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedElement,'Aperture');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_Aperture = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceApertureParameters, ...
        'Data', surfaceParametersTableDisplay_Aperture);
    set(aodHandles.popSurfaceApertureType,'value',selectedElement.Aperture.Type)
    set(aodHandles.popSurfaceApertureOuterShape,'value',selectedElement.Aperture.OuterShape)
    set(aodHandles.popSurfaceApertureAdditionalEdgeType,'value',selectedElement.Aperture.AdditionalEdgeType)
    set(aodHandles.txtSurfaceApertureAdditionalEdge,'String',selectedElement.Aperture.AdditionalEdge)
    drawAbsolute = selectedElement.Aperture.DrawAbsolute;
    if drawAbsolute
        drawAbsolute = 1;
    else
        drawAbsolute = 2;
    end
    set(aodHandles.popSurfaceApertureDrawAbsolute,'value',drawAbsolute)
    
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedElement,'TiltDecenter');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_TiltDecenter = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceTiltDecenterParameters, ...
        'Data', surfaceParametersTableDisplay_TiltDecenter);
    set(aodHandles.popSurfaceTiltDecenterOrder,'value',selectedElement.TiltDecenterOrder)
    set(aodHandles.popSurfaceTiltMode,'value',selectedElement.TiltMode)
    
    if isGratingEnabledSurface(selectedElement)
        set(get(aodHandles.surfaceGratingDataTab,'children'),'enable','on');
        [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
            getSurfaceParameters(selectedElement,'Grating');
        editColumn = repmat({' '},[size(paramNames,1),1]);
        surfaceParametersTableDisplay_Grating = [paramDisplayNames,paramValuesDisp,editColumn];
        set(aodHandles.tblSurfaceGratingParameters, ...
            'Data', surfaceParametersTableDisplay_Grating);
        set(aodHandles.popGratingType,'value',selectedElement.Grating.Type)
        diffOrder = (selectedElement.Grating.DiffractionOrder);
        if diffOrder < 0
            diffOrderIndex = 2; % -ve
        else
            diffOrderIndex = 1; % +ve
        end
        set(aodHandles.popGratingDiffractionOrderSign,'value',diffOrderIndex)
        set(aodHandles.popGratingDiffractionOrder,'value',abs(diffOrder)+1)
    else
        set(get(aodHandles.surfaceGratingDataTab,'children'),'enable','off');
        
        set(aodHandles.tblSurfaceGratingParameters, 'Data', []);
        set(aodHandles.popGratingType,'value',1)
        set(aodHandles.popGratingDiffractionOrderSign,'value',0)
        set(aodHandles.popGratingDiffractionOrder,'value',1)
    end
    
    if isExtraDataEnabledSurface(selectedElement)
        set(get(aodHandles.surfaceExtraDataTab,'children'),'enable','on');
        % Extra data
        extraData = selectedElement.ExtraData;
        surfaceParametersTableDisplay_ExtraData = num2cell(extraData);
        set(aodHandles.tblSurfaceExtraParameters, ...
            'Data', surfaceParametersTableDisplay_ExtraData);
        set(aodHandles.popNumberOfExtraParameters,'value',length(extraData)+1);
    else
        set(aodHandles.tblSurfaceExtraParameters,'Data', []);
        set(aodHandles.popNumberOfExtraParameters,'value',1);
        
        set(get(aodHandles.surfaceExtraDataTab,'children'),'enable','off');
    end
    elseif isComponent(selectedElement)
        % Display component parmeters
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedElement,'Basic');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    componentParametersTableDisplay_Basic = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblComponentBasicParameters, ...
        'Data', componentParametersTableDisplay_Basic);
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedElement,'TiltDecenter');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    componentParametersTableDisplay_TiltDecenter = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblComponentTiltDecenterParameters, ...
        'Data', componentParametersTableDisplay_TiltDecenter);
    else
        
    end
    parentWindow.ParentHandles =  aodHandles;
end

