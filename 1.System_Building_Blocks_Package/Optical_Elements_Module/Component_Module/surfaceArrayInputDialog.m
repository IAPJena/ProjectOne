function [ surfaceArrayEnteryFig ] = surfaceArrayInputDialog(initialSurfaceArray,isSurfaceArrayComponent,glassCatalogueListFullNames,coatingCatalogueListFullNames, fontName,fontSize )
    %surfaceArrayInputDialog Displays a dialog window that lets the
    %user to enter the sequence of surface. Saves the surface array selected
    % as appdata to root.
    
    % Default Input
    if nargin == 0
        initialSurfaceArray = Surface();
        initialSurfaceArray.StopSurfaceIndex = 1;
        isSurfaceArrayComponent = 0;
        glassCatalogueListFullNames = getAllObjectCatalogues('Glass');
        coatingCatalogueListFullNames = getAllObjectCatalogues('Coating');
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 1
        isSurfaceArrayComponent = 0;
        glassCatalogueListFullNames = getAllObjectCatalogues('Glass');
        coatingCatalogueListFullNames = getAllObjectCatalogues('Coating');
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 2
        glassCatalogueListFullNames = getAllObjectCatalogues('Glass');
        coatingCatalogueListFullNames = getAllObjectCatalogues('Coating');
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 3
        coatingCatalogueListFullNames = getAllObjectCatalogues('Coating');
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 4
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 5
        fontName = 'FixedWidth';
    end
    
    % Creation of all uicontrols
    % --- FIGURE -------------------------------------
    figureHandle = ObjectHandle(struct()); % Handle object enables modification of the parameters by callbacks
    figureHandle.Object.SelectedSurfaceIndex = 1;
    figureHandle.Object.CanAddSurface = 1;
    figureHandle.Object.CanRemoveSurface = 0;
    
    figureHandle.Object.MainFigureHandle = figure( ...
        'Tag', 'MainFigureHandle', ...
        'Units','Normalized',...
        'Position', [0.3,0.3,0.45,0.5], ...
        'Name', 'Surface Array Entry', ... %'WindowStyle','Modal',...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...%        'WindowStyle','Modal',...
        'Color', get(0,'DefaultUicontrolBackgroundColor'),...
        'CloseRequestFcn',{@figureCloseRequestFunction,figureHandle});
    surfaceArrayEnteryFig = figureHandle.Object.MainFigureHandle;
    
    figureHandle.Object.btnOk = uicontrol( ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnOk', ...
        'String','OK');
    figureHandle.Object.btnCancel = uicontrol( ...
        'Units', 'Normalized', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnCancel', ...
        'String','Cancel');
    
    figureHandle.Object.panelParameter = uipanel( ...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Tag', 'parameter', ...
        'Units','Normalized',...
        'Position', [0,0,1,0.98], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','on');
    
    figureHandle.Object.SurfaceArrayEditorTabGroup = uitabgroup(...
        'Parent', figureHandle.Object.panelParameter, ...
        'Units', 'Normalized', ...
        'Position', [0, 0.15, 1.0, 0.75]);
    figureHandle.Object.SurfaceArrayBasicDataTab = ...
        uitab(figureHandle.Object.SurfaceArrayEditorTabGroup, 'title','Standard Data');
    figureHandle.Object.SurfaceArrayApertureDataTab = ...
        uitab(figureHandle.Object.SurfaceArrayEditorTabGroup, 'title','Aperture Data');
    figureHandle.Object.SurfaceArrayTiltDecenterDataTab = ...
        uitab(figureHandle.Object.SurfaceArrayEditorTabGroup, 'title','Tilt Decenter Data');
    
    % Initialize the panel and table for standard data
    figureHandle.Object.tblSurfaceArrayBasicData = uitable('Parent',figureHandle.Object.SurfaceArrayBasicDataTab,...
        'FontSize',fontSize,'FontName', fontName,'units','normalized','Position',[0 0 1 1]);
    % Initialize the panel and table for standard data
    % depends on the surface type
    % Set the Column Names of the Standard data table
    
    % Initialize the panel and table for aperture data
    figureHandle.Object.tblSurfaceArrayApertureData = ...
        uitable('Parent',figureHandle.Object.SurfaceArrayApertureDataTab,'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 1]);
    
    % Initialize the panel and table for tilt decenter data
    figureHandle.Object.tblSurfaceArrayTiltDecenterData = ...
        uitable('Parent',figureHandle.Object.SurfaceArrayTiltDecenterDataTab,'FontSize',fontSize,'FontName', fontName,...
        'units','normalized','Position',[0 0 1 1]);
    % Tilt and Decenter order = index of [dx,dy,tx,ty,tz]
    
    
    % Set all celledit and cellselection callbacks
    set(figureHandle.Object.tblSurfaceArrayBasicData,...
        'CellEditCallback',{@tblSurfaceArrayBasicData_CellEditCallback,figureHandle,glassCatalogueListFullNames,coatingCatalogueListFullNames},...
        'CellSelectionCallback',{@tblSurfaceArrayBasicData_CellSelectionCallback,figureHandle});
    
    set(figureHandle.Object.tblSurfaceArrayApertureData,...
        'CellEditCallback',{@tblSurfaceArrayApertureData_CellEditCallback,figureHandle},...
        'CellSelectionCallback',{@tblSurfaceArrayApertureData_CellSelectionCallback,figureHandle});
    set(figureHandle.Object.tblSurfaceArrayTiltDecenterData,...
        'CellEditCallback',{@tblSurfaceArrayTiltDecenterData_CellEditCallback,figureHandle},...
        'CellSelectionCallback',{@tblSurfaceArrayTiltDecenterData_CellSelectionCallback,figureHandle});
    
    
    % open the currentSurface array in the tables
    figureHandle.Object.TemporarySurfaceArray = initialSurfaceArray;
    figureHandle.Object.IsSurfaceArrayComponent = isSurfaceArrayComponent;
    figureHandle.Object.SelectedSurfaceIndex = 1;
    updateSurfaceEditor(figureHandle);
    
    % Command buttons for adding and removing surfaces
    figureHandle.Object.btnInsertSurfaceToSurfaceArray = uicontrol( ...
        'Parent',figureHandle.Object.panelParameter,...
        'Style', 'pushbutton', ...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.0,0.91,0.075,0.08],...
        'String','Insert',...
        'Callback',{@btnInsertSurfaceToSurfaceArray_Callback,figureHandle});
    figureHandle.Object.btnRemoveSurfaceFromSurfaceArray = uicontrol( ...
        'Parent',figureHandle.Object.panelParameter,...
        'Style', 'pushbutton', ...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.1,0.91,0.075,0.08],...
        'String','Remove',...
        'Callback',{@btnRemoveSurfaceFromSurfaceArray_Callback,figureHandle});
    figureHandle.Object.btnStopSurfaceOfSurfaceArray = uicontrol( ...
        'Parent',figureHandle.Object.panelParameter,...
        'Style', 'pushbutton', ...
        'FontSize',fontSize,'FontName', fontName,...
        'units','normalized',...
        'Position',[0.2,0.91,0.075,0.08],...
        'String','Make Stop',...
        'Callback',{@btnStopSurfaceOfSurfaceArray_Callback,figureHandle});
    
    set(figureHandle.Object.MainFigureHandle,'Position', [0.1, 0.3, 0.8, 0.4]);
    set(figureHandle.Object.btnOk,'Parent', figureHandle.Object.panelParameter, ...
        'Units', 'Normalized', ...
        'Position', [0.01 0.02 0.075 0.08]);
    set(figureHandle.Object.btnCancel,'Parent', figureHandle.Object.panelParameter, ...
        'Units', 'Normalized', ...
        'Position', [0.12 0.02 0.075 0.08]);
    
    set(figureHandle.Object.btnOk,...
        'Callback', {@btnOk_Callback,figureHandle});
    set(figureHandle.Object.btnCancel,...
        'Callback', {@btnCancel_Callback,figureHandle});
    set(figureHandle.Object.MainFigureHandle,'Visible','on');
    
    function figureCloseRequestFunction(~,~,figureHandle)
        delete(figureHandle.Object.MainFigureHandle);
    end
end

function updateSurfaceEditor(figureHandle)
    % Fill the surface parameters to the GUI
    guiHandleStruct = figureHandle.Object;
    currentSurfaceArray = guiHandleStruct.TemporarySurfaceArray;
    selectedSurface = guiHandleStruct.SelectedSurfaceIndex;
    isSurfaceArrayComponent = guiHandleStruct.IsSurfaceArrayComponent;
    nSurface = length(currentSurfaceArray);
    % initializ
    savedBasicData = cell(nSurface,20);
    savedApertureData = cell(1,15);
    savedTiltDecenterData = cell(1,16);
    stopAlreadyFound = 0;
    
    for kk = 1:1:nSurface
        %standard data
        if currentSurfaceArray(kk).StopSurfaceIndex && ~stopAlreadyFound
            savedBasicData{kk,1} = 'STOP';
            stopAlreadyFound = 1;
        else
            savedBasicData{kk,1} = '';
        end

        savedBasicData{kk,2} = char(currentSurfaceArray(kk).Comment);
        savedBasicData{kk,3} = GetSupportedSurfaceTypes(currentSurfaceArray(kk).Type);
        savedBasicData{kk,4} = '';
        savedBasicData{kk,5} = (currentSurfaceArray(kk).Thickness);
        savedBasicData{kk,6} = '';
        
        switch char(currentSurfaceArray(kk).Glass.Name)
            case {'None',''}
                glassDisplayName = '';
            case 'FixedIndexGlass'
                glassDisplayName = ...
                    [num2str(currentSurfaceArray(kk).Glass.GlassParameters(1),'%.4f '),',',...
                    num2str(currentSurfaceArray(kk).Glass.GlassParameters(2),'%.4f '),',',...
                    num2str(currentSurfaceArray(kk).Glass.GlassParameters(3),'%.4f ')];
            otherwise
                glassDisplayName = upper(char(currentSurfaceArray(kk).Glass.Name));
        end
        savedBasicData{kk,7} = glassDisplayName;
        savedBasicData{kk,8} = '';
        
        savedBasicData{kk,9} = upper(num2str(currentSurfaceArray(kk).Coating.Name));
        savedBasicData{kk,10} = '';
        
        savedBasicData{kk,11} = (currentSurfaceArray(kk).Radius);
        savedBasicData{kk,12} = '';
        
        savedBasicData{kk,13} = (currentSurfaceArray(kk).Conic);
        savedBasicData{kk,14} = '';
        % Other surface type specific standard data
        [fieldNames,fieldDisplayNames,fieldFormat,myUniqueParamStruct] = getSurfaceUniqueParameters(currentSurfaceArray(kk));
        nUniqueParameters = length(fieldNames);
        if nUniqueParameters == 1 && isempty(fieldNames{1})
            % No unique parameters defined
        else
            for ff = 1:length(fieldNames)
                savedBasicData{kk,14 + ff} = (currentSurfaceArray(kk).UniqueParameters.(fieldNames{ff}));
            end
        end
        
%         try
%             for ff = 1:length(fieldNames)
%                 savedBasicData{kk,10 + ff} = (currentSurfaceArray(kk).UniqueParameters.(fieldNames{ff}));
%             end
%         catch
%             for ff = 1:10
%                 savedBasicData{kk,10 + ff} = myUniqueParamStruct{ff};
%             end
%         end
        
        % aperture data
        if ~isSurfaceArrayComponent || kk == 1
            currentAperture = currentSurfaceArray(kk).Aperture;
            savedApertureData{kk,1} = savedBasicData{kk,1};
            savedApertureData{kk,2} = savedBasicData{kk,3};
            savedApertureData{kk,3} = GetSupportedSurfaceApertureTypes(currentAperture.Type);
            savedApertureData{kk,4} = currentAperture.Decenter(1);
            savedApertureData{kk,5} = currentAperture.Decenter(2);
            savedApertureData{kk,6} = currentAperture.Rotation;
            savedApertureData{kk,7} = currentAperture.DrawAbsolute;
            savedApertureData{kk,8} = currentAperture.OuterShape;
            savedApertureData{kk,9} = currentAperture.AdditionalEdge;
            
            % Other surface type specific standard data
            [fieldNames,fieldFormat,myUniqueParamStruct,fieldDisplayNames] = getApertureUniqueParameters(currentAperture);
            for ff = 1:length(fieldNames)
                savedApertureData{kk,9 + ff} = (myUniqueParamStruct.(fieldNames{ff}));
            end
        end
        
        
        %tilt decenter data
        if ~isSurfaceArrayComponent || kk == 1
            savedTiltDecenterData{kk,1} = savedBasicData{kk,1};
            savedTiltDecenterData{kk,2} = savedBasicData{kk,3};

            % Validate Data
            order = GetSupportedTiltDecenterOrder(currentSurfaceArray(kk).TiltDecenterOrder);
            if isValidGeneralInput(order,'TiltDecenterOrder')
                savedTiltDecenterData{kk,3} = order;
            else
                % set default
                savedTiltDecenterData{kk,3} = 'DxDyDzTxTyTz';
            end
            savedTiltDecenterData{kk,4} = '';
            savedTiltDecenterData{kk,5} = (currentSurfaceArray(kk).Decenter(1));
            savedTiltDecenterData{kk,6} = '';
            savedTiltDecenterData{kk,7} = (currentSurfaceArray(kk).Decenter(2));
            savedTiltDecenterData{kk,8} = '';
            savedTiltDecenterData{kk,9} = (currentSurfaceArray(kk).Tilt(1));
            savedTiltDecenterData{kk,10} = '';
            savedTiltDecenterData{kk,11} = (currentSurfaceArray(kk).Tilt(2));
            savedTiltDecenterData{kk,12} = '';
            savedTiltDecenterData{kk,13} = (currentSurfaceArray(kk).Tilt(3));
            savedTiltDecenterData{kk,14} = '';
            savedTiltDecenterData{kk,15} = char(currentSurfaceArray(kk).TiltMode);
            savedTiltDecenterData{kk,16} = '';
        end
    end
    set(guiHandleStruct.tblSurfaceArrayBasicData, 'Data', savedBasicData);
    % update column properties  basic data table
    [fieldNames,fieldDisplayNames,fieldFormat,myUniqueParamStruct] = getSurfaceUniqueParameters(currentSurfaceArray(selectedSurface));
    
    nColumns = size(fieldNames,2);
    columnNames = fieldDisplayNames;
    columnWidth = num2cell(100*ones(1,nColumns));
    columnEditable = num2cell(ones(1,nColumns));
    if isempty(fieldFormat{1})
        columnFormat = {'char'};
    else
        columnFormat = [fieldFormat(:)];
    end
    supportedSurfaces = GetSupportedSurfaceTypes();
    
    columnName1 =   {'Surface', 'Name/Note', 'Surface Type', '',...
        'Thickness', '', 'Glass', '','Coating', '','Radius', '','Conic', '',columnNames{:}};
    columnWidth1 = {80, 100, 120, 15, 80, 15, 80, 15, 80, 15, 80, 15,80, 15,columnWidth{:}};
    columnEditable1 =  [false true true false true false true false true ...
        false true false true false columnEditable{:}];
    set(guiHandleStruct.tblSurfaceArrayBasicData, 'ColumnFormat', ...
        {'char', 'char',{supportedSurfaces{:}},'char','numeric', 'char','char', 'char',...
        'char', 'char','char', 'char','char', 'char', columnFormat{:}});
    set(guiHandleStruct.tblSurfaceArrayBasicData,'ColumnEditable', logical(columnEditable1),...
        'ColumnName', columnName1,'ColumnWidth',columnWidth1);
    
    
    set(guiHandleStruct.tblSurfaceArrayApertureData, 'Data', savedApertureData);
    % update column properties aperture
    [fieldNames,fieldFormat,defaultUniqueParamStruct,fieldDisplayNames] = getApertureUniqueParameters( currentSurfaceArray(selectedSurface).Aperture );
%     apertureDefinition = GetSupportedSurfaceApertureTypes(currentSurfaceArray(selectedSurface).Aperture.Type);
%     apertureDefinitionHandle = str2func(apertureDefinition);
%     returnFlag = 1;
%     [fieldNames,fieldFormat,defaultUniqueParamStruct,fieldDisplayNames] = apertureDefinitionHandle(returnFlag);
    
    nColumns = size(fieldNames,2);
    columnNames = fieldDisplayNames;
    columnWidth = num2cell(100*ones(1,nColumns));
    columnEditable = num2cell(ones(1,nColumns));
    columnFormat = [fieldFormat(:)];
    
    supportedApertureTypes = GetSupportedSurfaceApertureTypes();
    supportedApertureOuterShapes = GetSupportedSurfaceApertureOuterShapes();
    
    columnName1 =   {'Surface','Surface Type','Aperture Type','DecenterX','DecenterY','Rotation','DrawAbsolute','OuterShape','AdditionalEdge',columnNames{:}};
    columnWidth1 = {80, 120, 120,80,80,80,80,80,80,columnWidth{:}};
    columnEditable1 =  [false, false,true, true, true, true, true, true, true, columnEditable{:}];
    columnFormat1 = {'char','char',supportedApertureTypes,'numeric','numeric','numeric','logical',supportedApertureOuterShapes,'numeric', columnFormat{:}};
    
    set(guiHandleStruct.tblSurfaceArrayApertureData,'ColumnEditable', logical(columnEditable1),...
        'ColumnName', columnName1,'ColumnWidth',columnWidth1,'ColumnFormat',columnFormat1);
    
    set(guiHandleStruct.tblSurfaceArrayTiltDecenterData, 'Data', savedTiltDecenterData);
    
    % update column properties  tilt decenter data table
    columnName5 =   ...
        {'  Surface  ', 'Surface Type', '    Order    ', '', ...
        'Decenter X', '', 'Decenter Y', '', 'Tilt X', '',...
        'Tilt Y', '', 'Tilt Z', '', 'Tilt Mode', ''};
    columnWidth5 =   {80, 120, 120, 15, 80, 15, 80, 15, 80, 15,...
        80,15, 80, 15, 80, 15};
    columnEditable5 =  ...
        [false false true false true false true false true false ...
        true false true false true false];
    tiltModes = GetSupportedTiltModes();
    set(figureHandle.Object.tblSurfaceArrayTiltDecenterData , 'ColumnFormat', {'char', 'char', 'char','char', 'numeric',...
        'char','numeric', 'char', 'numeric', 'char', 'numeric', 'char', 'numeric', 'char', ...
        tiltModes,'char'});
    set(figureHandle.Object.tblSurfaceArrayTiltDecenterData,'ColumnEditable', ...
        columnEditable5,'ColumnName', columnName5,'ColumnWidth',columnWidth5);
    
    
    figureHandle.Object =  guiHandleStruct;
end

% CellEditCallback
% --- Executes when entered data in editable cell(s) in aodHandles.tblSurfaceArrayBasicData.
function tblSurfaceArrayBasicData_CellEditCallback(~, eventdata,figureHandle,glassCatalogueListFullNames,coatingCatalogueListFullNames)
    % hObject    handle to aodHandles.tblSurfaceArrayBasicData (see GCBO)
    % eventdata  structure with the following fields (see UITABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object;
    editedRow = eventdata.Indices(1);
    editedColumn = eventdata.Indices(2);
    selectedSurfaceIndex = editedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;

    selectedSurface = guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex);
    if editedColumn == 3 && ~(strcmpi(eventdata.NewData,''))
        %if surface type is changed update all tables in the editor
        %         editedSurfaceIndex = eventdata.Indices(1);
        newSurfaceType = eventdata.NewData;
        prevStopSurfaceIndex = find([guiHandleStruct.TemporarySurfaceArray.StopSurfaceIndex]);
        if isempty(prevStopSurfaceIndex)
            prevStopSurfaceIndex = 1;
        end
        selectedSurface = Surface(newSurfaceType);
        if prevStopSurfaceIndex == selectedSurfaceIndex
            selectedSurface.StopSurfaceIndex = 1;
        end
    elseif editedColumn == 5 % if thickness is changed
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Thickness = newParam;
    elseif editedColumn == 7 % if glass is changed
        glassName = eventdata.NewData;
        newGlass = Glass(upper(glassName),glassCatalogueListFullNames);
        %         editedSurfaceIndex = eventdata.Indices(1);
        selectedSurface.Glass = newGlass;
    elseif editedColumn == 9 % if coating is changed
        coatingName = eventdata.NewData;
        newCoating = Coating(upper(coatingName),coatingCatalogueListFullNames);
        %         editedSurfaceIndex = eventdata.Indices(1);
        selectedSurface.Coating = newCoating;
    elseif editedColumn == 11 % if Radius is changed
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Radius = newParam;
    elseif editedColumn == 13 % if Conic is changed
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Conic = newParam;
    else
        % other unique parameters
        [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
            getSurfaceParameters(selectedSurface,'Basic',editedColumn-9);
        
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
    guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex) = selectedSurface;
    guiHandleStruct.SelectedSurfaceIndex = editedRow;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end
% --- Executes when entered data in editable cell(s) in aodHandles.tblSurfaceArrayApertureData.
function tblSurfaceArrayApertureData_CellEditCallback(~,eventdata,figureHandle)
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object ;
    editedColumn = eventdata.Indices(2);
    editedRow = eventdata.Indices(1);
    selectedSurfaceIndex = editedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;

    selectedSurface = guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex);
    
    if editedColumn == 3 % aperture type
        apertureType = (eventdata.EditData);
        if isempty(apertureType)
            apertureType = (eventdata.PreviousData);
        end
        selectedSurface.Aperture = Aperture(apertureType);
    elseif editedColumn == 4 % dec x
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Aperture.Decenter(1) = newParam;
    elseif editedColumn == 5 % dec y
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Aperture.Decenter(2) = newParam;
    elseif editedColumn == 6 % rotation
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Aperture.Rotation = newParam;
    elseif editedColumn == 7 % draw absolute
        newParam = (eventdata.EditData);
        if isempty(newParam)
            newParam = (eventdata.PreviousData);
        end
        selectedSurface.Aperture.DrawAbsolute = newParam;
    elseif editedColumn == 8 % outer aperture shape
        newParam = (eventdata.EditData);
        if isempty(newParam)
            newParam = (eventdata.PreviousData);
        end
        selectedSurface.Aperture.OuterShape = newParam;
    elseif editedColumn == 9 % additional edge
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = str2num(eventdata.PreviousData);
        end
        selectedSurface.Aperture.AdditionalEdge = newParam;
    else
        % Other unique parameters
        [ paramNames,paramTypes,paramValues,paramValuesDisp] = ...
            getSurfaceParameters(selectedSurface,'Aperture',editedColumn-2);
        
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
    guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex) = selectedSurface;
    guiHandleStruct.SelectedSurfaceIndex = editedRow;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end
% --- Executes when entered data in editable cell(s) in aodHandles.tblSurfaceArrayTiltDecenterData.
function tblSurfaceArrayTiltDecenterData_CellEditCallback(~, eventdata,figureHandle)
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object ;
    editedColumn = eventdata.Indices(2);
    editedRow = eventdata.Indices(1);
    selectedSurfaceIndex = editedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;

    if editedColumn == 3  % 3rd row / tiltanddecenter data
        if isempty(eventdata.NewData) || ...
                ~isValidGeneralInput(eventdata.NewData,'TiltDecenterOrder')
            % restore previous data
            tblSurfaceArrayData = get(guiHandleStruct.tblSurfaceArrayTiltDecenterData,'data');
            tblSurfaceArrayData{eventdata.Indices(1),3} = eventdata.PreviousData;
            set(guiHandleStruct.tblSurfaceArrayTiltDecenterData, 'Data', tblSurfaceArrayData);
        else
            % valid input so format the text
            
            orderString = upper(eventdata.EditData);
            if length(orderString) ~= 12
                orderString = upper(eventdata.PreviousData);
            end
            guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).TiltDecenterOrder = ...
                {orderString(1:2),orderString(3:4),...
                orderString(5:6),orderString(7:8),orderString(9:10),orderString(11:12)};
        end
    elseif editedColumn == 5 % dec x
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = 0;
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).Decenter(1) = newParam;
    elseif editedColumn == 7 % dec y
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = 0;
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).Decenter(2) = newParam;
    elseif editedColumn == 9 % tilt x
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = 0;
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).Tilt(1) = newParam;
    elseif editedColumn == 11 % tilt y
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = 0;
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).Tilt(2) = newParam;
    elseif editedColumn == 13 % tilt z
        newParam = str2num(eventdata.EditData);
        if isempty(newParam)
            newParam = 0;
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).Tilt(3) = newParam;
    elseif editedColumn == 15 % tilt mode
        newParam = (eventdata.EditData);
        if isempty(newParam)
            newParam = 'DAR';
        end
        guiHandleStruct.TemporarySurfaceArray(selectedSurfaceIndex).TiltMode = newParam;
    end
    guiHandleStruct.SelectedSurfaceIndex = editedRow;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end
% --- Executes when selected cell(s) is changed in aodHandles.tblSurfaceArrayBasicData.
function tblSurfaceArrayBasicData_CellSelectionCallback(~, eventdata,figureHandle)
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object ;
    selectedRow = eventdata.Indices(1);
    selectedColumn = eventdata.Indices(2);
    selectedSurfaceIndex = selectedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;

    tblSurfaceArrayData = get(guiHandleStruct.tblSurfaceArrayBasicData,'data');
    sizetblSurfaceArrayData = size(tblSurfaceArrayData);
    
    if selectedColumn == 1 && ...
            ~strcmpi(tblSurfaceArrayData{1,1},'OBJECT')&& ...
            ~strcmpi(tblSurfaceArrayData{1,1},'IMAGE') % only when the first column selected
        if sizetblSurfaceArrayData(1) == 1
            guiHandleStruct.CanAddSurface = 1;
            guiHandleStruct.CanRemoveSurface = 0;
        else
            guiHandleStruct.CanAddSurface = 1;
            guiHandleStruct.CanRemoveSurface = 1;
        end
    end
    guiHandleStruct.SelectedSurfaceIndex = selectedRow;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end
% --- Executes when selected cell(s) is changed in aodHandles.tblSurfaceArrayApertureData.
function tblSurfaceArrayApertureData_CellSelectionCallback(~, eventdata,figureHandle)
    
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object;
    selectedRow = eventdata.Indices(1);
    selectedColumn = eventdata.Indices(2);

    selectedSurfaceIndex = selectedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end
% --- Executes when selected cell(s) is changed in aodHandles.tblSurfaceArrayTiltDecenterData.
function tblSurfaceArrayTiltDecenterData_CellSelectionCallback(~, eventdata,figureHandle)
    
    if isempty(eventdata.Indices)
        return;
    end
    guiHandleStruct = figureHandle.Object;
    selectedRow = eventdata.Indices(1);
    selectedColumn = eventdata.Indices(2);

    selectedSurfaceIndex = selectedRow;
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;
    figureHandle.Object = guiHandleStruct ;
    updateSurfaceEditor(figureHandle)
end


%% Button Callbacks
function btnInsertSurfaceToSurfaceArray_Callback(~,~,figureHandle)
    guiHandleStruct = figureHandle.Object;
    selectedSurfaceIndex = guiHandleStruct.SelectedSurfaceIndex;
    canAddSurface = guiHandleStruct.CanAddSurface;
    if isempty(selectedSurfaceIndex)
        return
    end
    
    if canAddSurface
        insertPosition = selectedSurfaceIndex;
        InsertNewSurfaceToSurfaceArray(figureHandle,insertPosition);
    end
end
function btnRemoveSurfaceFromSurfaceArray_Callback(~,~,figureHandle)
    guiHandleStruct = figureHandle.Object;
    selectedSurfaceIndex = guiHandleStruct.SelectedSurfaceIndex;
    canRemoveSurface = guiHandleStruct.CanRemoveSurface;
    
    if isempty(selectedSurfaceIndex)
        return
    end
    if canRemoveSurface
        removePosition = selectedSurfaceIndex;
        RemoveSurfaceFromSurfaceArray(figureHandle,removePosition);
    end
end
function btnStopSurfaceOfSurfaceArray_Callback(~,~,figureHandle)
    guiHandleStruct = figureHandle.Object;
    selectedSurfaceIndex = guiHandleStruct.SelectedSurfaceIndex;
    if isempty(selectedSurfaceIndex)
        return
    end
    stopSurfaceIndex = selectedSurfaceIndex;
    
    prevStopSurfaceIndex = find([figureHandle.Object.TemporarySurfaceArray.StopSurfaceIndex]);
    if ~isempty(prevStopSurfaceIndex)
        guiHandleStruct.TemporarySurfaceArray(prevStopSurfaceIndex).StopSurfaceIndex = 0;
    end
    guiHandleStruct.SelectedSurfaceIndex = selectedSurfaceIndex;
    guiHandleStruct.TemporarySurfaceArray(stopSurfaceIndex).StopSurfaceIndex = 1;
    figureHandle.Object = guiHandleStruct;
    updateSurfaceEditor(figureHandle);
end

function btnOk_Callback(~,~,figureHandle)
    figHandle = figureHandle.Object.MainFigureHandle;
    surfaceArray = figureHandle.Object.TemporarySurfaceArray;
    setappdata(0,'SurfaceArray',surfaceArray);
    delete(figHandle);
end
function btnCancel_Callback(~,~,figureHandle)
    figHandle = figureHandle.Object.MainFigureHandle;
    delete(figHandle);
end

%% Local Function
function RemoveSurfaceFromSurfaceArray(figureHandle,removePosition)
    
    guiHandleStruct = figureHandle.Object;
    prevStopSurfaceIndex = find([guiHandleStruct.TemporarySurfaceArray.StopSurfaceIndex]);
    nSurface = length(guiHandleStruct.TemporarySurfaceArray);
    if prevStopSurfaceIndex == removePosition
        stopSurfaceRemoved = 1;
    else
        stopSurfaceRemoved = 0;
    end
    
    if nSurface == removePosition
        nextSelectedSurface = removePosition-1;
    else
        nextSelectedSurface = removePosition;
    end
    guiHandleStruct.SelectedSurfaceIndex = nextSelectedSurface;
    
    % Update the surface array
    guiHandleStruct.TemporarySurfaceArray = guiHandleStruct.TemporarySurfaceArray([1:removePosition-1,removePosition+1:end]);
    
    if length(guiHandleStruct.TemporarySurfaceArray) == 1
        guiHandleStruct.CanRemoveSurface = 0;
        guiHandleStruct.CanAddSurface = 0;
    end
    
    if stopSurfaceRemoved
        if guiHandleStruct.TemporarySurfaceArray(nextSelectedSurface).IsImage
            guiHandleStruct.TemporarySurfaceArray(nextSelectedSurface-1).StopSurfaceIndex = 1;
        else
            guiHandleStruct.TemporarySurfaceArray(nextSelectedSurface).StopSurfaceIndex = 1;
        end
    end
    % The next selected row will be the one in the removed position, so if
    % it is image plane then dont let further removal
    if guiHandleStruct.TemporarySurfaceArray(nextSelectedSurface).IsImage
        canRemoveSurface = 0;
        guiHandleStruct.CanRemoveSurface = canRemoveSurface;
    end
    figureHandle.Object = guiHandleStruct;
    updateSurfaceEditor(figureHandle);
end
function InsertNewSurfaceToSurfaceArray(figureHandle,insertPosition)
    guiHandleStruct = figureHandle.Object;
    
    %update surface list table
    nSurface = length(guiHandleStruct.TemporarySurfaceArray);
    % Update the surface array
    for kk = nSurface:-1:insertPosition
        guiHandleStruct.TemporarySurfaceArray(kk+1) = guiHandleStruct.TemporarySurfaceArray(kk);
    end
    guiHandleStruct.TemporarySurfaceArray(insertPosition) = Surface();
    guiHandleStruct.SelectedSurfaceIndex = insertPosition;
    figureHandle.Object = guiHandleStruct;
    updateSurfaceEditor(figureHandle);
    figureHandle.Object = guiHandleStruct;
end

