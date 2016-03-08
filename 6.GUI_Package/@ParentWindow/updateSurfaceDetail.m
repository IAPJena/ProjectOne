function updateSurfaceDetail( parentWindow,selectedSurfaceIndex )
    %UPDATESURFACEORCOMPONENTDETAIL Displays the current selected surface
    %or component detail
    
    aodHandles = parentWindow.ParentHandles;
    [ currentOpticalSystem,saved] = getCurrentOpticalSystem (parentWindow);
    
    selectedSurface = currentOpticalSystem.SurfaceArray(selectedSurfaceIndex);
    
    % Display surface parmeters
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Basic');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_Basic = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceBasicParameters, ...
        'Data', surfaceParametersTableDisplay_Basic);
    
    
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Aperture');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_Aperture = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceApertureParameters, ...
        'Data', surfaceParametersTableDisplay_Aperture);
    set(aodHandles.popSurfaceApertureType,'value',selectedSurface.Aperture.Type)
    set(aodHandles.popSurfaceApertureOuterShape,'value',selectedSurface.Aperture.OuterShape)
    set(aodHandles.popSurfaceApertureAdditionalEdgeType,'value',selectedSurface.Aperture.AdditionalEdgeType)
    set(aodHandles.txtSurfaceApertureAdditionalEdge,'String',selectedSurface.Aperture.AdditionalEdge)
    drawAbsolute = selectedSurface.Aperture.DrawAbsolute;
    if drawAbsolute
        drawAbsolute = 1;
    else
        drawAbsolute = 2;
    end
    set(aodHandles.popSurfaceApertureDrawAbsolute,'value',drawAbsolute)
    
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'TiltDecenter');
    editColumn = repmat({' '},[size(paramNames,1),1]);
    surfaceParametersTableDisplay_TiltDecenter = [paramDisplayNames,paramValuesDisp,editColumn];
    set(aodHandles.tblSurfaceTiltDecenterParameters, ...
        'Data', surfaceParametersTableDisplay_TiltDecenter);
    set(aodHandles.popSurfaceTiltDecenterOrder,'value',selectedSurface.TiltDecenterOrder)
    set(aodHandles.popSurfaceTiltMode,'value',selectedSurface.TiltMode)
    
    if isGratingEnabledSurface(selectedSurface)
        set(get(aodHandles.surfaceGratingDataTab,'children'),'enable','on');
        [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
            getSurfaceParameters(selectedSurface,'Grating');
        editColumn = repmat({' '},[size(paramNames,1),1]);
        surfaceParametersTableDisplay_Grating = [paramDisplayNames,paramValuesDisp,editColumn];
        set(aodHandles.tblSurfaceGratingParameters, ...
            'Data', surfaceParametersTableDisplay_Grating);
        set(aodHandles.popGratingType,'value',selectedSurface.Grating.Type)
        diffOrder = (selectedSurface.Grating.DiffractionOrder);
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
    
    if isExtraDataEnabledSurface(selectedSurface)
        set(get(aodHandles.surfaceExtraDataTab,'children'),'enable','on');
        % Extra data
        extraData = selectedSurface.ExtraData;
        surfaceParametersTableDisplay_ExtraData = num2cell(extraData);
        set(aodHandles.tblSurfaceExtraParameters, ...
            'Data', surfaceParametersTableDisplay_ExtraData);
        set(aodHandles.popNumberOfExtraParameters,'value',length(extraData)+1);
    else
        set(aodHandles.tblSurfaceExtraParameters,'Data', []);
        set(aodHandles.popNumberOfExtraParameters,'value',1);
        
        set(get(aodHandles.surfaceExtraDataTab,'children'),'enable','off');
    end
    
    parentWindow.ParentHandles =  aodHandles;
end

