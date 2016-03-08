function parentWindow = resetSystemConfigurationPanel(parentWindow)
    % resetSystemConfigurationPanel: reset all system configuration data
    % Member of ParentWindow class
    
    aodHandles = parentWindow.ParentHandles;
    
    set(aodHandles.popApertureType,'Value',1);
    set(aodHandles.txtApertureValue,'String', '10');
    set(aodHandles.txtLensName,'String', 'Lens 1');
    set(aodHandles.txtLensNote,'String', 'Note 1');
    set(aodHandles.popLensUnit,'Value',1);
    set(aodHandles.popWavelengthUnit,'Value',2);
    
    % field table
    set(aodHandles.popFieldType,'Value',1);
    set(aodHandles.txtTotalFieldPointsSelected, 'String', '1');
    columnName1 =   {'',' X Field ',' Y Field ',' Weight '};
    ColumnFormat1 = {'logical','numeric','numeric','numeric'};
    columnWidth1 = {'auto','auto','auto','auto'};
    rowName1 = {'numbered'};
    columnEditable1 =  [true,true,true,true];
    initialTable1 = {true,0,0,1;false,0,0,1};
    set(aodHandles.tblFieldPoints, ...
        'Data', initialTable1,...
        'ColumnEditable', columnEditable1,...
        'ColumnName', columnName1,...
        'ColumnFormat',ColumnFormat1,...
        'ColumnWidth',columnWidth1,...
        'RowName',rowName1);
    set(aodHandles.popFieldNormalization,'Value',1);
    
    % wavelength table
    set(aodHandles.popPredefinedWavlens,'Value',1);
    set(aodHandles.popPrimaryWavlenIndex, 'String', 1,'Value',1);
    set(aodHandles.txtTotalWavelengthsSelected, 'String', '1');
    
    columnName1 =   {'',' Wavelength',' Weight '};
    ColumnFormat1 = {'logical','numeric','numeric'};
    columnWidth1 = {'auto','auto','auto'};
    rowName1 = {'numbered'};
    columnEditable1 =  [true,true,true];
    initialTable1 = {true,0.55,1;false,0.55,1};
    set(aodHandles.tblWavelengths, ...
        'Data', initialTable1,...
        'ColumnEditable', columnEditable1,...
        'ColumnName', columnName1,...
        'ColumnFormat',ColumnFormat1,...
        'ColumnWidth',columnWidth1,...
        'RowName',rowName1);
    
    % coating catalogue
    allCoatingCatalogueFullNames = getAllObjectCatalogues('coating');
    if ~isempty(allCoatingCatalogueFullNames)
        [~,allCoatingCatalogueNames,~] = cellfun(@(x) fileparts(x),...
            allCoatingCatalogueFullNames,'UniformOutput',false);
        % append ones in the 1st column for selected
        initialTable1 = [num2cell(ones(size(allCoatingCatalogueFullNames,1),1)),...
            allCoatingCatalogueNames,allCoatingCatalogueFullNames];
        for p = 1:size(initialTable1,1)
            initialTable1{p,1} = logical(initialTable1{p,1});
        end
    else
        initialTable1 = '';
    end
    columnName1 = {'Select','Catalogue Name','Catalogue Full Path'};
    columnWidth1 = {70,150,450};
    columnFormat1 = {'logical','char','char'};
    rowName1 = {'numbered'};
    columnEditable1 =  [true,false,false];
    set(aodHandles.tblCoatingCatalogues, ...
        'Data', initialTable1,...
        'ColumnEditable', columnEditable1,...
        'ColumnName', columnName1,...
        'ColumnFormat',columnFormat1,...
        'ColumnWidth',columnWidth1,...
        'RowName',rowName1);
    set(aodHandles.txtTotalCoatingCataloguesSelected,...
        'String',num2str(size(allCoatingCatalogueFullNames,1),1));
    
    % glass catalogue
    allGlassCatalogueFullNames = getAllObjectCatalogues('glass');
    if ~isempty(allGlassCatalogueFullNames)
        [~,allGlassCatalogueNames,~] = cellfun(@(x) fileparts(x),...
            allGlassCatalogueFullNames,'UniformOutput',false);
        % append ones in the 1st column for selected
        initialTable1 = [num2cell(ones(size(allGlassCatalogueFullNames,1),1)),...
            allGlassCatalogueNames,allGlassCatalogueFullNames];
        for p = 1:size(initialTable1,1)
            initialTable1{p,1} = logical(initialTable1{p,1});
        end
    else
        initialTable1 = '';
    end
    
    columnName1 = {'Select','Catalogue Name','Catalogue Full Path'};
    columnWidth1 = {70,150,450};
    columnFormat1 = {'logical','char','char'};
    rowName1 = {'numbered'};
    columnEditable1 =  [true,false,false];
    set(aodHandles.tblGlassCatalogues, ...
        'Data', initialTable1,...
        'ColumnEditable', columnEditable1,...
        'ColumnName', columnName1,...
        'ColumnFormat',columnFormat1,...
        'ColumnWidth',columnWidth1,...
        'RowName',rowName1);
    set(aodHandles.txtTotalGlassCataloguesSelected,...
        'String',num2str(size(allGlassCatalogueFullNames,1),1));
    
    % Apodization tab
    set(aodHandles.popApodizationType,'value',1);
    set(aodHandles.panelSuperGaussParameters,'Visible','off');
    set(get(aodHandles.panelSuperGaussParameters,'Children'),'Visible','off');
    
    
    parentWindow.ParentHandles = aodHandles;
end