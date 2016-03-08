function mainFigHandle = glassDataInputDialog(glassCatalogueListFullNames,fontName,fontSize)
    %GLASSDATAINPUTDIALOG Defines a dilog box which is used to input glass
    % data based on its type. Saves the glass selected as appdata to root.
    % Example usage:
    %   First call the dialog with : glassDataInputDialog
    %   After selecting a given glass close the dialog by clicking OK
    %   button. Then in the matlab editor or any other functions you can
    %   just get the selected glass by, selectedGlass = getappdata(0,'Glass')
    % Inputs:
    %   ( glassCatalogueListFullNames,fontName,fontSize )
    % Outputs:
    %   [ ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    
    % Default Input
    if nargin < 1
        % Get all catalogues from current folder
        glassCatalogueListFullNames = getAllObjectCatalogues('glass');
    end
    if nargin < 2
        fontSize = 9.5;
    end
    if nargin < 3
        fontName = 'FixedWidth';
    end
    
    if isempty(glassCatalogueListFullNames)
        figureHandle = NaN;
        disp('Error: No glass catalogue is found in the current folder.');
        return;
    else
        [~,catalogueListFileNames,~] = cellfun(@(x) fileparts(x),...
            glassCatalogueListFullNames,'UniformOutput',false);
        % extract the first catalogue and first glass from the catalogue
        firstCatalogueGlassArray = extractObjectFromObjectCatalogue...
            ('glass','all',glassCatalogueListFullNames{1});
        firstCatalogueGlassgNames =  {firstCatalogueGlassArray.Name};
    end
    
    
    % Creation of all uicontrols
    % --- FIGURE -------------------------------------
    figureHandle = ObjectHandle(struct());
    figureHandle.Object.MainFigureHandle = figure( ...
        'Tag', 'FigureHandle', ...
        'Units','Normalized',...
        'Position', [0.3,0.3,0.45,0.5], ...
        'Name', 'Glass Data Entry', ... %'WindowStyle','Modal',...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'WindowStyle','Modal',...
        'Color', get(0,'DefaultUicontrolBackgroundColor'),...
        'CloseRequestFcn',{@figureCloseRequestFunction,figureHandle});
    mainFigHandle = figureHandle.Object.MainFigureHandle;
    % --- PANELS  AND TABS -------------------------------------
    
    figureHandle.Object.glassParametersTabGroup = uitabgroup(...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Units', 'Normalized', ...
        'Position', [0.48,0.10,0.52,0.9]);
    
    figureHandle.Object.UniqueParametersTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Glass Parameters');
    figureHandle.Object.InternalTransmittanceTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Internal Transmittance');
    figureHandle.Object.ThermalDataTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Thermal Data');
    figureHandle.Object.WavelengthRangeTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Wavelength Range');
    figureHandle.Object.ResistanceDataTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Resistance Data');
    figureHandle.Object.OtherDataTab = ...
        uitab(figureHandle.Object.glassParametersTabGroup, 'title','Other Data');
    
    
    
    figureHandle.Object.panelGlassListing = uipanel( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'panelGlassListing', ...
        'Units','Normalized',...
        'Position', [0.02,0.1,0.45,0.90], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','On');
    
    % -----------------------------------------------------------------
    figureHandle.Object.lblGlassCatalogueName = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'lblGlassCatalogueName', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.02,0.9,0.48,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Catalogue Name');
    
    figureHandle.Object.popGlassCatalogueName = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'popGlassCatalogueName', ...
        'Style', 'popupmenu', ...
        'FontSize',fontSize,'FontName',fontName,...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.50,0.9,0.48,0.055], ...
        'BackgroundColor', [1 1 1],...
        'String',catalogueListFileNames,...
        'Callback',{@popGlassCatalogueName_Callback,figureHandle});
    
    %-----------------------------------------------------------------
    
    figureHandle.Object.lblGlassName = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'lblGlassName', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.02,0.83,0.48,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Glass Name');
    
    
    figureHandle.Object.txtGlassName = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'txtGlassName', ...
        'Style', 'edit', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.50,0.83,0.48,0.05], ...
        'BackgroundColor', [1 1 1], ...
        'String', '', ...
        'FontSize',fontSize,'FontName',fontName,...
        'Callback',{@txtGlassName_Callback,figureHandle});
    % -----------------------------------------------------------------
    figureHandle.Object.lblGlassType = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'lblGlassType', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.02,0.75,0.48,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Glass Type');
    
    supportedGlassTypes = GetSupportedGlassTypes();
    
    figureHandle.Object.popGlassType = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'popGlassType', ...
        'Style', 'popupmenu', ...
        'FontSize',fontSize,'FontName',fontName,...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.50,0.75,0.48,0.055], ...
        'BackgroundColor', [1 1 1],...
        'String',supportedGlassTypes,...
        'Callback',{@popGlassType_Callback,figureHandle});
    % -----------------------------------------------------------------
    figureHandle.Object.lblGlassComment = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'lblGlassComment', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.02,0.68,0.48,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Glass Comment');
    
    figureHandle.Object.txtGlassComment = uicontrol( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'txtGlassComment', ...
        'Style', 'edit', ...
        'FontSize',fontSize,'FontName',fontName,...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.50,0.69,0.48,0.05], ...
        'BackgroundColor', [1 1 1],...
        'String','',...
        'Callback',{@txtGlassComment_Callback,figureHandle});
    %-----------------------------------------------------------------
    
    figureHandle.Object.tblGlassList = uitable( ...
        'Parent', figureHandle.Object.panelGlassListing, ...
        'Tag', 'tblGlassList', ...
        'Units','Normalized',...
        'Position', [0.02,0.02,0.96,0.65], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [false], ...
        'ColumnFormat', {'char'}, ...
        'ColumnName', {'Glass Names'}, ...
        'ColumnWidth', {220}, ...
        'RowName', 'numbered',...
        'Data',firstCatalogueGlassgNames',...
        'CellSelectionCallback',{@tblGlassList_CellSelectionCallback,figureHandle});
    
    
    %-------------------------------------------------------------------
    
    figureHandle.Object.tblInternalTransmittance = uitable( ...
        'Parent',figureHandle.Object.InternalTransmittanceTab,...
        'Tag', 'tblCoefficientData', ...
        'UserData', zeros(1,0), ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,0.9], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [true,true,true], ...
        'ColumnFormat', {'numeric','numeric','numeric'}, ...
        'ColumnName', {'Lambda','Transmission','Thickness'}, ...
        'ColumnWidth', {100,100,100}, ...
        'RowName', 'numbered',...
        'CellEditCallback',{@tblInternalTransmittance_CellEditCallback,figureHandle});
    %-----------------------------------------------------------------
    figureHandle.Object.cmdClearITAll = uicontrol( ...
        'Parent', figureHandle.Object.InternalTransmittanceTab, ...
        'Tag', 'cmdClearAll', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.02,0.92,0.3,0.05], ...
        'fontSize',fontSize,...
        'FontName',fontName,...
        'String', 'Clear All', ...
        'Callback', {@cmdClearITAll_Callback,figureHandle});
    figureHandle.Object.cmdAddITRow = uicontrol( ...
        'Parent', figureHandle.Object.InternalTransmittanceTab, ...
        'Tag', 'cmdAddRow', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.35,0.92,0.3,0.05], ...
        'fontSize',fontSize,...
        'FontName',fontName,...
        'String', 'Add (+)', ...
        'Callback', {@cmdAddITRow_Callback,figureHandle});
    figureHandle.Object.cmdRemoveITRow = uicontrol( ...
        'Parent', figureHandle.Object.InternalTransmittanceTab, ...
        'Tag', 'cmdRemoveRow', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.67,0.92,0.3,0.05], ...
        'fontSize',fontSize,...
        'FontName',fontName,...
        'String', 'Remove (-)', ...
        'Callback', {@cmdRemoveITRow_Callback,figureHandle});
    
    %% ---------------------------------------------------------------------------
    function cmdClearITAll_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        newTable1 = {[0],[0],[0]};
        set(figureHandle.Object.tblInternalTransmittance, 'Data', newTable1);
        
        figureHandle.Object.InternalTransmittance = [0,0,0];
    end
    %% ---------------------------------------------------------------------------
    function cmdAddITRow_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        tblData1 = (get(figureHandle.Object.tblInternalTransmittance,'data'));
        newRow1 =   {[0],[0],[0]};
        newTable1 = [tblData1; newRow1];
        set(figureHandle.Object.tblInternalTransmittance, 'Data', newTable1);
        
        nITData = size(newTable1,1);
        figureHandle.Object.InternalTransmittance(nITData,:) = [0,0,0];
    end
    %% ---------------------------------------------------------------------------
    function cmdRemoveITRow_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        tblData1 = (get(figureHandle.Object.tblInternalTransmittance,'data'));
        newTable1 = tblData1(1:end-1,:);
        set(figureHandle.Object.tblInternalTransmittance, 'Data', newTable1);
        
        figureHandle.Object.InternalTransmittance(end,:) = [];
    end
    
    initalThermalData = {'D0',[0];
        'D1',[0];
        'D2',[0];
        'E0',[0];
        'E1',[0];
        'Ltk',[0];
        'Temp',[0];
        'TCE70',[0];
        'TCE300',[0];
        'Ignore_Thermal_Exp',[0]};
    figureHandle.Object.tblThermalData = uitable( ...
        'Parent',figureHandle.Object.ThermalDataTab,...
        'Tag', 'tblThermalData', ...
        'UserData', zeros(1,0), ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,1.0], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [false,true], ...
        'ColumnFormat', {'char','numeric'}, ...
        'ColumnName', {'Thermal Data','Value'}, ...
        'ColumnWidth', {100,100},...
        'Data',initalThermalData,...
        'CellEditCallback',{@tblThermalData_CellEditCallback,figureHandle});
    
    
    initalWavelengthRange = {'Minimum',[0];
        'Maximum',[0]};
    figureHandle.Object.tblWavelengthRange = uitable( ...
        'Parent',figureHandle.Object.WavelengthRangeTab,...
        'Tag', 'tblWavelengthRange', ...
        'UserData', zeros(1,0), ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,1.0], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [false,true], ...
        'ColumnFormat', {'char','numeric'}, ...
        'ColumnName', {'Wavelength','Value'}, ...
        'ColumnWidth', {100,100},...
        'Data',initalWavelengthRange,...
        'CellEditCallback',{@tblWavelengthRange_CellEditCallback,figureHandle});
    
    
    initalResistanceData = {'Climate Resistance',[0];
        'Stain Resistance',[0];
        'Acid Resistance',[0];
        'Alkali Resistance',[0];
        'Phosphate Resistance',[0]};
    figureHandle.Object.tblResistanceData = uitable( ...
        'Parent',figureHandle.Object.ResistanceDataTab,...
        'Tag', 'tblResistanceData', ...
        'UserData', zeros(1,0), ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,1.0], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [false,true], ...
        'ColumnFormat', {'char','numeric'}, ...
        'ColumnName', {'Resistance','Value'}, ...
        'ColumnWidth', {100,100},...
        'Data',initalResistanceData,...
        'CellEditCallback',{@tblResistanceData_CellEditCallback,figureHandle});
    
    initalOtherData = {'RelativeCost',[0];
        'Density',[0];
        'MeltingFrequency',[0];
        'Status',[0];
        'ExcludeFromSubstitution',[0];
        'MIL_Number',[0];
        'Nd',[0];
        'Vd',[0];
        'dPgF',[0]};
    figureHandle.Object.tblOtherData = uitable( ...
        'Parent',figureHandle.Object.OtherDataTab,...
        'Tag', 'tblCoefficientData', ...
        'UserData', zeros(1,0), ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,1.0], ...
        'FontSize',fontSize,'FontName',fontName,... ...
        'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
        'ColumnEditable', [false,true], ...
        'ColumnFormat', {'char','numeric'}, ...
        'ColumnName', {'Other Data','Value'}, ...
        'ColumnWidth', {100,100},...
        'Data',initalOtherData,...
        'CellEditCallback',{@tblOtherData_CellEditCallback,figureHandle});
    
    %-----------------------------------------------------------------
    
    figureHandle.Object.cmdDeleteGlass = uicontrol( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'cmdDeleteGlass', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.45,0.02,0.1,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Delete', ...
        'Callback', {@cmdDeleteGlass_Callback,figureHandle});
    
    figureHandle.Object.cmdNewGlass = uicontrol( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'cmdNewGlass', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.56,0.02,0.10,0.05], ...
        'fontSize',fontSize,...
        'FontName',fontName,...
        'String', 'New', ...
        'Callback', {@cmdNewGlass_Callback,figureHandle});
    
    
    figureHandle.Object.cmdEditSaveGlass = uicontrol( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'cmdEditSaveGlass', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.67,0.02,0.10,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Edit', ...
        'Callback', {@cmdEditSaveGlass_Callback,figureHandle});
    figureHandle.Object.cmdOk = uicontrol( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'cmdOk', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.78,0.02,0.10,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Ok', ...
        'Callback', {@cmdOk_Callback,figureHandle});
    figureHandle.Object.cmdCancel = uicontrol( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'cmdCancel', ...
        'Style', 'pushbutton', ...
        'Units','Normalized',...
        'Position', [0.89,0.02,0.10,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Cancel', ...
        'Callback', {@cmdCancel_Callback,figureHandle});
    
    % Display the first glass data
    refreshGlassDataInputDialog(figureHandle,1);
    
    %% ---------------------------------------------------------------------------
    function popGlassCatalogueName_Callback(~,~,figureHandle )
        refreshGlassDataInputDialog(figureHandle,1);
    end
    
    function txtGlassName_Callback(~,~,figureHandle )
        selectedGlassName =  get(figureHandle.Object.txtGlassName,'String');
        figureHandle.Object.GlassName = selectedGlassName;
    end
    
    function refreshGlassDataInputDialog(figureHandle,selectedGlassIndex)
        selectedCatalogueFullName = glassCatalogueListFullNames{get(figureHandle.Object.popGlassCatalogueName,'Value')};
        % extract the selected catalogue and Glass from the catalogue
        selectedCatalogueGlassArray = extractObjectFromObjectCatalogue...
            ('Glass','all',selectedCatalogueFullName);
        if ~isempty(selectedCatalogueGlassArray)
            selectedCatalogueGlassNames =  {selectedCatalogueGlassArray.Name};
            set(figureHandle.Object.tblGlassList,'Data',selectedCatalogueGlassNames');
            
            selectedGlassObject = selectedCatalogueGlassArray(selectedGlassIndex(1));
            
            type = selectedGlassObject.Type;
            name = selectedGlassObject.Name;
            comment = selectedGlassObject.Comment; %
            parameters = selectedGlassObject.UniqueParameters;
            internalTransmittance = selectedGlassObject.InternalTransmittance;
            thermalData = selectedGlassObject.ThermalData;
            wavelengthRange = selectedGlassObject.WavelengthRange;
            resistanceData = selectedGlassObject.ResistanceData;
            otherData = selectedGlassObject.OtherData;
            
            figureHandle.Object.GlassCatalogueFullName = selectedCatalogueFullName;
            figureHandle.Object.GlassType = type;
            figureHandle.Object.GlassName = name;
            figureHandle.Object.GlassComment = comment; %
            figureHandle.Object.UniqueParameters = parameters; %
            figureHandle.Object.GlassInternalTransmittance  = internalTransmittance;
            figureHandle.Object.GlassThermalData = thermalData;
            figureHandle.Object.GlassWavelengthRange  = wavelengthRange;
            figureHandle.Object.GlassResistanceData  = resistanceData;
            figureHandle.Object.GlassOtherData = otherData;
            
            displayCurrentParameters(figureHandle);
        else
            figureHandle.Object.GlassCatalogueFullName = selectedCatalogueFullName;
            
            set(figureHandle.Object.txtGlassName,'String','NoName');
            set(figureHandle.Object.popGlassType,'Value',1);
            set(figureHandle.Object.tblGlassList,'Data',[]);
            % Clear the childrens of ParametersTab
            delete(get(figureHandle.Object.UniqueParametersTab,'Child'));
            makeUneditable(figureHandle);
            disp('Error: The selected glass catalogue is empty.');
            return;
        end
    end
    
    function tblGlassList_CellSelectionCallback(hObject,eventdata,figureHandle)
        
        selCell = eventdata.Indices;
        if ~isempty(selCell)
            selRow = selCell(1,1);
            selCol = selCell(1,2);
            selectedGlassIndex = selRow;
            selectedCatalogueFullName = glassCatalogueListFullNames...
                {get(figureHandle.Object.popGlassCatalogueName,'Value')};
            
            % extract the selected Glass from the catalogue
            catalogueGlassArray = extractObjectFromObjectCatalogue...
                ('glass','all',selectedCatalogueFullName);
            if isempty(catalogueGlassArray)
                catalogueGlassArray = Glass;
                selectedGlassObject = catalogueGlassArray;
            else
                selectedGlassObject = catalogueGlassArray(selectedGlassIndex);
            end
            
            type = selectedGlassObject.Type;
            name = selectedGlassObject.Name;
            comment = selectedGlassObject.Comment; %
            parameters = selectedGlassObject.UniqueParameters;
            internalTransmittance = selectedGlassObject.InternalTransmittance;
            thermalData = selectedGlassObject.ThermalData;
            wavelengthRange = selectedGlassObject.WavelengthRange;
            resistanceData = selectedGlassObject.ResistanceData;
            otherData = selectedGlassObject.OtherData;
            
            figureHandle.Object.GlassCatalogueFullName = selectedCatalogueFullName;
            figureHandle.Object.GlassType = type;
            figureHandle.Object.GlassName = name;
            figureHandle.Object.GlassComment = comment; %
            figureHandle.Object.UniqueParameters = parameters; %
            figureHandle.Object.GlassInternalTransmittance  = internalTransmittance;
            figureHandle.Object.GlassThermalData = thermalData;
            figureHandle.Object.GlassWavelengthRange  = wavelengthRange;
            figureHandle.Object.GlassResistanceData  = resistanceData;
            figureHandle.Object.GlassOtherData = otherData;
            figureHandle.Object.SelectedGlassIndex = selectedGlassIndex;
            
            displayCurrentParameters(figureHandle);
        end
    end
    
    function displayCurrentParameters(figureHandle)
        
        if nargin == 0
            disp('Error: The function displayCurrentParameters requires figureHandle.');
            return;
        end
        
        glassType = figureHandle.Object.GlassType;
        glassName = figureHandle.Object.GlassName;
        comment = figureHandle.Object.GlassComment; %
        
        glassTypeList = get(figureHandle.Object.popGlassType,'String');
        selectedGlassTypeIndex = find(strcmpi(glassType,glassTypeList));
        
        parameters = figureHandle.Object.UniqueParameters; %
        internalTransmittance = figureHandle.Object.GlassInternalTransmittance;
        thermalData = figureHandle.Object.GlassThermalData;
        wavelengthRange = figureHandle.Object.GlassWavelengthRange;
        resistanceData = figureHandle.Object.GlassResistanceData;
        otherData = figureHandle.Object.GlassOtherData;
        
        
        set(figureHandle.Object.popGlassType,'Value',selectedGlassTypeIndex);
        set(figureHandle.Object.txtGlassName,'String',glassName);
        set(figureHandle.Object.txtGlassComment,'String',comment);
        
        tblData1 = get(figureHandle.Object.tblInternalTransmittance,'data');
        tblData1 = num2cell(internalTransmittance);
        set(figureHandle.Object.tblInternalTransmittance, 'Data', tblData1);
        
        tblData2 = get(figureHandle.Object.tblThermalData,'data');
        tblData2(1:length(thermalData),2) = num2cell(thermalData);
        set(figureHandle.Object.tblThermalData, 'Data', tblData2);
        
        tblData3 = get(figureHandle.Object.tblWavelengthRange,'data');
        tblData3(1:length(wavelengthRange),2) = num2cell(wavelengthRange);
        set(figureHandle.Object.tblWavelengthRange, 'Data', tblData3);
        
        tblData4 = get(figureHandle.Object.tblResistanceData,'data');
        tblData4(1:length(resistanceData),2) = num2cell(resistanceData);
        set(figureHandle.Object.tblResistanceData, 'Data', tblData4);
        
        tblData5 = get(figureHandle.Object.tblOtherData,'data');
        tblData5(1:length(otherData),2) = num2cell(otherData);
        set(figureHandle.Object.tblOtherData, 'Data', tblData5);
        
        % For the glass parameters tab, connect to glass defintion file
        [glassParameterFieldNames,glassParameterFieldFormats,...
            defaultGlassParameterStruct,glassParameterFieldDisplayNames] = ...
            getGlassUniqueParameters( glassType);
        
        fontSize = 11;
        fontName = 'FixedWidth';
        
        nPar = length(glassParameterFieldNames);
        
        % Clear the ParametersTab
        delete(get(figureHandle.Object.UniqueParametersTab,'Child'));
        glassParameters = figureHandle.Object.UniqueParameters;
        
        % Handle the zemaxFormula glass types in special case
        if strcmpi(glassType,'ZemaxFormula')
            formulaType = glassParameters.FormulaType;
            coefficientData = glassParameters.CoefficientData;
            
            zemaxFormulaList = {'Schott','Sellmeier1','Sellmeier2',...
                'Sellmeier3','Sellmeier4','Sellmeier5','Herzberger',...
                'Conrady','HandbookOfOptics1','HandbookOfOptics2',...
                'Extended', 'Extended2', 'Extended3'};
            
            coefficientRowName = {
                {'A0','A1','A2','A3','A4','A5','X','X','X','X'},...    % ('Schott')
                {'K1','L1','K2','L2','K3','L3','X','X','X','X'},...    % ('Sellmeier1')
                {'A','B1','L1','B2','L2','X','X','X','X','X'},...      % ('Sellmeier2')
                {'K1','L1','K2','L2','K3','L3','K4','L4','X','X'},...  % ('Sellmeier3')
                {'A','B','C','D','E','X','X','X','X','X'},...          % ('Sellmeier4')
                {'K1','L1','K2','L2','K3','L3','K4','L4','K5','L5'},...% ('Sellmeier5')
                {'A','B','C','D','E','F','X','X','X','X'},...          % ('Herzberger')
                {'n0','A','B','X','X','X','X','X','X','X'},...         %('Conrady')
                {'A','B','C','D','X','X','X','X','X','X'},...          %('HandbookOfOptics1')
                {'A','B','C','D','X','X','X','X','X','X'}, ...         % ('HandbookOfOptics2')
                {'A0','A1','A2','A3','A4','A5','A6','A7','X','X'},...  % ('Extended')
                {'A0','A1','A2','A3','A4','A5','A6','A7','X','X'}, ... % ('Extended2')
                {'A0','A1','A2','A3','A4','A5','A6','A7','A8','X'}};   % ('Extended3')
            
            % -----------------------------------------------------------------
            figureHandle.Object.lblFormulaType = uicontrol( ...
                'Parent', figureHandle.Object.UniqueParametersTab, ...
                'Tag', 'lblZemaxFormulaType', ...
                'Style', 'text', ...
                'HorizontalAlignment','left',...
                'Units','Normalized',...
                'Position', [0.02,0.9,0.48,0.05], ...
                'fontSize',fontSize,...
                'FontName',fontName,...
                'String', 'Formula Type');
            
            formulaTypeIndex = formulaType;
            
            figureHandle.Object.popDispersionFormulaType = uicontrol( ...
                'Parent', figureHandle.Object.UniqueParametersTab, ...
                'Tag', 'popDispersionFormulaType', ...
                'Style', 'popupmenu', ...
                'fontSize',fontSize,...
                'FontName',fontName,...
                'HorizontalAlignment','left',...
                'Units','Normalized',...
                'Position', [0.50,0.9,0.48,0.055], ...
                'BackgroundColor', [1 1 1],...
                'String',zemaxFormulaList,...
                'Value',formulaTypeIndex,...
                'Callback',{@popDispersionFormulaType_Callback,figureHandle});
            
            % -----------------------------------------------------------------
            
            coeffName = coefficientRowName{formulaTypeIndex};
            currentCoefficientData(1:10,1)  = coeffName';
            coeffData = coefficientData;
            currentCoefficientData(1:10,2) = num2cell(coeffData);
            
            figureHandle.Object.tblCoefficientData = uitable( ...
                'Parent',figureHandle.Object.UniqueParametersTab,...
                'Tag', 'tblCoefficientData', ...
                'Units','Normalized',...
                'Position', [0.0,0.0,1.0,0.85], ...
                'FontSize',fontSize,'FontName',fontName,... ...
                'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
                'ColumnEditable', [false,true], ...
                'ColumnFormat', {'char','numeric'}, ...
                'ColumnName', {'Coefficient',' Value (coeff in sq. um)'}, ...
                'ColumnWidth', {100,150},...
                'Data',currentCoefficientData,...
                'CellEditCallback',{@tblCoefficientData_CellEditCallback,figureHandle});
            
        else
            %% New code
            figureHandle.Object.tblGlassPatrameters = uitable( ...
                'Parent', figureHandle.Object.UniqueParametersTab, ...
                'Tag', 'tblGlassPatrameters', ...
                'UserData', zeros(1,0), ...
                'Units','Normalized',...
                'Position', [0.0,0.0,1.0,1.0], ...
                'fontSize',fontSize,'FontName',fontName,...
                'BackgroundColor', [1 1 1;0.961 0.961 0.961], ...
                'ColumnEditable', [false,true], ...
                'ColumnFormat', {'char','char'}, ...
                'ColumnName', {'Parameter Name','Parameter Value'}, ...
                'ColumnWidth', {300,100}, ...
                'RowName', 'numbered');
            set(figureHandle.Object.tblGlassPatrameters,...
                'CellEditCallback',{@tblGlassPatrameters_CellEditCallback,figureHandle},...
                'CellSelectionCallback',{@tblGlassPatrameters_CellSelectionCallback,figureHandle});
            
            
            tempTableData = cell(nPar,2);
            for pp = 1:nPar
                % Display the parameter value text boxes or popup menu
                parFormat = glassParameterFieldFormats{pp};
                parName = glassParameterFieldNames{pp};
                parDisplayName = glassParameterFieldDisplayNames{pp};
                parValue = glassParameters.(parName);
                
                if iscell(parFormat)
                    % Multiple choice values
                    parValueDisplay = parFormat{parValue};
                else
                    if strcmpi(parFormat,'logical')
                        if parValue
                            parValueDisplay = 'True';
                        else
                            parValueDisplay = 'False';
                        end
                    elseif strcmpi(parFormat,'numeric')
                        parValueDisplay = num2str(parValue);
                    elseif strcmpi(parFormat,'char')
                        parValueDisplay = (parValue);
                    elseif strcmpi(parFormat,'Glass')
                        parValueDisplay = (parValue);
                    else
                        
                    end
                end
                tempTableData{pp,1} = parDisplayName;
                tempTableData{pp,2} = parValueDisplay;
            end
            set(figureHandle.Object.tblGlassPatrameters,'Data',tempTableData);
        end
        makeUneditable(figureHandle);
    end
    
    
    function tblGlassPatrameters_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to aodHandles.tblStandardData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        glassType = figureHandle.Object.GlassType;
        [glassParameterFields,glassParameterFormats,~] = getGlassUniqueParameters( glassType);
        paramName = glassParameterFields{editedRow};
        paramFormat = glassParameterFormats{editedRow};
        editedParamValue = eventdata.NewData;
        if iscell(paramFormat)
            % Multiple choice values
            [IsFoundVector,locationIndex] = ismember(editedParamValue,parFormat);
            if locationIndex
                editedParamValue = locationIndex;
            else
                
            end
        else
            if strcmpi(paramFormat,'logical')
                if strcmpi(editedParamValue,'True') || strcmpi(editedParamValue,'1')
                    editedParamValue = 1;
                elseif strcmpi(editedParamValue,'False')|| strcmpi(editedParamValue,'0')
                    editedParamValue = 0;
                else
                    
                end
            elseif strcmpi(paramFormat,'numeric')
                editedParamValue = str2double(editedParamValue);
                if isempty(editedParamValue)
                    disp('Error: Only numeric values are allowed for the field.');
                    return;
                end
            elseif strcmpi(paramFormat,'char')
                
            elseif strcmpi(paramFormat,'Glass')
                
            else
                
            end
        end
        figureHandle.Object.UniqueParameters.(paramName) = editedParamValue;
    end
    
    
    function tblGlassPatrameters_CellSelectionCallback(hObject,eventdata,figureHandle)
        % hObject    handle to aodHandles.tblStandardData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        selectedRow = eventdata.Indices(1);
        selectedColumn = eventdata.Indices(2);
        if selectedColumn == 2
            glassType = figureHandle.Object.GlassType;
            [glassParameterFields,glassParameterFormats,~] = getGlassUniqueParameters( glassType);
            paramName = glassParameterFields{selectedRow};
            paramFormat = glassParameterFormats{selectedRow};
            if iscell(paramFormat)
                % Multiple choice values
                choice = menu(paramName,paramFormat);
                if choice == 0
                    choice = 1;
                end
                editedParamValue = choice;
                figureHandle.Object.UniqueParameters.(paramName) = editedParamValue;
            else
                if strcmpi(paramFormat,'logical')
                    
                elseif strcmpi(paramFormat,'numeric')
                    
                elseif strcmpi(paramFormat,'char')
                    
                elseif strcmpi(paramFormat,'Glass')
                    
                else
                    
                end
            end
        end
    end
    
    function popDispersionFormulaType_Callback(hObject,eventdata,figureHandle)
        % hObject    handle to popDispersionFormulaType (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        %         formulaTypeList =  get(figureHandle.Object.popDispersionFormulaType,'String');
        selectedFormulaType = get(hObject,'Value');
        figureHandle.Object.UniqueParameters.FormulaType = selectedFormulaType;
        displayCurrentParameters(figureHandle);
        makeEditable(figureHandle);
    end
    
    function tblCoefficientData_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblCoefficientData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        
        if editedColumn == 2 % Coefficient value changed
            newCoeff = (eventdata.NewData);
            if isempty(newCoeff)
                msgbox('Error: Please enter valid coefficient data.');
                newCoeff = (eventdata.PreviousData);
            end
            
            tblData1 = get(figureHandle.Object.tblCoefficientData,'data');
            tblData1{editedRow,editedColumn} = newCoeff;
            set(figureHandle.Object.tblCoefficientData, 'Data', tblData1);
            figureHandle.Object.UniqueParameters.CoefficientData(editedRow) =  newCoeff;
        else
            
        end
        
    end
    
    function tblInternalTransmittance_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblInternalTransmittance (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        newData = (eventdata.NewData);
        if isempty(newData)
            msgbox('Error: Please enter valid numeric data.');
            newData = (eventdata.PreviousData);
        end
        
        tblData1 = get(figureHandle.Object.tblInternalTransmittance,'data');
        tblData1{editedRow,editedColumn} = newData;
        set(figureHandle.Object.tblInternalTransmittance, 'Data', tblData1);
        figureHandle.Object.UniqueParameters.InternalTransmittance(editedRow,editedColumn) =  newData;
    end
    
    function tblThermalData_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblThermalData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        
        if editedColumn == 2 % Coefficient value changed
            newThermalData = (eventdata.NewData);
            if isempty(newThermalData)
                msgbox('Error: Please enter valid numeric data.');
                newThermalData = (eventdata.PreviousData);
            end
            
            tblData1 = get(figureHandle.Object.tblThermalData,'data');
            tblData1{editedRow,editedColumn} = newThermalData;
            set(figureHandle.Object.tblThermalData, 'Data', tblData1);
            figureHandle.Object.UniqueParameters.ThermalData(editedRow) =  newThermalData;
        else
            
        end
        
    end
    
    function tblWavelengthRange_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblWavelengthRange (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        
        if editedColumn == 2 % Coefficient value changed
            newWavelengthRange = (eventdata.NewData);
            if isempty(newWavelengthRange)
                msgbox('Error: Please enter valid numeric data.');
                newWavelengthRange = (eventdata.PreviousData);
            end
            
            tblData1 = get(figureHandle.Object.tblWavelengthRange,'data');
            tblData1{editedRow,editedColumn} = newWavelengthRange;
            set(figureHandle.Object.tblWavelengthRange, 'Data', tblData1);
            figureHandle.Object.UniqueParameters.WavelengthRange(editedRow) =  newWavelengthRange;
        else
            
        end
        
    end
    
    function tblResistanceData_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblResistanceData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        
        if editedColumn == 2 % Coefficient value changed
            newResistanceData = (eventdata.NewData);
            if isempty(newResistanceData)
                msgbox('Error: Please enter valid numeric data.');
                newResistanceData = (eventdata.PreviousData);
            end
            
            tblData1 = get(figureHandle.Object.tblResistanceData,'data');
            tblData1{editedRow,editedColumn} = newResistanceData;
            set(figureHandle.Object.tblResistanceData, 'Data', tblData1);
            figureHandle.Object.UniqueParameters.ResistanceData(editedRow) =  newResistanceData;
        else
            
        end
        
    end
    function tblOtherData_CellEditCallback(hObject,eventdata,figureHandle)
        % hObject    handle to tblOtherData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % figureHandle    structure with figureHandle and user data (see GUIDATA)
        
        editedRow = eventdata.Indices(1);
        editedColumn = eventdata.Indices(2);
        
        if editedColumn == 2 % Coefficient value changed
            newOtherData = (eventdata.NewData);
            if isempty(newOtherData)
                msgbox('Error: Please enter valid numeric data.');
                newOtherData = (eventdata.PreviousData);
            end
            
            tblData1 = get(figureHandle.Object.tblOtherData,'data');
            tblData1{editedRow,editedColumn} = newOtherData;
            set(figureHandle.Object.tblOtherData, 'Data', tblData1);
            figureHandle.Object.UniqueParameters.OtherData(editedRow) =  newOtherData;
        else
            
        end
        
    end
    
    function txtGlassComment_Callback(hObject,~,figureHandle)
        comment = get(hObject,'String');
        figureHandle.Object.GlassComment = comment;
    end
    
    function popGlassType_Callback(hObject,~,figureHandle)
        
        glassTypeList =  get(figureHandle.Object.popGlassType,'String');
        selectedGlassType = glassTypeList{get(hObject,'Value')};

        [~,~,defaultGlassparameters] = ...
            getGlassUniqueParameters( selectedGlassType);
        
        figureHandle.Object.GlassType = selectedGlassType;
        figureHandle.Object.UniqueParameters = defaultGlassparameters;
        
        displayCurrentParameters(figureHandle)
        makeEditable(figureHandle);
    end
    
    
    %% ---------------------------------------------------------------------------
    %% ---------------------------------------------------------------------------
    function cmdNewGlass_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        glassNameCellArray = inputdlg('Enter the new glass name : ','New Glass');
        if isempty(glassNameCellArray)
            return;
        else
            glassName = glassNameCellArray{1};
        end
        glassCatalogueFileList = {'All'};
        glassTypeIndex = listdlg('PromptString','Select the glass type :',...
            'SelectionMode','single',...
            'ListString',supportedGlassTypes);
        if isempty(glassTypeIndex)
            glassType = 'IdealNonDispersive';
        else
            glassType = supportedGlassTypes{glassTypeIndex};
        end
        % Save the new glass and update the display
        newGlass = Glass(glassName,glassCatalogueFileList,glassType);
        
        figureHandle.Object.GlassName = glassName;
        figureHandle.Object.GlassType = glassType;
        figureHandle.Object.UniqueParameters = newGlass.UniqueParameters;
        
        glassSavedIndex = newGlass.SavedIndex;
        if glassSavedIndex == 0
            glassSavedIndex = 1;
        end
        refreshGlassDataInputDialog(figureHandle,glassSavedIndex);
        makeEditable(figureHandle);
    end
    %% ---------------------------------------------------------------------------
    function cmdDeleteGlass_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        % Confirm action
        % Construct a questdlg with three options
        objectName = get(figureHandle.Object.txtGlassName,'String');
        choice = questdlg(['Are you sure to delete the glass : ',objectName,' ?'], ...
            'Confirm Deletion', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                % Delete the glass
                glassCatalogueIndex = get(figureHandle.Object.popGlassCatalogueName,'Value');
                GlassCatalogueFullName = glassCatalogueListFullNames{glassCatalogueIndex};
                objectType = 'glass';
                objectName = get(figureHandle.Object.txtGlassName,'String');
                objectCatalogueFullName = GlassCatalogueFullName;
                removeObjectFromObjectCatalogue(objectType, objectName,objectCatalogueFullName )
                refreshGlassDataInputDialog(figureHandle,1);
            case 'No'
                % Do  nothing
        end
    end
    
    function cmdEditSaveGlass_Callback(~,~,figureHandle) %#ok<INUSD>
        if strcmpi(get(figureHandle.Object.cmdEditSaveGlass,'String'),'Edit')
            makeEditable(figureHandle);
        else
            objectType = 'glass';
            currentGlass = getCurrentGlass(figureHandle);
            objectCatalogueFullName = figureHandle.Object.GlassCatalogueFullName;
            addedPosition = addObjectToObjectCatalogue(objectType, currentGlass,objectCatalogueFullName,'replace');
            refreshGlassDataInputDialog(figureHandle,addedPosition);
            makeUneditable(figureHandle);
        end
    end
    %% ---------------------------------------------------------------------------
    function cmdOk_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        currentGlass = getCurrentGlass(figureHandle);
        setappdata(0,'Glass',currentGlass);
        close(figureHandle.Object.MainFigureHandle);
    end
    
    function currentGlass = getCurrentGlass(figureHandle)
        name = figureHandle.Object.GlassName;
        comment = figureHandle.Object.GlassComment;
        catalogueFileList = {figureHandle.Object.GlassCatalogueFullName};
        type = figureHandle.Object.GlassType;
        
        parameters = figureHandle.Object.UniqueParameters; %
        internalTransmittance = figureHandle.Object.GlassInternalTransmittance;
        thermalData = figureHandle.Object.GlassThermalData;
        wavelengthRange = figureHandle.Object.GlassWavelengthRange;
        resistanceData = figureHandle.Object.GlassResistanceData;
        otherData = figureHandle.Object.GlassOtherData;
        savedIndex = figureHandle.Object.SelectedGlassIndex;
        
        currentGlass = Glass();
        currentGlass.Name = name;
        currentGlass.Type = type;
        currentGlass.UniqueParameters = parameters;
        currentGlass.InternalTransmittance = internalTransmittance;
        currentGlass.ResistanceData = resistanceData;
        currentGlass.ThermalData = thermalData;
        currentGlass.OtherData = otherData;
        currentGlass.WavelengthRange  = wavelengthRange;
        currentGlass.Comment = comment; %
        currentGlass.ClassName = 'Glass';
        currentGlass.SavedIndex = savedIndex;
    end
    
    %% ---------------------------------------------------------------------------
    function cmdCancel_Callback(hObject,evendata,figureHandle) %#ok<INUSD>
        currentGlass = Glass;
        setappdata(0,'Glass',currentGlass);
        close(figureHandle.Object.MainFigureHandle);
    end
    
    function makeEditable(figureHandle)
        %         set(figureHandle.Object.txtGlassName,'Enable','On');
        set(figureHandle.Object.txtGlassComment,'Enable','On');
        set(figureHandle.Object.popGlassType,'Enable','On');
        set(findall(figureHandle.Object.glassParametersTabGroup, '-property', 'enable'), 'enable', 'On');
        set(figureHandle.Object.cmdEditSaveGlass,'String','Save');
    end
    function makeUneditable(figureHandle)
        set(figureHandle.Object.txtGlassName,'Enable','Off');
        set(figureHandle.Object.txtGlassComment,'Enable','Off');
        set(figureHandle.Object.popGlassType,'Enable','Off');
        set(findall(figureHandle.Object.glassParametersTabGroup, '-property', 'enable'), 'enable', 'off');
        set(figureHandle.Object.cmdEditSaveGlass,'String','Edit');
    end
    
    function figureCloseRequestFunction(~,~,figureHandle)
        delete(figureHandle.Object.MainFigureHandle);
    end
end

