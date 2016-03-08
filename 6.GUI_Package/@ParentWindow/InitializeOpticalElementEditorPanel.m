function InitializeOpticalElementEditorPanel( parentWindow )
    %INITIALIZESURFACEEDITORPANEL Define and initialized the uicontrols of the
    % Surface Editor Panel
    % Member of ParentWindow class
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    
    fontSize = aodHandles.FontSize;
    fontName = aodHandles.FontName;
    
    %% Divide the area in to surface list panel, and surf detail
    % ( surf figure, surf description and surface parameters) panel
    aodHandles.panelOpticalElementList = uipanel(...
        'Parent',aodHandles.panelOpticalElementEditorMain,...
        'FontSize',fontSize,'FontName', fontName,...
        'Title','Surface List',...
        'units','normalized',...
        'Position',[0.0,0.0,0.5,1.0]);
    %% Surface Deatil Window
    aodHandles.panelSurfaceDetail = uipanel(...
        'Parent',aodHandles.panelOpticalElementEditorMain,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.5,0.0,0.5,1.0],...
        'visible','on');
    
    aodHandles.surfaceParametersTabGroup = uitabgroup(...
        'Parent', aodHandles.panelSurfaceDetail, ...
        'Units', 'Normalized', ...
        'Position', [0,0.0,1.0,1.0]);
    aodHandles.surfBasicDataTab = ...
        uitab(aodHandles.surfaceParametersTabGroup, 'title','Standard Data');
    aodHandles.surfaceApertureDataTab = ...
        uitab(aodHandles.surfaceParametersTabGroup, 'title','Aperture Data');
    aodHandles.surfaceTiltDecenterDataTab = ...
        uitab(aodHandles.surfaceParametersTabGroup, 'title','Tilt Decenter Data');
    aodHandles.surfaceGratingDataTab = ...
        uitab(aodHandles.surfaceParametersTabGroup, 'title','Grating Ruling Data');
    aodHandles.surfaceExtraDataTab = ...
        uitab(aodHandles.surfaceParametersTabGroup, 'title','Extra Data');
    
    % Initialize the ui table for OpticalElementList
    aodHandles.tblOpticalElementList = uitable('Parent',aodHandles.panelOpticalElementList,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.93]);
    
    % Command buttons for adding and removing surfaces
    aodHandles.btnInsertElement = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Style', 'pushbutton', ...
        'FontSize',fontSize+5,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.01,0.95,0.07,0.04],...
        'String','+',...
        'Callback',{@btnInsertElement_Callback,parentWindow});
    aodHandles.btnRemoveElement = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Style', 'pushbutton', ...
        'FontSize',fontSize+5,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.08,0.95,0.07,0.04],...
        'String','-',...
        'Callback',{@btnRemoveElement_Callback,parentWindow});
    
    updatedSystem = aodHandles.OpticalSystem(currentConfig);
    updatedSystem.SurfaceArray = updateSurfaceCoordinateTransformationMatrices(aodHandles.OpticalSystem(currentConfig).SurfaceArray);

    nSurface = getNumberOfSurfaces(updatedSystem);
    stopComponentIndex = getStopElementIndex(updatedSystem.OpticalElementArray);
    
    aodHandles.lblStopElementIndex = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Tag', 'lblStopElementIndex', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Stop Comp. ',...
        'units','normalized',...
        'Position',[0.15,0.94,0.30,0.04]);
    
    aodHandles.popStopElementIndex = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Tag', 'popStopElementIndex', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', [num2cell(1:nSurface)],...
        'Value',stopComponentIndex,...
        'units','normalized',...
        'Position',[0.45,0.937,0.15,0.05]);
    
    aodHandles.lblStopSurfaceInComponentIndex = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Tag', 'lblStopElementIndex', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Surface',...
        'units','normalized',...
        'Position',[0.62,0.94,0.22,0.04]);
    
    nSurfaceInComponent = 1;
    stopSurfaceInComponentIndex = 1;
    aodHandles.popStopSurfaceInComponentIndex = uicontrol( ...
        'Parent',aodHandles.panelOpticalElementList,...
        'Tag', 'popStopElementIndex', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', [num2cell(1:nSurfaceInComponent)],...
        'Value',stopSurfaceInComponentIndex,...
        'units','normalized',...
        'Position',[0.82,0.937,0.12,0.05]);
    
    
    % Set  celledit and cellselection callbacks
    set(aodHandles.tblOpticalElementList,...
        'CellSelectionCallback',{@tblOpticalElementList_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblOpticalElementList_CellEditCallback,parentWindow});
    
    set(aodHandles.popStopElementIndex,...
        'Callback',{@popStopElementIndex_Callback,parentWindow});
    
    set(aodHandles.popStopSurfaceInComponentIndex,...
        'Callback',{@popStopSurfaceInComponentIndex_Callback,parentWindow});
    
    % Initialize the ui table and other UI controls for surface parameters
    aodHandles.tblSurfaceBasicParameters = uitable('Parent',aodHandles.surfBasicDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 1]);
    
    aodHandles.tblSurfaceApertureParameters = uitable('Parent',aodHandles.surfaceApertureDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.71]);
    % Aperture Type popup
    aodHandles.lblSurfaceApertureType = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'lblSurfaceApertureType', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Aperture Type ',...
        'units','normalized',...
        'Position',[0.0,0.9175,0.45,0.05]);
    [~,supportedSurfaceApertureTypes] = GetSupportedSurfaceApertureTypes();
    aodHandles.popSurfaceApertureType = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'popSurfaceApertureType', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedSurfaceApertureTypes,...
        'units','normalized',...
        'Position',[0.5,0.92,0.475,0.05]);
    % Surface aperture outer shape popup
    aodHandles.lblSurfaceApertureOuterShape = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'lblSurfaceApertureOuterShape', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Outer Shape ',...
        'units','normalized',...
        'Position',[0.0,0.8575,0.45,0.05]);
    [~,supportedSurfaceApertureOuterShapes] = GetSupportedSurfaceApertureOuterShapes();
    aodHandles.popSurfaceApertureOuterShape = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'popSurfaceApertureOuterShape', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedSurfaceApertureOuterShapes,...
        'units','normalized',...
        'Position',[0.5,0.86,0.475,0.05]);
    % Surface aperture additional edge
    aodHandles.lblSurfaceApertureAdditionalEdge  = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'lblSurfaceApertureAdditionalEdge', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Additional Edge ',...
        'units','normalized',...
        'Position',[0.0,0.80,0.45,0.05]);
    [~,supportedSurfaceApertureAdditionalEdgeType] = GetSurfaceApertureAdditionalEdgeType();
    aodHandles.popSurfaceApertureAdditionalEdgeType = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'popSurfaceApertureAdditionalEdgeType', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedSurfaceApertureAdditionalEdgeType,...
        'units','normalized','enable','off',...
        'Position',[0.5,0.81,0.225,0.04]);
    aodHandles.txtSurfaceApertureAdditionalEdge = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'txtSurfaceApertureAdditionalEdge', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'edit', ...
        'BackgroundColor', [1 1 1], ...
        'String', '0.0',...
        'units','normalized',...
        'Position',[0.725,0.816,0.255,0.035]);
    % Surface aperture draw absolute popup
    aodHandles.lblSurfaceApertureDrawAbsolute = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'lblSurfaceApertureDrawAbsolute', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Draw Absolute ',...
        'units','normalized',...
        'Position',[0.0,0.7275,0.45,0.05]);
    [supportedSurfaceApertureDrawAbsolute] = {'True','False'};
    aodHandles.popSurfaceApertureDrawAbsolute = uicontrol( ...
        'Parent',aodHandles.surfaceApertureDataTab,...
        'Tag', 'popSurfaceApertureDrawAbsolute', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedSurfaceApertureDrawAbsolute,...
        'units','normalized',...
        'Position',[0.5,0.73,0.475,0.05]);
    
    aodHandles.tblSurfaceTiltDecenterParameters = uitable('Parent',aodHandles.surfaceTiltDecenterDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.84]);
    % Tilt order popup
    aodHandles.lblSurfaceTiltDecenterOrder = uicontrol( ...
        'Parent',aodHandles.surfaceTiltDecenterDataTab,...
        'Tag', 'lblSurfaceTiltDecenterOrder', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Tilt Decenter Order ',...
        'units','normalized',...
        'Position',[0.0,0.9175,0.45,0.05]);
    [~,supportedTiltDecenterOrders] = GetSupportedTiltDecenterOrder();
    aodHandles.popSurfaceTiltDecenterOrder = uicontrol( ...
        'Parent',aodHandles.surfaceTiltDecenterDataTab,...
        'Tag', 'popSurfaceTiltDecenterOrder', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedTiltDecenterOrders,...
        'units','normalized',...
        'Position',[0.5,0.92,0.475,0.05]);
    % Tilt mode popup
    aodHandles.lblSurfaceTiltMode = uicontrol( ...
        'Parent',aodHandles.surfaceTiltDecenterDataTab,...
        'Tag', 'lblSurfaceTiltMode', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Tilt Mode ',...
        'units','normalized',...
        'Position',[0.0,0.8575,0.45,0.05]);
    [~,supportedTiltModes] = GetSupportedTiltModes();
    aodHandles.popSurfaceTiltMode = uicontrol( ...
        'Parent',aodHandles.surfaceTiltDecenterDataTab,...
        'Tag', 'popSurfaceTiltMode', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedTiltModes,...
        'units','normalized',...
        'Position',[0.5,0.86,0.475,0.05]);
    
    
    aodHandles.tblSurfaceGratingParameters = uitable('Parent',aodHandles.surfaceGratingDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.84]);
    aodHandles.lblGratingType = uicontrol( ...
        'Parent',aodHandles.surfaceGratingDataTab,...
        'Tag', 'lblGratingType', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Grating Type ',...
        'units','normalized',...
        'Position',[0.0,0.9175,0.45,0.05]);
    [~,supportedGratingTypes] = GetSupportedGratingTypes();
    aodHandles.popGratingType = uicontrol( ...
        'Parent',aodHandles.surfaceGratingDataTab,...
        'Tag', 'popGratingType', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedGratingTypes,...
        'units','normalized',...
        'Position',[0.5,0.92,0.475,0.05]);
    
    aodHandles.lblGratingDiffractionOrder = uicontrol( ...
        'Parent',aodHandles.surfaceGratingDataTab,...
        'Tag', 'lblGratingDiffractionOrder', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Diffraction Order ',...
        'units','normalized',...
        'Position',[0.0,0.8575,0.45,0.05]);
    aodHandles.popGratingDiffractionOrderSign = uicontrol( ...
        'Parent',aodHandles.surfaceGratingDataTab,...
        'Tag', 'popGratingDiffractionOrderSign', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', {'+','-'},...
        'units','normalized',...
        'Position',[0.5,0.86,0.15,0.05]);
    maxNumberOfOrder = 10;
    aodHandles.popGratingDiffractionOrder = uicontrol( ...
        'Parent',aodHandles.surfaceGratingDataTab,...
        'Tag', 'popGratingDiffractionOrder', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', num2cell([0:maxNumberOfOrder]),...
        'units','normalized',...
        'Position',[0.65,0.86,0.325,0.05]);
    
    aodHandles.tblSurfaceExtraParameters = uitable('Parent',aodHandles.surfaceExtraDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.90]);
    aodHandles.lblNumberOfExtraParameters = uicontrol( ...
        'Parent',aodHandles.surfaceExtraDataTab,...
        'Tag', 'lblNumberOfExtraParameters', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Number Of Extra Parameters ',...
        'units','normalized',...
        'Position',[0.0,0.9175,0.65,0.05]);
    maxNumberOfExtraParameter = 100;
    aodHandles.popNumberOfExtraParameters = uicontrol( ...
        'Parent',aodHandles.surfaceExtraDataTab,...
        'Tag', 'txtNumberOfExtraParameters', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', num2cell([0:maxNumberOfExtraParameter]),...
        'units','normalized',...
        'Position',[0.7,0.92,0.275,0.05]);
    
    
    %     Set  celledit and cellselection callbacks
    set(aodHandles.tblSurfaceBasicParameters,...
        'CellSelectionCallback',{@tblSurfaceBasicParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblSurfaceBasicParameters_CellEditCallback,parentWindow});
    set(aodHandles.tblSurfaceApertureParameters,...
        'CellSelectionCallback',{@tblSurfaceApertureParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblSurfaceApertureParameters_CellEditCallback,parentWindow});
    set(aodHandles.popSurfaceApertureType,...
        'Callback',{@popSurfaceApertureType_Callback,parentWindow});
    set(aodHandles.popSurfaceApertureOuterShape,...
        'Callback',{@popSurfaceApertureOuterShape_Callback,parentWindow});
    set(aodHandles.txtSurfaceApertureAdditionalEdge,...
        'Callback',{@txtSurfaceApertureAdditionalEdge_Callback,parentWindow});
    set(aodHandles.popSurfaceApertureAdditionalEdgeType,...
        'Callback',{@popSurfaceApertureAdditionalEdgeType_Callback,parentWindow});
    set(aodHandles.popSurfaceApertureDrawAbsolute,...
        'Callback',{@popSurfaceApertureDrawAbsolute_Callback,parentWindow});
    
    
    
    set(aodHandles.tblSurfaceTiltDecenterParameters,...
        'CellSelectionCallback',{@tblSurfaceTiltDecenterParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblSurfaceTiltDecenterParameters_CellEditCallback,parentWindow});
    set(aodHandles.popSurfaceTiltDecenterOrder,...
        'Callback',{@popSurfaceTiltDecenterOrder_Callback,parentWindow});
    set(aodHandles.popSurfaceTiltMode,...
        'Callback',{@popSurfaceTiltMode_Callback,parentWindow});
    
    set(aodHandles.tblSurfaceGratingParameters,...
        'CellSelectionCallback',{@tblSurfaceGratingParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblSurfaceGratingParameters_CellEditCallback,parentWindow});
    set(aodHandles.popGratingType,...
        'Callback',{@popGratingType_Callback,parentWindow});
    set(aodHandles.popGratingDiffractionOrderSign,...
        'Callback',{@popGratingDiffractionOrderSign_Callback,parentWindow});
    set(aodHandles.popGratingDiffractionOrder,...
        'Callback',{@popGratingDiffractionOrder_Callback,parentWindow});
    
    set(aodHandles.tblSurfaceExtraParameters,...
        'CellSelectionCallback',{@tblSurfaceExtraParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblSurfaceExtraParameters_CellEditCallback,parentWindow});
    set(aodHandles.popNumberOfExtraParameters,...
        'Callback',{@popNumberOfExtraParameters_Callback,parentWindow});
    
    supportedSurfaces = GetSupportedSurfaceTypes();
    columnName1 =   {'','Element','Type', 'Name/Note'};
    columnWidth1 = {70,100,150, 100};
    columnEditable1 =  [false,true,true,true];
    columnFormat1 =  {'char',{'SURF','COMP'},{supportedSurfaces{:}}, 'char'};
    initialTable1 = {'OBJ','SURF','OBJECT','Object';...
        'STOP','SURF','Standard',  '';...
        'IMG','SURF','IMAGE', 'Image'};
    set(aodHandles.tblOpticalElementList, ...
        'ColumnFormat',columnFormat1,...
        'Data', initialTable1,'ColumnEditable', columnEditable1,...
        'ColumnName', columnName1,'ColumnWidth',columnWidth1);
    
    
    % reset surface parameter tables
    columnName2 =   {'Parameters', 'Value', 'Solve'};
    columnWidth2 = {150, 100 70};
    columnEditable2 =  [false true false];
    columnFormat2 =  {'char', 'char','char'};
    initialTable2 = {'Param 1','0',' '};
    set(aodHandles.tblSurfaceBasicParameters, ...
        'ColumnFormat',columnFormat2,...
        'Data', initialTable2,'ColumnEditable', columnEditable2,...
        'ColumnName', columnName2,'ColumnWidth',columnWidth2);
    set(aodHandles.tblSurfaceApertureParameters, ...
        'ColumnFormat',columnFormat2,...
        'Data', initialTable2,'ColumnEditable', columnEditable2,...
        'ColumnName', columnName2,'ColumnWidth',columnWidth2);
    set(aodHandles.tblSurfaceTiltDecenterParameters, ...
        'ColumnFormat',columnFormat2,...
        'Data', initialTable2,'ColumnEditable', columnEditable2,...
        'ColumnName', columnName2,'ColumnWidth',columnWidth2);
    set(aodHandles.tblSurfaceGratingParameters, ...
        'ColumnFormat',columnFormat2,...
        'Data', initialTable2,'ColumnEditable', columnEditable2,...
        'ColumnName', columnName2,'ColumnWidth',columnWidth2);
    
    columnName3 =   {'Parameters'};
    columnWidth3 = {150};
    columnEditable3 =  [true];
    columnFormat3 =  {'numeric'};
    initialTable3 = {[0]};
    set(aodHandles.tblSurfaceExtraParameters, ...
        'ColumnFormat',columnFormat3,...
        'Data', initialTable3,'ColumnEditable', columnEditable3,...
        'ColumnName', columnName3,'ColumnWidth',columnWidth3);
    
    
    %% Component Deatil Window
    aodHandles.panelComponentDetail = uipanel(...
        'Parent',aodHandles.panelOpticalElementEditorMain,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.5,0.0,0.5,1.0],...
        'visible','off');
    
    aodHandles.componentParametersTabGroup = uitabgroup(...
        'Parent', aodHandles.panelComponentDetail, ...
        'Units', 'Normalized', ...
        'Position', [0,0.0,1.0,1.0]);
    aodHandles.componentBasicDataTab = ...
        uitab(aodHandles.componentParametersTabGroup, 'title','Standard Data');
    
    aodHandles.tblComponentBasicParameters = uitable('Parent',aodHandles.componentBasicDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 1]);
    
    aodHandles.componentTiltDecenterDataTab = ...
        uitab(aodHandles.componentParametersTabGroup, 'title','Tilt Decenter Data');
    
    % Tilt order popup
    aodHandles.lblComponentTiltDecenterOrder = uicontrol( ...
        'Parent',aodHandles.componentTiltDecenterDataTab,...
        'Tag', 'lblComponentTiltDecenterOrder', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Tilt Decenter Order ',...
        'units','normalized',...
        'Position',[0.0,0.9175,0.45,0.05]);
    [~,supportedTiltDecenterOrders] = GetSupportedTiltDecenterOrder();
    aodHandles.popComponentTiltDecenterOrder = uicontrol( ...
        'Parent',aodHandles.componentTiltDecenterDataTab,...
        'Tag', 'popComponentTiltDecenterOrder', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedTiltDecenterOrders,...
        'units','normalized',...
        'Position',[0.5,0.92,0.475,0.05]);
    % Tilt mode popup
    aodHandles.lblComponentTiltMode = uicontrol( ...
        'Parent',aodHandles.componentTiltDecenterDataTab,...
        'Tag', 'lblComponentTiltMode', ...
        'Style', 'text', ...
        'HorizontalAlignment','right',...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'String', 'Tilt Mode ',...
        'units','normalized',...
        'Position',[0.0,0.8575,0.45,0.05]);
    [~,supportedTiltModes] = GetSupportedTiltModes();
    aodHandles.popComponentTiltMode = uicontrol( ...
        'Parent',aodHandles.componentTiltDecenterDataTab,...
        'Tag', 'popComponentTiltMode', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style', 'popupmenu', ...
        'BackgroundColor', [1 1 1], ...
        'String', supportedTiltModes,...
        'units','normalized',...
        'Position',[0.5,0.86,0.475,0.05]);
    aodHandles.tblComponentTiltDecenterParameters = uitable('Parent',aodHandles.componentTiltDecenterDataTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 0.84]);
    
    
    %     Set  celledit and cellselection callbacks
    set(aodHandles.tblComponentBasicParameters,...
        'CellSelectionCallback',{@tblComponentBasicParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblComponentBasicParameters_CellEditCallback,parentWindow});
    set(aodHandles.tblComponentTiltDecenterParameters,...
        'CellSelectionCallback',{@tblComponentTiltDecenterParameters_CellSelectionCallback,parentWindow},...
        'CellEditCallback',{@tblComponentTiltDecenterParameters_CellEditCallback,parentWindow});
    
    set(aodHandles.popComponentTiltDecenterOrder,...
        'Callback',{@popComponentTiltDecenterOrder_Callback,parentWindow});
    set(aodHandles.popComponentTiltMode,...
        'Callback',{@popComponentTiltMode_Callback,parentWindow});
    
    % reset component parameter tables
    columnName5 =   {'Parameters', 'Value', 'Solve'};
    columnWidth5= {150, 100 70};
    columnEditable5 =  [false true false];
    columnFormat5=  {'char', 'char','char'};
    initialTable5 = {'Param 1','0',' '};
    set(aodHandles.tblComponentBasicParameters, ...
        'ColumnFormat',columnFormat5,...
        'Data', initialTable5,'ColumnEditable', columnEditable5,...
        'ColumnName', columnName5,'ColumnWidth',columnWidth5);
    set(aodHandles.tblComponentTiltDecenterParameters, ...
        'ColumnFormat',columnFormat5,...
        'Data', initialTable5,'ColumnEditable', columnEditable5,...
        'ColumnName', columnName5,'ColumnWidth',columnWidth5);
    
    
    
    % Give all tables initial data
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateSystemConfigurationWindow( parentWindow );
    updateQuickLayoutPanel(parentWindow,1);
end

% Local functions
function btnInsertElement_Callback(~,~,parentWindow)

    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    
    selectedElementIndex = aodHandles.SelectedElementIndex;
    canAddElement = aodHandles.CanAddElement;
    
    if canAddElement
        insertPosition = selectedElementIndex;
        InsertNewElement(parentWindow,'Standard','Standard',insertPosition);
        aodHandles = parentWindow.ParentHandles;
    end
end
function btnRemoveElement_Callback(~,~,parentWindow)

    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    
    selectedElementIndex = aodHandles.SelectedElementIndex;
    canRemoveElement = aodHandles.CanRemoveElement;
    
    if canRemoveElement
        % Confirm action
        % Construct a questdlg with three options
        choice = questdlg('Are you sure to delete the surface?', ...
            'Confirm Deletion', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                % Delete the surface
                removePosition = selectedElementIndex;
                RemoveElement(parentWindow,removePosition);
                aodHandles = parentWindow.ParentHandles;
            case 'No'
                % Mark the delete box again
        end
    else
        % Mark the delete box again
    end
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
end
function popStopElementIndex_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    
    currentOpticalSystem = aodHandles.OpticalSystem(currentConfig);
    prevStopIndex = getStopElementIndex(currentOpticalSystem.OpticalElementArray );
    newStopIndex = get(hObject,'Value');
    if newStopIndex == 1 || newStopIndex == getNumberOfSurfaces(currentOpticalSystem) % Object and image can not be Stop
        newStopIndex = prevStopIndex;
    end
    if newStopIndex ~= prevStopIndex
        aodHandles.OpticalSystem(currentConfig).OpticalElementArray{prevStopIndex}.StopSurfaceIndex = 0;
        aodHandles.OpticalSystem(currentConfig).OpticalElementArray{newStopIndex}.StopSurfaceIndex = 1;
    end
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , newStopIndex);
    updateQuickLayoutPanel(parentWindow,newStopIndex);
end

% Cell select and % CellEdit Callback
function tblOpticalElementList_CellSelectionCallback(~, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedCell = eventdata.Indices;
    if isempty(selectedCell)
        return
    end
    selectedElementIndex = selectedCell(1);
    aodHandles.SelectedElementIndex = selectedElementIndex;
    tblData = get(aodHandles.tblOpticalElementList,'data');
    sizeTblData = size(tblData);
    selectedElement =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    
    if isSurface(selectedElement)
        columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedSurfaceTypes(), 'char'};
        set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
    elseif isComponent(selectedElement)
        columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedComponentTypes(), 'char'};
        set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
    else
    end
    if selectedElementIndex == 1 % object surf
        aodHandles.CanRemoveElement = 0;
        aodHandles.CanAddElement = 0;
        % make the 2nd column uneditable
        columnEditable1 = [false,false,false,true];
        set(aodHandles.tblOpticalElementList,'ColumnEditable', columnEditable1);
    elseif selectedElementIndex == sizeTblData(1)% image surf
        aodHandles.CanRemoveElement = 0;
        aodHandles.CanAddElement = 1;
        % make the 2nd column uneditable
        columnEditable1 = [false,false,false,true];
        set(aodHandles.tblOpticalElementList,'ColumnEditable', columnEditable1);
    elseif sizeTblData(1) == 3 % only 3 surfaces left
        aodHandles.CanRemoveElement = 0;
        aodHandles.CanAddElement = 1;
        % make the 2nd column editable
        columnEditable1 = [false,true,true,true];
        set(aodHandles.tblOpticalElementList,'ColumnEditable', columnEditable1);
    else
        aodHandles.CanRemoveElement = 1;
        aodHandles.CanAddElement = 1;
        % make the 2nd column editable
        columnEditable1 = [false,true,true,true];
        set(aodHandles.tblOpticalElementList,'ColumnEditable', columnEditable1);
    end
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    % Show the surface parameters in the surface detail window
    parentWindow.ParentHandles = aodHandles;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
end
function tblOpticalElementList_CellEditCallback(hObject, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblOpticalElementList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    
    selectedElementIndex = selectedRow;
    aodHandles.SelectedElementIndex = selectedElementIndex;
    tblData1 = get(aodHandles.tblOpticalElementList,'data');
    nElement = size(tblData1,1);
    selectedElement =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    
    if isSurface(selectedElement)
        columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedSurfaceTypes(), 'char'};
        set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
    elseif isComponent(selectedElement)
        columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedComponentTypes(), 'char'};
        set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
    else
    end
    
    if selectedCol== 2 % element type changed
        if selectedRow == 1||selectedRow == nElement % Object or image
            % for object or image surf surf change the surf type back to OBJECT or
            % IMAGE
            tblData1{1,2} = 'SURF';
            tblData1{nElement,2} = 'SURF';
            set(aodHandles.tblOpticalElementList, 'Data', tblData1);
            columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedSurfaceTypes(), 'char'};
            set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
        else

            % reset the surface type in the surface detail window
            selectedElementTypeString = eventdata.NewData;
            %newSurface = Surface(selectedSurfaceType);
            oldElement = selectedElement;
            
            if isSurface(oldElement)
                if strcmpi(selectedElementTypeString,'SURF')
                    % Surf to surf map
                    
                else
                    columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedComponentTypes(), 'char'};
                    set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
                    % Surf to comp map
                    newElement = Component('SequenceOfSurfaces');
                    modifiedElement = newElement;
                    % Keep common properties of the component
                    modifiedElement.Comment = oldElement.Comment ;
                    modifiedElement.StopSurfaceIndex = oldElement.StopSurfaceIndex ;
                    modifiedElement.FirstTiltDecenterOrder = oldElement.TiltDecenterOrder ;
                    modifiedElement.FirstTilt = oldElement.Tilt ;
                    modifiedElement.FirstDecenter = oldElement.Decenter ;
                    modifiedElement.ComponentTiltMode = oldElement.TiltMode ;
                    modifiedElement.LastThickness = oldElement.Thickness ;
                    modifiedElement.UniqueParameters.SurfaceArray = oldElement;
                    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedRow} = modifiedElement;
                end
            elseif isComponent(oldElement)
                if strcmpi(selectedElementTypeString,'COMP')
                    % Comp to comp map
                    
                else
                    % Confirm action
                    % Construct a questdlg with three options
                    choice = questdlg('Are you sure to convert the component to its surfaces. The process can not be reversed?', ...
                        'Confirm Conversion', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            % Convert the component to its surfaces
                            columnFormat1 =  {'char',{'SURF','COMP'},GetSupportedSurfaceTypes(), 'char'};
                            set(aodHandles.tblOpticalElementList,'ColumnFormat', columnFormat1);
                            % Comp to surf map
                            componentSurfaceArray = getComponentSurfaceArray(oldElement);
                            nCompSurf = length(componentSurfaceArray);
                            componentSurfaceCellArray = cell(1,nCompSurf);
                            for pp = 1:nCompSurf
                                componentSurfaceCellArray{pp} = componentSurfaceArray(pp);
                            end
                            nTotalElem = length(aodHandles.OpticalSystem(currentConfig).OpticalElementArray);
                            
                            elementArrayAfterThisElement = aodHandles.OpticalSystem(currentConfig).OpticalElementArray(selectedRow+1:end);
                            aodHandles.OpticalSystem(currentConfig).OpticalElementArray(selectedRow:selectedRow+nCompSurf-1) = componentSurfaceCellArray;
                            aodHandles.OpticalSystem(currentConfig).OpticalElementArray(selectedRow+nCompSurf:nTotalElem+nCompSurf-1) = elementArrayAfterThisElement;
                            
                        case 'No'
                            % Mark the delete box again
                    end
                end
            else
                
            end
            
        end
    elseif selectedCol== 3 % surface type changed
        if selectedRow == 1||selectedRow == nElement % Object or image
            % for object or image surf surf change the surf type back to OBJECT or
            % IMAGE
            tblData1{nElement,2} = 'IMAGE';
            set(aodHandles.tblOpticalElementList, 'Data', tblData1);
        else

            selectedElement = selectedElement;
            if isSurface(selectedElement)
                % reset the surface type in the surface detail window
                selectedSurfaceTypeString = eventdata.NewData;
                oldSurface = aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedRow};
                % Add the new surf onet to the temporary surfaceArray
                if oldSurface.StopSurfaceIndex
                    if strcmpi(selectedSurfaceTypeString,'Dummy')
                        % Stop surface can not be dummy
                        disp('Error: Stop surface can not be dummy. So please change the stop surface first.');
                        tblData1 = get(aodHandles.tblOpticalElementList,'data');
                        tblData1{selectedRow,2} = eventdata.PreviousData;
                        set(aodHandles.tblOpticalElementList, 'Data', tblData1);
                        return;
                    else
                        newSurface = Surface(selectedSurfaceTypeString);
                    end
                    newSurface.StopSurfaceIndex = 1;
                else
                    newSurface = Surface(selectedSurfaceTypeString);
                end
                %
                modifiedSurface = oldSurface;
                modifiedSurface.Type = newSurface.Type;
                modifiedSurface.UniqueParameters = newSurface.UniqueParameters;
                
                aodHandles.OpticalSystem(currentConfig).SurfaceArray(selectedRow) = modifiedSurface;
                modifiedElement = modifiedSurface;
                % Keep common properties of the surface
            elseif isComponent(selectedElement)
                % reset the surface type in the surface detail window
                selectedComponentTypeString = eventdata.NewData;
                oldComponent = selectedElement;
                % Add the new surf onet to the temporary surfaceArray
                if oldComponent.StopSurfaceIndex
                    newComponent = Component(selectedComponentTypeString);
                    newComponent.StopSurfaceIndex = 1;
                else
                    newComponent = Component(selectedComponentTypeString);
                end
                %
                modifiedComponent = oldComponent;
                modifiedComponent.Type = newComponent.Type;
                modifiedComponent.UniqueParameters = newComponent.UniqueParameters;
                modifiedElement = modifiedComponent;
                % Keep common properties of the surface
            else
            end
            aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedRow} = modifiedElement;
        end
    elseif selectedCol== 3 % surface comment changed
        aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedRow}.Comment = eventdata.NewData;
    end
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
end

function tblSurfaceBasicParameters_CellSelectionCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblOpticalElementList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    
    if selectedCol ~= 2
        return;
    end
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Basic',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType) && length(myType)>1
        % type is choice of popmenu
        aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = choice;
        newParamDisp = myType{choice};
        % Update the surface parameter and surface editor
        if selectedRow <=3
            selectedSurface.(myName) = newParam;
        else
            selectedSurface.UniqueParameters.(myName) = newParam;
        end
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
            trueFalse = {'1','0'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            newParamDisp = newParam;
            
            % Update the surface parameter and surface editor
            if selectedRow <=3
                selectedSurface.(myName) = newParam;
            else
                selectedSurface.UniqueParameters.(myName) = newParam;
            end
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)||...
                strcmpi('Glass',myType) || strcmpi('Coating',myType)
        elseif strcmpi('numericVector',myType)
            tempNumericVector = selectedSurface.UniqueParameters.(myName);
            tempNumericVectorVariableFlag = 0*tempNumericVector;
            % Open the numericVector data editor window.            
            waitfor(numericVectorDataInputGUI(tempNumericVector,tempNumericVectorVariableFlag,myName));
            
            tempNumericVectorNew = getappdata(0,'tempNumericVector');
            tempNumericVectorVariableFlagNew = getappdata(0,'tempNumericVectorVariableFlag');
            
            selectedSurface.UniqueParameters.(myName) = tempNumericVectorNew;
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblSurfaceApertureParameters_CellSelectionCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblOpticalElementList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    if selectedCol ~= 2
        return;
    end
    [ paramNames,paramDispNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Aperture',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType)&& length(myType)>1
        % type is choice of popmenu
        aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = choice;
        newParamDisp = myType{choice};
        % Update the surface parameter and surface editor
        if selectedRow == 1
            % A new type with defualt parameter
            selectedSurface.Aperture = Aperture(newParam);
        elseif selectedRow <=7
            selectedSurface.Aperture.(myName) = newParam;
        else
            selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
        end
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
            trueFalse = {'0','1'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            
            newParamDisp = newParam;
            
            % Update the surface parameter and surface editor
            if selectedRow == 1
                % A new type with defualt parameter
                selectedSurface.Aperture = Aperture(newParam);
            elseif selectedRow <=7
                selectedSurface.Aperture.(myName) = newParam;
            else
                selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
            end
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)
            
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popSurfaceApertureType_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    oldAperture = selectedSurface.Aperture;
    selectedSurfaceApertureType = GetSupportedSurfaceApertureTypes(get(hObject,'value'));
    newAperture = Aperture(selectedSurfaceApertureType);
    % If possible try to map the old aperture values to the new aperture.
    switch (oldAperture.Type)
        case 1 %lower('FloatingCircularAperture')
            switch (newAperture.Type)
                case 1 %lower('FloatingCircularAperture')
                    newAperture.UniqueParameters.Diameter = oldAperture.UniqueParameters.Diameter;
                case 2 %lower('CircularAperture')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.Diameter;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                case 3 %lower('RectangularAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.Diameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.Diameter;
                case 4 %lower('EllipticalAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.Diameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.Diameter;
                case 5 %lower('CircularObstruction')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.Diameter;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                otherwise
            end
        case 2 %lower('CircularAperture')
            switch lower(newAperture.Type)
                case 1 %lower('FloatingCircularAperture')
                    newAperture.UniqueParameters.Diameter = oldAperture.UniqueParameters.LargeDiameter;
                case 2 %lower('CircularAperture')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.SmallDiameter = oldAperture.UniqueParameters.SmallDiameter;
                case 3 %lower('RectangularAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.LargeDiameter;
                case 4 %lower('EllipticalAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.LargeDiameter;
                case 5 %lower('CircularObstruction')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.SmallDiameter = oldAperture.UniqueParameters.SmallDiameter;
                otherwise
            end
        case 3 %lower('RectangularAperture')
            switch (newAperture.Type)
                case 1 %lower('FloatingCircularAperture')
                    newAperture.UniqueParameters.Diameter = oldAperture.UniqueParameters.DiameterX;
                case 2 %lower('CircularAperture')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                case 3 %lower('RectangularAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.DiameterY;
                case 4 %lower('EllipticalAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.DiameterY;
                case 5 %lower('CircularObstruction')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                otherwise
            end
        case 4 %lower('EllipticalAperture')
            switch (newAperture.Type)
                case 1 %lower('FloatingCircularAperture')
                    newAperture.UniqueParameters.Diameter = oldAperture.UniqueParameters.DiameterX;
                case 2 %lower('CircularAperture')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                case 3 %lower('RectangularAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.DiameterY;
                case 4 %lower('EllipticalAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.DiameterY;
                case 5 %lower('CircularObstruction')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.DiameterX;
                    newAperture.UniqueParameters.SmallDiameter = 0;
                otherwise
            end
        case 5 %lower('CircularObstruction')
            switch (newAperture.Type)
                case 1 %lower('FloatingCircularAperture')
                    newAperture.UniqueParameters.Diameter = oldAperture.UniqueParameters.LargeDiameter;
                case 2 %lower('CircularAperture')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.SmallDiameter = oldAperture.UniqueParameters.SmallDiameter;
                case 3 %lower('RectangularAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.LargeDiameter;
                case 4 %lower('EllipticalAperture')
                    newAperture.UniqueParameters.DiameterX = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.DiameterY = oldAperture.UniqueParameters.LargeDiameter;
                case 5 %lower('CircularObstruction')
                    newAperture.UniqueParameters.LargeDiameter = oldAperture.UniqueParameters.LargeDiameter;
                    newAperture.UniqueParameters.SmallDiameter = oldAperture.UniqueParameters.SmallDiameter;
                otherwise
            end
        otherwise
            % Do nothing for others. That is just initialize the defualt
    end
    % Keep other common parameters as well
    newAperture.Decenter = oldAperture.Decenter;
    newAperture.Rotation = oldAperture.Rotation;
    newAperture.DrawAbsolute = oldAperture.DrawAbsolute;
    newAperture.AdditionalEdge = oldAperture.AdditionalEdge;
    newAperture.OuterShape = oldAperture.OuterShape;
    
    
    selectedSurface.Aperture = newAperture;
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end


function popSurfaceApertureOuterShape_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedSurface.Aperture.OuterShape = get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function txtSurfaceApertureAdditionalEdge_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    enteredValue = str2num(get(hObject,'String'));
    if isempty((enteredValue))
        enteredValue = 0;
    end
    selectedSurface.Aperture.AdditionalEdge =  enteredValue;
    
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popSurfaceApertureAdditionalEdgeType_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    
    selectedSurface.Aperture.AdditionalEdgeType =  get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

function popSurfaceApertureDrawAbsolute_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    
    if (get(hObject,'value')==1)
        selectedSurface.Aperture.DrawAbsolute = 1;
    else
        selectedSurface.Aperture.DrawAbsolute = 0;
    end
    
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end


function tblSurfaceTiltDecenterParameters_CellSelectionCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblSurfaceTiltDecenterParameters (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    if selectedCol ~= 2
        return;
    end
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'TiltDecenter',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType)&& length(myType)>1
        % type is choice of popmenu
        aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = choice;
        newParamDisp = myType{choice};
        % Update the surface parameter and surface editor
        selectedSurface.(myName) = newParam;
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
            trueFalse = {'0','1'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            
            newParamDisp = newParam;
            
            % Update the surface parameter and surface editor
            selectedSurface.(myName) = newParam;
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)
            
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popSurfaceTiltDecenterOrder_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedSurface.TiltDecenterOrder = get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popSurfaceTiltMode_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedSurface.TiltMode = get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

function tblSurfaceGratingParameters_CellSelectionCallback(~, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    if selectedCol ~= 2
        return;
    end
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Grating',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType)&& length(myType)>1
        % type is choice of popmenu
        aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = choice;
        newParamDisp = myType{choice};
        % Update the surface parameter and surface editor
        selectedSurface.Grating.(myName) = newParam;
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
            trueFalse = {'0','1'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            
            newParamDisp = newParam;
            
            % Update the surface parameter and surface editor
            selectedSurface.Grating.(myName) = newParam;
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)
            
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popGratingType_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    oldGrating = selectedSurface.Grating;
    selectedGratingType = GetSupportedGratingTypes(get(hObject,'value'));
    newGrating = Grating(selectedGratingType);
    newGrating.DiffractionOrder = oldGrating.DiffractionOrder;
    
    % If possible try to map the old aperture values to the new aperture.
    switch (oldGrating.Type)
        case 1 %lower('ConcentricCylinderGrating')
            switch (newGrating.Type)
                case 1 %lower('ConcentricCylinderGrating')
                    newGrating.UniqueParameters.LinesPerMicrometer = oldGrating.UniqueParameters.LinesPerMicrometer;
                    newGrating.UniqueParameters.LinearCoefficient = oldGrating.UniqueParameters.LinearCoefficient;
                case 2 %lower('ParallelPlaneGrating')
                    newGrating.UniqueParameters.LinesPerMicrometer = oldGrating.UniqueParameters.LinesPerMicrometer;
                    newGrating.UniqueParameters.LinearCoefficient = oldGrating.UniqueParameters.LinearCoefficient;
            end
        case 2 %lower('ParallelPlaneGrating')
            switch (newGrating.Type)
                case 1 %lower('ConcentricCylinderGrating')
                    newGrating.UniqueParameters.LinesPerMicrometer = oldGrating.UniqueParameters.LinesPerMicrometer;
                    newGrating.UniqueParameters.LinearCoefficient = oldGrating.UniqueParameters.LinearCoefficient;
                case 2 %lower('ParallelPlaneGrating')
                    newGrating.UniqueParameters.LinesPerMicrometer = oldGrating.UniqueParameters.LinesPerMicrometer;
                    newGrating.UniqueParameters.LinearCoefficient = oldGrating.UniqueParameters.LinearCoefficient;
            end
    end
    % Keep other common parameteres  too
    newGrating.DiffractionOrder = oldGrating.DiffractionOrder;
    
    selectedSurface.Grating = newGrating;
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popGratingDiffractionOrderSign_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    diffOrder = get(aodHandles.popGratingDiffractionOrder,'value')-1;
    diffOrderSignIndex = get(aodHandles.popGratingDiffractionOrderSign,'value');
    if diffOrderSignIndex == 1 % +ve
        selectedSurface.Grating.DiffractionOrder = diffOrder;
    else
        selectedSurface.Grating.DiffractionOrder = -diffOrder;
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popGratingDiffractionOrder_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    diffOrder = get(aodHandles.popGratingDiffractionOrder,'value')-1;
    diffOrderSignIndex = get(aodHandles.popGratingDiffractionOrderSign,'value');
    if diffOrderSignIndex == 1 % +ve
        selectedSurface.Grating.DiffractionOrder = diffOrder;
    else
        selectedSurface.Grating.DiffractionOrder = -diffOrder;
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblSurfaceExtraParameters_CellSelectionCallback(~, eventdata,parentWindow)
end
function popNumberOfExtraParameters_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    extraData = cell2mat(get(aodHandles.tblSurfaceExtraParameters,'Data'));
    nTermsOld = length(extraData);
    nTermsNew = get(hObject,'value')-1;
    if nTermsNew < nTermsOld
        extraDataNew = extraData(1:nTermsNew);
    elseif nTermsNew > nTermsOld
        extraDataNew = [extraData;zeros(nTermsNew-nTermsOld,1)];
    else
        extraDataNew = extraData;
    end
    
    selectedSurface.ExtraData = extraDataNew;
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

function tblSurfaceBasicParameters_CellEditCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblOpticalElementList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    if selectedElementIndex > 1
        previousSurface =  aodHandles.OpticalSystem(currentConfig).SurfaceArray(selectedElementIndex-1);
    else
        previousSurface =  selectedSurface;
    end
    selectedCellIndex = eventdata.Indices;
    if isempty(selectedCellIndex)
        return;
    else
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
        
    end
    if selectedCol == 2 % surface  value edited
        switch selectedRow
            case 1
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Thickness = newParam;
            case 2
                glassName = (eventdata.EditData);
                newParam = Glass(glassName);
                selectedSurface.Glass = newParam;
            case 3
                coatingName = (eventdata.EditData);
                newParam = Coating(coatingName);
                selectedSurface.Coating = newParam;
            case 4
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Radius = newParam;
            case 5
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Conic = newParam;
            otherwise
                [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
                    getSurfaceParameters(selectedSurface,'Basic',selectedRow);
                
                myType = paramTypes{1};
                myName = paramNames{1};
                
                if  (iscell(myType) && length(myType)>1)||(strcmpi('logical',myType))
                    % type is choice of popmenu and so already saved with popup menu
                    % type is choice of popmenu
                    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
                    nChoice = length(myType);
                    choice = menu(myName,myType(1:nChoice));
                    if choice == 0
                        choice = 1;
                    end
                    newParam = choice;
                    newParamDisp = myType{choice};
                    % Update the surface parameter and surface editor
                    if selectedRow <=3
                        selectedSurface.(myName) = newParam;
                    else
                        selectedSurface.UniqueParameters.(myName) = newParam;
                    end
                    
                else
                    if strcmpi('numeric',myType)
                        newParam = str2num(eventdata.EditData);
                        if isempty(newParam)
                            newParam = 0;
                        end
                        % Update the surface parameter and surface editor
                        selectedSurface.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('char',myType)
                        newParam = (eventdata.EditData);
                        % Update the surface parameter and surface editor
                        selectedSurface.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Glass',myType)
                        glassName = (eventdata.EditData);
                        newParam = Glass(glassName);
                        % Update the surface parameter and surface editor
                        selectedSurface.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Coating',myType)
                        coatingName = (eventdata.EditData);
                        newParam = Glass(coatingName);
                        % Update the surface parameter and surface editor
                        selectedSurface.UniqueParameters.(myName) = newParam;
                    else
                        disp(['Error: Unknown parameter type: ',myType]);
                        return;
                    end
                end
                
        end
    else
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    updateOpticalElementEditorPanel( parentWindow,selectedElementIndex );
end
function tblSurfaceApertureParameters_CellEditCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblOpticalElementList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if isempty(selectedCellIndex) || isempty(eventdata.NewData)
        return;
    else
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
        
    end
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Aperture',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    
    if selectedCol == 2 % surface  value edited
        switch selectedRow
            case 1
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Aperture.Decenter(1) = newParam;
            case 2
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Aperture.Decenter(2) = newParam;
            case 3
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Aperture.Rotation= newParam;
            otherwise
                [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
                    getSurfaceParameters(selectedSurface,'Aperture',selectedRow);
                
                myType = paramTypes{1};
                myName = paramNames{1};
                
                if  (iscell(myType) && length(myType)>1)||(strcmpi('logical',myType))
                    % type is choice of popmenu and so already saved with popup menu
                    % type is choice of popmenu
                    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
                    nChoice = length(myType);
                    choice = menu(myName,myType(1:nChoice));
                    if choice == 0
                        choice = 1;
                    end
                    newParam = choice;
                    newParamDisp = myType{choice};
                    % Update the surface parameter and surface editor
                    selectedSurface.Aperture = Aperture(newParam);
                    selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
                    
                else
                    if strcmpi('numeric',myType)
                        newParam = str2num(eventdata.EditData);
                        if isempty(newParam)
                            newParam = 0;
                        end
                        % Update the surface parameter and surface editor
                        selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('char',myType)
                        newParam = (eventdata.EditData);
                        % Update the surface parameter and surface editor
                        selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Glass',myType)
                        glassName = (eventdata.EditData);
                        newParam = Glass(glassName);
                        % Update the surface parameter and surface editor
                        selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Coating',myType)
                        coatingName = (eventdata.EditData);
                        newParam = Glass(coatingName);
                        % Update the surface parameter and surface editor
                        selectedSurface.Aperture.UniqueParameters.(myName) = newParam;
                    else
                        disp(['Error: Unknown parameter type: ',myType]);
                        return;
                    end
                end
        end
    else
        
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblSurfaceTiltDecenterParameters_CellEditCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblSurfaceTiltDecenterParameters (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if isempty(selectedCellIndex) || isempty(eventdata.NewData)
        return;
    else
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
        
    end
    if selectedCol == 2 % surface  value edited
        switch selectedRow
            case 1
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Tilt(1) = newParam;
            case 2
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Tilt(2) = newParam;
            case 3
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Tilt(3) = newParam;
            case 4
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Decenter(1) = newParam;
            case 5
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedSurface.Decenter(2) = newParam;
            case 6
                % already saved by pop up menu
            otherwise
        end
    else
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblSurfaceGratingParameters_CellEditCallback(~, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    if selectedCol ~= 2
        return;
    end
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(selectedSurface,'Grating',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  (iscell(myType) && length(myType)>1)||(strcmpi('logical',myType))
        % type is choice of popmenu and so already saved with popup menu
        % type is choice of popmenu
        aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = choice;
        newParamDisp = myType{choice};
        % Update the surface parameter and surface editor
        selectedSurface.Grating = Aperture(newParam);
        selectedSurface.Grating.UniqueParameters.(myName) = newParam;
        
    else
        if strcmpi('numeric',myType)
            newParam = str2num(eventdata.EditData);
            if isempty(newParam)
                newParam = 0;
            end
            % Update the surface parameter and surface editor
            selectedSurface.Grating.UniqueParameters.(myName) = newParam;
        elseif strcmpi('char',myType)
            newParam = (eventdata.EditData);
            % Update the surface parameter and surface editor
            selectedSurface.Grating.UniqueParameters.(myName) = newParam;
        elseif strcmpi('Glass',myType)
            glassName = (eventdata.EditData);
            newParam = Glass(glassName);
            % Update the surface parameter and surface editor
            selectedSurface.Grating.UniqueParameters.(myName) = newParam;
        elseif strcmpi('Coating',myType)
            coatingName = (eventdata.EditData);
            newParam = Glass(coatingName);
            % Update the surface parameter and surface editor
            selectedSurface.Grating.UniqueParameters.(myName) = newParam;
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblSurfaceExtraParameters_CellEditCallback(~, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedSurface =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    extraDataNew = cell2mat(get(aodHandles.tblSurfaceExtraParameters,'Data'));
    selectedSurface.ExtraData = extraDataNew;
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

% Component window elelements
function tblComponentBasicParameters_CellSelectionCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblComponentList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    selectedElementIndex = parentWindow.ParentHandles.SelectedElementIndex;
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    
    if selectedCol ~= 2
        return;
    end
    
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedComponent,'Basic',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType) && length(myType)>1
        % type is choice of popmenu
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = myType{choice};
        newParamDisp = newParam;
        % Update the component parameter and component editor
        if selectedRow <=1
            selectedComponent.(myName) = newParam;
        else
            selectedComponent.UniqueParameters.(myName) = newParam;
        end
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            trueFalse = {'1','0'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            newParamDisp = newParam;
            
            % Update the component parameter and component editor
            if selectedRow <=1
                selectedComponent.(myName) = newParam;
            else
                selectedComponent.UniqueParameters.(myName) = newParam;
            end
        elseif strcmpi('SQS',myType)
            initialSurfaceArray = getComponentSurfaceArray(selectedComponent);%.UniqueParameters.(myName);
            isSurfaceArrayComponent = 0;
            glassCatalogueListFullNames = aodHandles.OpticalSystem.GlassCataloguesList;
            coatingCatalogueListFullNames = aodHandles.OpticalSystem.CoatingCataloguesList;
            fontName = aodHandles.FontName;
            fontSize = aodHandles.FontSize;
            surfaceArrayEnteryFig = surfaceArrayInputDialog(initialSurfaceArray,...
                isSurfaceArrayComponent,glassCatalogueListFullNames,coatingCatalogueListFullNames,...
                fontName,fontSize );
            set(surfaceArrayEnteryFig,'WindowStyle','Modal');
            uiwait(surfaceArrayEnteryFig);
            surfaceArray = getappdata(0,'SurfaceArray');
            selectedComponent.UniqueParameters.(myName)  = surfaceArray;
            newStopSurf = find([surfaceArray.StopSurfaceIndex]);
            if newStopSurf
                [prevStopElem,stopSurfaceIndex,specified] = getStopElementIndex(aodHandles.OpticalSystem(currentConfig).OpticalElementArray);
                selectedComponent.StopSurfaceIndex = newStopSurf;
                aodHandles.OpticalSystem.OpticalElementArray{prevStopElem}.StopSurfaceIndex = 0;
            end
            
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)||...
                strcmpi('Glass',myType) || strcmpi('Coating',myType)
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
end
function tblComponentTiltDecenterParameters_CellSelectionCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblComponentTiltDecenterParameters (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    
    selectedElementIndex = parentWindow.ParentHandles.SelectedElementIndex;
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    if selectedCol ~= 2
        return;
    end
    [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getComponentParameters(selectedComponent,'TiltDecenter',selectedRow);
    
    myType = paramTypes{1};
    myName = paramNames{1};
    if  iscell(myType)&& length(myType)>1
        % type is choice of popmenu
        nChoice = length(myType);
        choice = menu(myName,myType(1:nChoice));
        if choice == 0
            choice = 1;
        end
        newParam = myType{choice};
        newParamDisp = newParam;
        % Update the component parameter and component editor
        selectedComponent.(myName) = newParam;
    else
        if strcmpi('logical',myType)
            % type is choice of popmenu true or false
            trueFalse = {'0','1'};
            choice = menu(myName,'False','True');
            if choice == 0
                choice = 1;
            end
            newParam = trueFalse{choice};
            
            newParamDisp = newParam;
            
            % Update the component parameter and component editor
            selectedComponent.(myName) = newParam;
        elseif strcmpi('numeric',myType) || strcmpi('char',myType)
            
        else
            disp(['Error: Unknown parameter type: ',myType]);
            return;
        end
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function tblComponentBasicParameters_CellEditCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblComponentList (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    %aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    %     selectedComponent =  aodHandles.OpticalSystem.ComponentArray(selectedElementIndex);
    if selectedElementIndex > 1
        previousComponent =  aodHandles.OpticalSystem.OpticalElementArray{selectedElementIndex-1};
    else
        previousComponent =  selectedComponent;
    end
    selectedCellIndex = eventdata.Indices;
    if isempty(selectedCellIndex)
        return;
    else
        editedRow = selectedCellIndex(1,1);
        editedCol = selectedCellIndex(1,2);
        
    end
    if editedCol == 2 % component  value edited
        switch editedRow
            case 1
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.LastThickness = newParam;
            otherwise
                [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
                    getComponentParameters(selectedComponent,'Basic',editedRow);
                
                myType = paramTypes{1};
                myName = paramNames{1};
                
                if  (iscell(myType) && length(myType)>1)||(strcmpi('logical',myType))
                    % type is choice of popmenu and so already saved with popup menu
                else
                    if strcmpi('numeric',myType)
                        newParam = str2num(eventdata.EditData);
                        if isempty(newParam)
                            newParam = 0;
                        end
                        % Update the component parameter and component editor
                        selectedComponent.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('char',myType)
                        newParam = (eventdata.EditData);
                        % Update the component parameter and component editor
                        selectedComponent.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Glass',myType)
                        glassName = (eventdata.EditData);
                        newParam = Glass(glassName);
                        % Update the component parameter and component editor
                        selectedComponent.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('Coating',myType)
                        coatingName = (eventdata.EditData);
                        newParam = Glass(coatingName);
                        % Update the component parameter and component editor
                        selectedComponent.UniqueParameters.(myName) = newParam;
                    elseif strcmpi('SQS',myType)
                        % SQS already saved using surfacearray input dialog
                    else
                        disp(['Error: Unknown parameter type: ',myType]);
                        return;
                    end
                end
                
        end
    else
    end
    
    %     aodHandles.OpticalSystem.ComponentArray(selectedElementIndex) = selectedComponent;
    %selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
    updateOpticalElementEditorPanel( parentWindow,selectedElementIndex );
end
function tblComponentTiltDecenterParameters_CellEditCallback(~, eventdata,parentWindow)
    % hObject    handle to aodHandles.tblComponentTiltDecenterParameters (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % parentWindow: object with structure with aodHandles and user data (see GUIDATA)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedCellIndex = eventdata.Indices;
    if isempty(selectedCellIndex) || isempty(eventdata.NewData)
        return;
    else
        editedRow = selectedCellIndex(1,1);
        editedCol = selectedCellIndex(1,2);
        
    end
    if editedCol == 2 % component  value edited
        switch editedRow
            case 1
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.FirstTilt(1) = newParam;
            case 2
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.FirstTilt(2) = newParam;
            case 3
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.FirstTilt(3) = newParam;
            case 4
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.FirstDecenter(1) = newParam;
            case 5
                newParam = str2num(eventdata.EditData);
                if isempty(newParam)
                    newParam = 0;
                end
                selectedComponent.FirstDecenter(2) = newParam;
            otherwise
        end
    else
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex);
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

function popComponentTiltDecenterOrder_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedComponent.FirstTiltDecenterOrder = get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedSurface;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end
function popComponentTiltMode_Callback(hObject, eventdata,parentWindow)
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    selectedElementIndex = aodHandles.SelectedElementIndex;
    selectedComponent =  aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex};
    selectedComponent.ComponentTiltMode = get(hObject,'value');
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{selectedElementIndex} = selectedComponent;
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow , selectedElementIndex)
    updateQuickLayoutPanel(parentWindow,selectedElementIndex);
end

function InsertNewElement(parentWindow,surfaceTypeDisp,surfaceType,insertPosition)
    %update surface list table
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    nElement = length(aodHandles.OpticalSystem(currentConfig).OpticalElementArray);
    % Update the surface array
    for kk = nElement:-1:insertPosition
        aodHandles.OpticalSystem(currentConfig).OpticalElementArray{kk+1} = aodHandles.OpticalSystem(currentConfig).OpticalElementArray{kk};
    end
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray{insertPosition} =  Surface(surfaceType);
    
    set(aodHandles.popStopElementIndex,'String',[num2cell(1:nElement+1)],...
        'Value',getStopElementIndex(aodHandles.OpticalSystem(currentConfig).OpticalElementArray));
    % If possible add here a code to select the first cell of newly added row
    % automatically
    
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow,insertPosition );
    updateQuickLayoutPanel(parentWindow,insertPosition);
end
function RemoveElement(parentWindow,removePosition)
    % check if it is stop surface
    if getStopElementIndex(parentWindow.ParentHandles.OpticalSystem.OpticalElementArray) == removePosition
        stopSurfaceRemoved = 1;
    else
        stopSurfaceRemoved = 0;
    end
    aodHandles = parentWindow.ParentHandles;
    currentConfig = aodHandles.CurrentConfiguration;
    aodHandles.OpticalSystem(currentConfig).IsUpdatedSurfaceArray = 0;
    % Update the surface array
    aodHandles.OpticalSystem(currentConfig).OpticalElementArray = aodHandles.OpticalSystem(currentConfig).OpticalElementArray([1:removePosition-1,removePosition+1:end]);
    if stopSurfaceRemoved
        if removePosition == length(aodHandles.OpticalSystem(currentConfig).OpticalElementArray)% IsImage
            aodHandles.OpticalSystem(currentConfig).OpticalElementArray{removePosition-1}.StopSurfaceIndex = 1;
        else
            aodHandles.OpticalSystem(currentConfig).OpticalElementArray{removePosition}.StopSurfaceIndex = 1;
        end
    end
    % The next selected row will be the one in the removed position, so if
    % it is image plane then dont let further removal
    nextElement = aodHandles.OpticalSystem(currentConfig).OpticalElementArray{removePosition};
    if isSurface(nextElement) && nextElement.IsImage
        canRemoveElement = 0;
        aodHandles.CanRemoveElement = canRemoveElement;
    end
    
    [ aodHandles.OpticalSystem(currentConfig) ] = updateOpticalSystem( aodHandles.OpticalSystem(currentConfig),1 );
    parentWindow.ParentHandles = aodHandles;
    updateOpticalElementEditorPanel( parentWindow,removePosition );
    updateQuickLayoutPanel(parentWindow,removePosition);
end


