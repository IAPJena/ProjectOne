function [figureHandle] = componentParametersInputDialog( parentWindow,componentIndex, parameterIndex)
%componentParametersInputDialog display input window for differetn paramters of components
% display the corresponding window to input boolean, choice and
% SQS data type parameter and make the cell editable for char type
% paramType :  'logical','SQS','char','numeric',{'choise 1','choise 2'}
% saves the paramValueNew and paramValueNewDisplay as workspace variable

aodHandles = parentWindow.AODParentHandles;
fontSize = aodHandles.FontSize;
fontName = aodHandles.FontName;
currentComponent =  aodHandles.OpticalSystem.ComponentArray(componentIndex);
[ componentParametersTable,componentParametersTableDisplay ] = ...
    getComponentParametersTable(currentComponent);
paramName = componentParametersTable{parameterIndex,1};
paramType = componentParametersTable{parameterIndex,3};
paramValueOldDisplay = componentParametersTableDisplay{parameterIndex,2};

% Initialize handles structure
componentParameterInputDialogHandles = struct();

% Create all UI controls
buildComponentParameterInputDialogGUI();

% Assign function output
figureHandle = componentParameterInputDialogHandles.FigureHandle;

    function buildComponentParameterInputDialogGUI()
        componentParameterInputDialogHandles.FigureHandle = figure( ...
            'Tag', paramName, ...
            'Units', 'normalized', ...
            'Name', [paramName], ...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
            'Resize', 'off','Visible','off',...
            'WindowStyle','Modal');
        componentParameterInputDialogHandles.btnOk = uicontrol( ...
            'FontSize',fontSize,'FontName', 'FixedWidth',...
            'Style','pushbutton',...
            'Tag', 'btnOk', ...
            'String','OK');
        componentParameterInputDialogHandles.btnCancel = uicontrol( ...
            'Units', 'Normalized', ...
            'FontSize',fontSize,'FontName', 'FixedWidth',...
            'Style','pushbutton',...
            'Tag', 'btnCancel', ...
            'String','Cancel');
        if strcmpi(class(paramType),'cell')
                % type is choice of popmenu
                 % --- PANELS -------------------------------------
                componentParameterInputDialogHandles.panelParameter = uipanel( ...
                    'Parent', componentParameterInputDialogHandles.FigureHandle, ...
                    'Tag', 'parameter', ...
                    'Units','Normalized',...
                    'Position', [0,0,1,0.95], ...
                    'FontSize',fontSize,'FontName',fontName,...
                    'Visible','on',...
                    'Title', 'Select Parameter');
                componentParameterInputDialogHandles.lblParameterName = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0 0.56 0.45 0.2],...
                    'Tag', 'lblParameterName', ...
                    'Style', 'text', ...
                    'HorizontalAlignment','right',...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'String', paramName);
                oldValueIndex = find(strcmpi(paramType,paramValueOldDisplay));
                componentParameterInputDialogHandles.popParameterValue = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0.55 0.6 0.25 0.2],...
                    'Tag', 'popParameterValue', ...
                    'Style', 'popupmenu', ...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'BackgroundColor', [1 1 1], ...
                    'String', paramType, 'Value',oldValueIndex,...
                    'HorizontalAlignment', 'left');
                                             
                set(componentParameterInputDialogHandles.FigureHandle,'Position', [0.3, 0.4, 0.4, 0.2]);
                set(componentParameterInputDialogHandles.btnOk,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.15 0.1 0.3 0.2]);
                set(componentParameterInputDialogHandles.btnCancel,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.55 0.1 0.3 0.2]);               
                
        else
        switch lower(paramType)
            case {lower('char')}
                % --- PANELS -------------------------------------
                componentParameterInputDialogHandles.panelParameter = uipanel( ...
                    'Parent', componentParameterInputDialogHandles.FigureHandle, ...
                    'Tag', 'parameter', ...
                    'Units','Normalized',...
                    'Position', [0,0,1,0.95], ...
                    'FontSize',fontSize,'FontName',fontName,...
                    'Visible','on',...
                    'Title', 'String Parameter');
                componentParameterInputDialogHandles.lblParameterName = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0 0.56 0.45 0.2],...
                    'Tag', 'lblParameterName', ...
                    'Style', 'text', ...
                    'HorizontalAlignment','right',...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'String', paramName);
                
                componentParameterInputDialogHandles.txtParameterValue = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0.55 0.6 0.25 0.2],...
                    'Tag', 'txtParameterValue', ...
                    'Style', 'edit', ...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'BackgroundColor', [1 1 1], ...
                    'String', paramValueOldDisplay, ...
                    'HorizontalAlignment', 'left');

                set(componentParameterInputDialogHandles.FigureHandle,'Position', [0.3, 0.4, 0.4, 0.2]);
                set(componentParameterInputDialogHandles.btnOk,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.15 0.1 0.3 0.2]);
                set(componentParameterInputDialogHandles.btnCancel,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.55 0.1 0.3 0.2]);
                
            case lower('numeric')
                % --- PANELS -------------------------------------
                componentParameterInputDialogHandles.panelParameter = uipanel( ...
                    'Parent', componentParameterInputDialogHandles.FigureHandle, ...
                    'Tag', 'parameter', ...
                    'Units','Normalized',...
                    'Position', [0,0,1,0.95], ...
                    'FontSize',fontSize,'FontName',fontName,...
                    'Visible','on',...
                    'Title', 'Numeric Parameter');
                componentParameterInputDialogHandles.lblParameterName = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0 0.56 0.45 0.2],...
                    'Tag', 'lblParameterName', ...
                    'Style', 'text', ...
                    'HorizontalAlignment','right',...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'String', paramName);
                
                componentParameterInputDialogHandles.txtParameterValue = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0.55 0.6 0.25 0.2],...
                    'Tag', 'txtParameterValue', ...
                    'Style', 'edit', ...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'BackgroundColor', [1 1 1], ...
                    'String', paramValueOldDisplay, ...
                    'HorizontalAlignment', 'left');
              
                set(componentParameterInputDialogHandles.FigureHandle,'Position', [0.3, 0.4, 0.4, 0.2]);
                set(componentParameterInputDialogHandles.btnOk,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.15 0.1 0.3 0.2]);
                set(componentParameterInputDialogHandles.btnCancel,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.55 0.1 0.3 0.2]);
            case lower('logical')
                % --- PANELS -------------------------------------
                componentParameterInputDialogHandles.panelParameter = uipanel( ...
                    'Parent', componentParameterInputDialogHandles.FigureHandle, ...
                    'Tag', 'parameter', ...
                    'Units','Normalized',...
                    'Position', [0,0,1,0.95], ...
                    'FontSize',fontSize,'FontName',fontName,...
                    'Visible','on',...
                    'Title', 'Logical Parameter');
                componentParameterInputDialogHandles.lblParameterName = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0 0.56 0.45 0.2],...
                    'Tag', 'lblParameterName', ...
                    'Style', 'text', ...
                    'HorizontalAlignment','right',...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'String', paramName);
                    
                componentParameterInputDialogHandles.chkParameterValue = uicontrol( ...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'normalized', ...
                    'Position', [0.55 0.6 0.05 0.2],...
                    'Tag', 'chkParameterValue', ...
                    'Style', 'checkbox', ...
                    'FontSize',fontSize,'FontName', 'FixedWidth',...
                    'BackgroundColor', [1 1 1], ...
                    'HorizontalAlignment', 'left',...
                    'Value',paramValueOldDisplay);
                
                set(componentParameterInputDialogHandles.FigureHandle,'Position', [0.3, 0.4, 0.4, 0.2]);
                set(componentParameterInputDialogHandles.btnOk,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.15 0.1 0.3 0.2]);
                set(componentParameterInputDialogHandles.btnCancel,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.55 0.1 0.3 0.2]);
            case lower('SQS')
                
                componentParameterInputDialogHandles.panelParameter = uipanel( ...
                    'Parent', componentParameterInputDialogHandles.FigureHandle, ...
                    'Tag', 'parameter', ...
                    'Units','Normalized',...
                    'Position', [0,0,1,0.98], ...
                    'FontSize',fontSize,'FontName',fontName,...
                    'Visible','on',...
                    'Title', 'SQS Parameter');

                componentParameterInputDialogHandles.SQSEditorTabGroup = uitabgroup(...
                    'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0, 0.15, 1.0, 0.75]);
                componentParameterInputDialogHandles.SQSStandardDataTab = ...
                    uitab(componentParameterInputDialogHandles.SQSEditorTabGroup, 'title','Standard Data');
                componentParameterInputDialogHandles.SQSApertureDataTab = ...
                    uitab(componentParameterInputDialogHandles.SQSEditorTabGroup, 'title','Aperture Data');
                componentParameterInputDialogHandles.SQSTiltDecenterDataTab = ...
                    uitab(componentParameterInputDialogHandles.SQSEditorTabGroup, 'title','Tilt Decenter Data');
                
                % Initialize the panel and table for standard data
                componentParameterInputDialogHandles.tblSQSStandardData = uitable('Parent',componentParameterInputDialogHandles.SQSStandardDataTab,...
                    'FontSize',fontSize,'FontName', fontName,'units','normalized','Position',[0 0 1 1]);
                % Initialize the panel and table for standard data
                % depends on the surface type
                % Set the Column Names of the Standard data table
                firstSurfaceType = currentComponent.Parameters.SurfaceArray(1).Type;
                setSQSStandardDataTableColumnNames(componentParameterInputDialogHandles,aodHandles,firstSurfaceType);
                
                % Initialize the panel and table for aperture data
                componentParameterInputDialogHandles.tblSQSApertureData = ...
                    uitable('Parent',componentParameterInputDialogHandles.SQSApertureDataTab,'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized','Position',[0 0 1 1]);
                
                % Initialize the panel and table for aperture data
                columnName2 =   ...
                    {'Surface', 'Surface Type', 'Aperture Type', '', 'Aper Param1', '',...
                    'Aper Param2', '', 'Aper Decent X', '', 'Aper Decent Y', '',...
                    'Clear Aperture','Additional Edge','Draw Fixed'};
                columnWidth2 = ...
                    {80, 120, 100, 15, 90, 15, 90, 15, 90, 15, 90, 15, 90, 90,80};
                columnEditable2 =  ...
                    [false false true false true false true false true false true false,true,true,true];
                apertureTypes = Surface.SupportedApertureTypes();
                set(componentParameterInputDialogHandles.tblSQSApertureData , 'ColumnFormat', ...
                    {'char', 'char', apertureTypes,...
                    'char', 'numeric', 'char','numeric', 'char', 'numeric', 'char', 'numeric', 'char',...
                    'numeric', 'numeric','logical'});
                set(componentParameterInputDialogHandles.tblSQSApertureData,'ColumnEditable', columnEditable2,...
                    'ColumnName', columnName2,'ColumnWidth',columnWidth2);
                
                
                % Initialize the panel and table for tilt decenter data
                componentParameterInputDialogHandles.tblSQSTiltDecenterData = ...
                    uitable('Parent',componentParameterInputDialogHandles.SQSTiltDecenterDataTab,'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized','Position',[0 0 1 1]);
                % Tilt and Decenter order = index of [dx,dy,tx,ty,tz]
                columnName5 =   ...
                    {'  Surface  ', 'Surface Type', '    Order    ', '', ...
                    'Decenter X', '', 'Decenter Y', '', 'Tilt X', '',...
                    'Tilt Y', '', 'Tilt Z', '', 'Tilt Mode', ''};
                columnWidth5 =   {80, 120, 120, 15, 80, 15, 80, 15, 80, 15,...
                    80,15, 80, 15, 80, 15};
                columnEditable5 =  ...
                    [false false true false true false true false true false ...
                    true false true false false false];
                tiltModes = Surface.SupportedTiltModes();
                set(componentParameterInputDialogHandles.tblSQSTiltDecenterData , 'ColumnFormat', {'char', 'char', 'char','char', 'numeric',...
                    'char','numeric', 'char', 'numeric', 'char', 'numeric', 'char', 'numeric', 'char', ...
                    tiltModes,'char'});
                set(componentParameterInputDialogHandles.tblSQSTiltDecenterData,'ColumnEditable', ...
                    columnEditable5,'ColumnName', columnName5,'ColumnWidth',columnWidth5);
                
                
                % Set all celledit and cellselection callbacks
                set(componentParameterInputDialogHandles.tblSQSStandardData,...
                    'CellEditCallback',{@tblSQSStandardData_CellEditCallback,componentParameterInputDialogHandles,aodHandles},...
                    'CellSelectionCallback',{@tblSQSStandardData_CellSelectionCallback,componentParameterInputDialogHandles,aodHandles});
                
                set(componentParameterInputDialogHandles.tblSQSApertureData,...
                    'CellEditCallback',{@tblSQSApertureData_CellEditCallback,componentParameterInputDialogHandles,aodHandles},...
                    'CellSelectionCallback',{@tblSQSApertureData_CellSelectionCallback,componentParameterInputDialogHandles,aodHandles});
                set(componentParameterInputDialogHandles.tblSQSTiltDecenterData,...
                    'CellEditCallback',{@tblSQSTiltDecenterData_CellEditCallback,componentParameterInputDialogHandles,aodHandles},...
                    'CellSelectionCallback',{@tblSQSTiltDecenterData_CellSelectionCallback,componentParameterInputDialogHandles,aodHandles});
                
                % Command buttons for adding and removing surfaces
                componentParameterInputDialogHandles.btnInsertSurfaceToSQS = uicontrol( ...
                    'Parent',componentParameterInputDialogHandles.panelParameter,...
                    'Style', 'pushbutton', ...
                    'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized',...
                    'Position',[0.0,0.91,0.1,0.1],...
                    'String','Insert',...
                    'Callback',{@btnInsertSurfaceToSQS_Callback,componentParameterInputDialogHandles,parentWindow});
                componentParameterInputDialogHandles.btnRemoveSurfaceFromSQS = uicontrol( ...
                    'Parent',componentParameterInputDialogHandles.panelParameter,...
                    'Style', 'pushbutton', ...
                    'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized',...
                    'Position',[0.1,0.91,0.1,0.1],...
                    'String','Remove',...
                    'Callback',{@btnRemoveSurfaceFromSQS_Callback,componentParameterInputDialogHandles,parentWindow});
                componentParameterInputDialogHandles.btnStopSurfaceOfSQS = uicontrol( ...
                    'Parent',componentParameterInputDialogHandles.panelParameter,...
                    'Style', 'pushbutton', ...
                    'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized',...
                    'Position',[0.2,0.91,0.1,0.1],...
                    'String','Make Stop',...
                    'Callback',{@btnStopSurfaceOfSQS_Callback,componentParameterInputDialogHandles,parentWindow});

                % open the currentSurface array in the tables
                % Fill the surface parameters to the GUI
                surfaceArray = currentComponent.Parameters.SurfaceArray;
                nSurface = length(surfaceArray);
                % initializ
                savedStandardData = cell(nSurface,20);
                savedApertureData = cell(1,15);
                savedTiltDecenterData = cell(1,16);
                
                for kk = 1:1:nSurface
                    %standard data
                    if surfaceArray(kk).Stop
                        savedStandardData{kk,1} = 'STOP';
                        
                    else
                        savedStandardData{kk,1} = 'Surf';
                    end
                    
                    
                    savedStandardData{kk,2} = char(surfaceArray(kk).Comment);
                    savedStandardData{kk,3} = char(surfaceArray(kk).Type);
                    savedStandardData{kk,4} = '';
                    savedStandardData{kk,5} = (surfaceArray(kk).Thickness);
                    savedStandardData{kk,6} = '';
                    
                    switch char(surfaceArray(kk).Glass.Name)
                        case 'None'
                            glassDisplayName = '';
                        case 'FixedIndexGlass'
                            glassDisplayName = ...
                                [num2str(surfaceArray(kk).Glass.GlassParameters(1),'%.4f '),',',...
                                num2str(surfaceArray(kk).Glass.GlassParameters(2),'%.4f '),',',...
                                num2str(surfaceArray(kk).Glass.GlassParameters(3),'%.4f ')];
                        otherwise
                            glassDisplayName = upper(char(surfaceArray(kk).Glass.Name));
                    end
                    savedStandardData{kk,7} = glassDisplayName;
                    savedStandardData{kk,8} = '';
                    
                    savedStandardData{kk,9} = upper(num2str(surfaceArray(kk).Coating.Name));
                    savedStandardData{kk,10} = '';
                    
                    % Other surface type specific standard data
                    [fieldNames,fieldFormat,initialData] = surfaceArray(kk).getOtherStandardDataFields;
                    try
                        for ff = 1:10
                            savedStandardData{kk,10 + ff} = (surfaceArray(kk).OtherStandardData.(fieldNames{ff}));
                        end
                    catch
                        for ff = 1:10
                            savedStandardData{kk,10 + ff} = initialData{ff};
                        end
                    end
                    
                    % aperture data
                    if kk == 1
                        savedApertureData{kk,1} = savedStandardData{kk,1};
                        savedApertureData{kk,2} = savedStandardData{kk,3};
                        savedApertureData{kk,3} = char(surfaceArray(kk).ApertureType);
                        savedApertureData{kk,4} = '';
                        savedApertureData{kk,5} = (surfaceArray(kk).ApertureParameter(1));
                        savedApertureData{kk,6} = '';
                        savedApertureData{kk,7} = (surfaceArray(kk).ApertureParameter(2));
                        savedApertureData{kk,8} = '';
                        savedApertureData{kk,9} = (surfaceArray(kk).ApertureParameter(3));
                        savedApertureData{kk,10} = '';
                        savedApertureData{kk,11} = (surfaceArray(kk).ApertureParameter(4));
                        savedApertureData{kk,12} = '';
                        
                        savedApertureData{kk,13} = (surfaceArray(kk).ClearAperture);
                        savedApertureData{kk,14} = (surfaceArray(kk).AdditionalEdge);
                        savedApertureData{kk,15} = logical(surfaceArray(kk).AbsoluteAperture);
                    end
                    
                    %tilt decenter data
                    if kk == 1
                        savedTiltDecenterData{kk,1} = savedStandardData{kk,1};
                        savedTiltDecenterData{kk,2} = savedStandardData{kk,3};
                        % Validate Data
                        order = char(surfaceArray(kk).TiltDecenterOrder);
                        if isValidGeneralInput(order,'TiltDecenterOrder')
                            savedTiltDecenterData{kk,3} = order;
                        else
                            % set default
                            savedTiltDecenterData{kk,3} = 'DxDyDzTxTyTz';
                        end
                        savedTiltDecenterData{kk,4} = '';
                        savedTiltDecenterData{kk,5} = (surfaceArray(kk).DecenterParameter(1));
                        savedTiltDecenterData{kk,6} = '';
                        savedTiltDecenterData{kk,7} = (surfaceArray(kk).DecenterParameter(2));
                        savedTiltDecenterData{kk,8} = '';
                        savedTiltDecenterData{kk,9} = (surfaceArray(kk).TiltParameter(1));
                        savedTiltDecenterData{kk,10} = '';
                        savedTiltDecenterData{kk,11} = (surfaceArray(kk).TiltParameter(2));
                        savedTiltDecenterData{kk,12} = '';
                        savedTiltDecenterData{kk,13} = (surfaceArray(kk).TiltParameter(3));
                        savedTiltDecenterData{kk,14} = '';
                        savedTiltDecenterData{kk,15} = char(surfaceArray(kk).TiltMode);
                        savedTiltDecenterData{kk,16} = '';
                    end
                end
                sysTable1 = componentParameterInputDialogHandles.tblSQSStandardData;
                set(sysTable1, 'Data', savedStandardData);
                
                sysTable2 = componentParameterInputDialogHandles.tblSQSApertureData;
                set(sysTable2, 'Data', savedApertureData);
                
                sysTable5 = componentParameterInputDialogHandles.tblSQSTiltDecenterData;
                set(sysTable5, 'Data', savedTiltDecenterData);
                
                
                set(componentParameterInputDialogHandles.FigureHandle,'Position', [0.1, 0.3, 0.8, 0.4]);
                set(componentParameterInputDialogHandles.btnOk,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.01 0.02 0.1 0.1]);
                set(componentParameterInputDialogHandles.btnCancel,'Parent', componentParameterInputDialogHandles.panelParameter, ...
                    'Units', 'Normalized', ...
                    'Position', [0.12 0.02 0.1 0.1]);
        end
        end
        set(componentParameterInputDialogHandles.btnOk,...
            'Callback', {@btnOk_Callback,componentParameterInputDialogHandles,parentWindow,componentIndex, parameterIndex});
        set(componentParameterInputDialogHandles.btnCancel,...
            'Callback', {@btnCancel_Callback,componentParameterInputDialogHandles,parentWindow,componentIndex, parameterIndex});
        set(componentParameterInputDialogHandles.FigureHandle,'Visible','on');
    end


% CellEditCallback
% --- Executes when entered data in editable cell(s) in aodHandles.tblSQSStandardData.
    function tblSQSStandardData_CellEditCallback(~, eventdata,compParamInputHandles,aodHandles)
        % hObject    handle to aodHandles.tblSQSStandardData (see GCBO)
        % eventdata  structure with the following fields (see UITABLE)
        %	Indices: row and column indices of the cell(s) edited
        %	PreviousData: previous data for the cell(s) edited
        %	EditData: string(s) entered by the user
        %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
        %	Error: error string when failed to convert EditData to appropriate value for Data
        % aodHandles    structure with aodHandles and user data (see GUIDATA)
        
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(aodHandles)
            return
        end

        if eventdata.Indices(2) == 3 && ~(strcmpi(eventdata.NewData,''))
            %if surface type is changed update all tables in the editor
            tblSQSData2 = get(compParamInputHandles.tblSQSApertureData,'data');
            tblSQSData2{eventdata.Indices(1),eventdata.Indices(2)-1} = eventdata.NewData;
            set(compParamInputHandles.tblSQSApertureData, 'Data', tblSQSData2);
            
            tblSQSData5 = get(compParamInputHandles.tblSQSTiltDecenterData,'data');
            tblSQSData5{eventdata.Indices(1),eventdata.Indices(2)-1} = eventdata.NewData;
            set(compParamInputHandles.tblSQSTiltDecenterData, 'Data', tblSQSData5);
            
            % Set the Column Names of the Standard data table
            surfaceType = eventdata.NewData;
            setSQSStandardDataTableColumnNames(compParamInputHandles,aodHandles,surfaceType);
            
        elseif eventdata.Indices(1) == 1 && eventdata.Indices(2) == 5 % if first thickness is changed
            if isValidGeneralInput() % This returns 1 by default, but in the future
                % input validation code shall be defined
            else
                button = questdlg('Invalid input detected. Do you want to restore previous valid object thickness value?','Restore Object Thickness');
                if strcmpi(button,'Yes')
                    tblSQSData1 = get(compParamInputHandles.tblSQSStandardData,'data');
                    tblSQSData1{eventdata.Indices(1),7} = eventdata.PreviousData;
                    set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData1);
                end
            end
        elseif eventdata.Indices(2) == 7 % if glass is changed
            glassName = eventdata.NewData;
            % Check if the glass name is just Mirror
            if strcmpi(glassName,'Mirror')
                tblSQSData{eventdata.Indices(1),7} = 'MIRROR';
                set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                return;
                % Check if the glass name is just the refractive index of the glass
            elseif ~isnan(str2double(glassName)) % Fixed Index Glass
                tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                ndvdpg = str2num(glassName);
                if length(ndvdpg) == 1
                    nd = ndvdpg(1);
                    vd = 0;
                    pg = 0;
                elseif length(ndvdpg) == 2
                    nd = ndvdpg(1);
                    vd = ndvdpg(2);
                    pg = 0;
                elseif length(ndvdpg) == 3
                    nd = ndvdpg(1);
                    vd = ndvdpg(2);
                    pg = ndvdpg(3);
                else
                end
                tblSQSData{eventdata.Indices(1),7} = [num2str(str2double(nd),'%.4f '),',',...
                    num2str(str2double(vd),'%.4f '),',',...
                    num2str(str2double(pg),'%.4f ')];
                set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                return;
            end
            
            % check for its existance among selected catalogues
            if ~isempty(glassName)
                objectType = 'glass';
                objectName = glassName;
                % Glass Catalogue
                tableData1 = get(aodHandles.tblGlassCatalogues,'data');
                if ~isempty(tableData1)
                    % Take only the selected ones
                    selectedRows1 = find(cell2mat(tableData1(:,1)));
                    if ~isempty(selectedRows1)
                        glassCatalogueListFullNames = tableData1(selectedRows1,3);
                    else
                        glassCatalogueListFullNames = '';
                    end
                else
                    glassCatalogueListFullNames = '';
                end
                objectCatalogueListFullNames = glassCatalogueListFullNames;
                objectIndex = 0;
                for kk = 1:size(objectCatalogueListFullNames,1)
                    objectCatalogueFullName = objectCatalogueListFullNames{kk};
                    [ Object,objectIndex ] = extractObjectFromObjectCatalogue...
                        (objectType,objectName,objectCatalogueFullName );
                    if objectIndex ~= 0
                        break;
                    end
                end
                % if exists capitalize its name else ask for new coating definition
                if objectIndex ~= 0
                    tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                    tblSQSData{eventdata.Indices(1),7} = upper(tblSQSData{eventdata.Indices(1),7});
                    set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                else
                    button = questdlg('The glass is not found in the catalogues. Do you want to add or choose another?','Glass Not Found');
                    switch button
                        case 'Yes'
                            glassEnteryFig = glassDataInputDialog(glassCatalogueListFullNames);
                            set(glassEnteryFig,'WindowStyle','Modal');
                            uiwait(glassEnteryFig);
                            try
                                load('tempglass.mat','glassObj');
                                selectedGlassName = glassObj.Name;
                                delete('tempglass.mat')
                            catch
                                selectedGlassName = '';
                            end
                            tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                            tblSQSData{eventdata.Indices(1),7} = upper(selectedGlassName);
                            set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                        case 'No'
                            % Do nothing
                            disp('Warning: Undefined glass used. It may cause problem in the analysis.');
                        case 'Cancel'
                            tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                            tblSQSData{eventdata.Indices(1),7} = '';
                            set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                    end
                end
            end

        elseif eventdata.Indices(2) == 9 % if coating is changed
            % check for its existance among selected catalogues
            coatName = eventdata.NewData;
            
            objectType = 'coating';
            objectName = coatName;
            % Coating Catalogue
            tableData1 = get(aodHandles.tblCoatingCatalogues,'data');
            if ~isempty(tableData1)
                % Take only the selected ones
                selectedRows1 = find(cell2mat(tableData1(:,1)));
                if ~isempty(selectedRows1)
                    coatingCatalogueListFullNames = tableData1(selectedRows1,3);
                else
                    coatingCatalogueListFullNames = '';
                end
            else
                coatingCatalogueListFullNames = '';
            end
            objectCatalogueListFullNames = coatingCatalogueListFullNames;
            objectIndex = 0;
            for kk = 1:size(objectCatalogueListFullNames,1)
                objectCatalogueFullName = objectCatalogueListFullNames{kk};
                [ Object,objectIndex ] = extractObjectFromObjectCatalogue...
                    (objectType,objectName,objectCatalogueFullName );
                if objectIndex ~= 0
                    break;
                end
            end
            
            % if empty, replace with None. If it exists in the catal capitalize its
            % name else ask for new coating definition
            if isempty(coatName)
                coatName = 'None';
                tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                tblSQSData{eventdata.Indices(1),9} = upper(coatName);
                set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
            elseif objectIndex ~= 0
                tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                tblSQSData{eventdata.Indices(1),9} = upper(tblSQSData{eventdata.Indices(1),15});
                set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
            else
                button = questdlg('The coating is not found in the catalogues. Do you want to add or choose another?','Coating Not Found');
                switch button
                    case 'Yes'
                        coatingEnteryFig = coatingDataInputDialog(coatingCatalogueListFullNames);
                        set(coatingEnteryFig,'WindowStyle','Modal');
                        uiwait(coatingEnteryFig);
                        try
                            load('tempcoating.mat','coatingObj');
                            selectedCoatingName = coatingObj.Name;
                            delete('tempcoating.mat')
                        catch
                            selectedCoatingName = 'None';
                        end
                        tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                        tblSQSData{eventdata.Indices(1),9} = upper(selectedCoatingName);
                        set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                    case 'No'
                        % Do nothing Just leave it
                        disp('Warning: Undefined caoting used. It may cause problem in the analysis.');
                    case 'Cancel'
                        tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
                        tblSQSData{eventdata.Indices(1),9} = 'NONE';
                        set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSData);
                end
            end
        end
        %     end
        parentWindow.AODParentHandles = aodHandles;
    end
% --- Executes when entered data in editable cell(s) in aodHandles.tblSQSApertureData.
    function tblSQSApertureData_CellEditCallback(~, ~,compParamInputHandles,aodHandles)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(parentWindow.AODParentHandles)
            return
        end
    end
% --- Executes when entered data in editable cell(s) in aodHandles.tblSQSTiltDecenterData.
    function tblSQSTiltDecenterData_CellEditCallback(~, eventdata,compParamInputHandles,aodHandles)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(aodHandles)
            return
        end
        if eventdata.Indices(2) == 3  % 3rd row / tiltanddecenter data
            if isempty(eventdata.NewData) || ...
                    ~isValidGeneralInput(eventdata.NewData,'TiltDecenterOrder')
                % restore previous data
                tblSQSData = get(tblSQSTiltDecenterData,'data');
                tblSQSData{eventdata.Indices(1),3} = eventdata.PreviousData;
                set(compParamInputHandles.tblSQSTiltDecenterData, 'Data', tblSQSData);
            else
                % valid input so format the text
                orderStr = upper(eventdata.NewData);
                formatedOrder(1:2:11) = upper(orderStr(1:2:11));
                formatedOrder(2:2:12) = lower(orderStr(2:2:12));
                tblSQSData = get(compParamInputHandles.tblSQSTiltDecenterData,'data');
                tblSQSData{eventdata.Indices(1),3} = formatedOrder;
                set(compParamInputHandles.tblSQSTiltDecenterData, 'Data', tblSQSData);
            end
        end
    end
% --- Executes when selected cell(s) is changed in aodHandles.tblSQSStandardData.
    function tblSQSStandardData_CellSelectionCallback(~, eventdata,compParamInputHandles,aodHandles)
        global SELECTED_CELL_SQS
        global CAN_ADD_SURF_TO_SQS
        global CAN_REMOVE_SURF_FROM_SQS
        aodHandles = parentWindow.AODParentHandles;
        
%         SELECTED_CELL_SQS = cell2mat(struct2cell(eventdata)); %struct to matrix
        SELECTED_CELL_SQS = eventdata.Indices;
        if isempty(SELECTED_CELL_SQS)
            return
        end
        
        tblSQSData = get(compParamInputHandles.tblSQSStandardData,'data');
        % Set the Column Names of the Standard data table
        surfaceType = tblSQSData{SELECTED_CELL_SQS(1),3};
        setSQSStandardDataTableColumnNames(compParamInputHandles,aodHandles,surfaceType);
        
        sizetblSQSData = size(tblSQSData);
        
        if SELECTED_CELL_SQS(2) == 1 && ...
                ~strcmpi(tblSQSData{1,1},'OBJECT')&& ...
                ~strcmpi(tblSQSData{1,1},'IMAGE') % only when the first column selected
            if sizetblSQSData(1) == 1
                CAN_ADD_SURF_TO_SQS = 1;
                CAN_REMOVE_SURF_FROM_SQS = 0;
            else
                CAN_ADD_SURF_TO_SQS = 1;
                CAN_REMOVE_SURF_FROM_SQS = 1;
            end
        end
        parentWindow.AODParentHandles = aodHandles;
    end
% --- Executes when selected cell(s) is changed in aodHandles.tblSQSApertureData.
    function tblSQSApertureData_CellSelectionCallback(~, ~,~)
    end
% --- Executes when selected cell(s) is changed in aodHandles.tblSQSTiltDecenterData.
    function tblSQSTiltDecenterData_CellSelectionCallback(~, ~,~)
    end


%% Button Callbacks
    function btnInsertSurfaceToSQS_Callback(~,~,compParamInputHandles,parentWindow)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(parentWindow.AODParentHandles)
            return
        end
        aodHandles = parentWindow.AODParentHandles;
        InsertNewSurfaceToSQS(compParamInputHandles,aodHandles);
    end
    function btnRemoveSurfaceFromSQS_Callback(~,~,compParamInputHandles,parentWindow)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(parentWindow.AODParentHandles)
            return
        end
        aodHandles = parentWindow.AODParentHandles;
        RemoveThisSurfaceFromSQS(compParamInputHandles,aodHandles);
    end
    function btnStopSurfaceOfSQS_Callback(~,~,compParamInputHandles,parentWindow)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(parentWindow.AODParentHandles)
            return
        end
        aodHandles = parentWindow.AODParentHandles;
        MakeThisStopSurfaceOfSQS (compParamInputHandles,aodHandles)
    end
    function SaveComponentParameter(compParamInputHandles,parentWindow,componentIndex, parameterIndex)
        currentComponent =  aodHandles.OpticalSystem.ComponentArray(componentIndex);
        [ componentParametersTable ] = ...
            getComponentParametersTable(currentComponent);
        paramName = componentParametersTable{parameterIndex,1};
        paramType = componentParametersTable{parameterIndex,3};
        if strcmpi(class(paramType),'cell')
                % type is choice of popmenu
                allParam = get(compParamInputHandles.popParameterValue,'String');
                selectedCharParam = allParam{get(compParamInputHandles.popParameterValue,'Value'),:};
                currentComponent.Parameters.(paramName) = selectedCharParam;
        else
        switch lower(paramType)
            case {lower('char')}
                charParam = get(compParamInputHandles.txtParameterValue,'String');
                currentComponent.Parameters.(paramName) = charParam;
            case lower('numeric')
                numericParam = str2num(get(compParamInputHandles.txtParameterValue,'String'));
                currentComponent.Parameters.(paramName) = numericParam;
            case lower('logical')
                logicalParam = get(compParamInputHandles.chkParameterValue,'value');
                currentComponent.Parameters.(paramName) = logicalParam;
            case lower('SQS')
                [SQSParam,nSurfaces] = SaveSquenceOfSurfaces(compParamInputHandles,parentWindow);               
                currentComponent.Parameters.(paramName) = SQSParam;                
            otherwise

        end
        end
        
        aodHandles.OpticalSystem.ComponentArray(componentIndex) = currentComponent;
        
        % Display component parmeters in the main window
        [ compParamTable,compParamTableDisplay ] = getComponentParametersTable(currentComponent);
        set(aodHandles.tblComponentParameters,'Data', compParamTableDisplay);
        
        parentWindow.AODParentHandles = aodHandles;
    end
    function [surfaceArray,nSurfaces] = SaveSquenceOfSurfaces(compParamInputHandles,parentWindow)
        aodHandles = parentWindow.AODParentHandles;
        if ~checkTheCurrentSystemDefinitionType(aodHandles)
            return
        end
        %Surface Data
        tempStandardData = get(compParamInputHandles.tblSQSStandardData,'data');
        tempApertureData = get(compParamInputHandles.tblSQSApertureData,'data');
        tempTiltDecenterData = get(compParamInputHandles.tblSQSTiltDecenterData,'data');
        
        nSurfaces = size(tempStandardData,1);
        tempSurfaceArray(1,nSurfaces) = Surface;
        NonDummySurface = ones(1,nSurfaces);
        
        for k = 1:1:nSurfaces
            %standard data
            surface = tempStandardData{k,1};
            if strcmpi((surface),'OBJECT')
                tempSurfaceArray(k).ObjectSurface = 1;
            elseif strcmpi((surface),'IMAGE')
                tempSurfaceArray(k).ImageSurface = 1;
            elseif strcmpi((surface),'STOP')
                % First remove stop from all other surfaces and prisms
                componentArray = aodHandles.OpticalSystem.ComponentArray;
                nComponent = size(componentArray,2);
                for tt = 1:nComponent
                    if strcmpi(componentArray(tt).Type,'Prism')
                        componentArray(tt).Parameters.MakePrismStop = false;
                    end
                    for kk = 1:length(componentArray(tt).getSurfaceArray)
                        componentArray(tt).Parameters.tempSurfaceArray(kk).Stop = 0;
                    end
                end
                aodHandles.OpticalSystem.ComponentArray = componentArray ;
                tempSurfaceArray(k).Stop = 1;
                stopIndex = k;
            else
                tempSurfaceArray(k).Stop = 0;
                tempSurfaceArray(k).ImageSurface = 0;
                tempSurfaceArray(k).ObjectSurface = 0;
            end
            tempSurfaceArray(k).Comment       = char(tempStandardData(k,2));%text
            tempSurfaceArray(k).Type          = char(tempStandardData(k,3));%text
            
            
            if strcmpi(tempSurfaceArray(k).Type,'Dummy')
                NonDummySurface(k) = 0;
            end
            tempSurfaceArray(k).Thickness     = tempStandardData{k,5};
            
            % get glass name and then SellmeierCoefficients from file
            glassName = strtrim(char(tempStandardData(k,7)));% text
            if strcmpi(glassName,'Mirror')
                % Just take the glass of the non dummy surface before the mirror
                % but with the new name "MIRROR"
                for pp = k-1:-1:1
                    if NonDummySurface(pp)
                        prevNonDummySurface = pp;
                        break;
                    end
                end
                Object = tempSurfaceArray(prevNonDummySurface).Glass;
                Object.Name = 'MIRROR';
                tempSurfaceArray(k).Glass = Object;
            elseif ~isempty(glassName)
                % check for its existance and extract the glass among selected catalogues
                objectType = 'glass';
                objectName = glassName;
                if isempty(str2num(glassName)) % If the glass name is specified
                    % Glass Catalogue
                    tableData1 = get(aodHandles.tblGlassCatalogues,'data');
                    if ~isempty(tableData1)
                        % Take only the selected ones
                        selectedRows1 = find(cell2mat(tableData1(:,1)));
                        if ~isempty(selectedRows1)
                            glassCatalogueListFullNames = tableData1(selectedRows1,3);
                        else
                            glassCatalogueListFullNames = '';
                        end
                    else
                        glassCatalogueListFullNames = '';
                    end
                    objectCatalogueListFullNames = glassCatalogueListFullNames;
                    objectIndex = 0;
                    for pp = 1:size(objectCatalogueListFullNames,1)
                        objectCatalogueFullName = objectCatalogueListFullNames{pp};
                        [ Object,objectIndex ] = extractObjectFromObjectCatalogue...
                            (objectType,objectName,objectCatalogueFullName );
                        if objectIndex ~= 0
                            break;
                        end
                    end
                    
                    if  objectIndex ~= 0
                        tempSurfaceArray(k).Glass = Object;
                    else
                        disp(['Error: The glass after surface ',num2str(k),' is not found so it is ignored.']);
                        tempSurfaceArray(k).Glass = Glass;
                    end
                else
                    % Fixed Index Glass
                    % str2num can be used to convert array of strings to number.
                    ndvdpg = str2num(glassName);
                    if length(ndvdpg) == 1
                        nd = ndvdpg(1);
                        vd = 0;
                        pd = 0;
                    elseif length(ndvdpg) == 2
                        nd = ndvdpg(1);
                        vd = ndvdpg(2);
                        pd = 0;
                    elseif length(ndvdpg) == 3
                        nd = ndvdpg(1);
                        vd = ndvdpg(2);
                        pd = ndvdpg(3);
                    else
                    end
                    glassName = [num2str(str2double(nd),'%.4f '),',',...
                        num2str(str2double(vd),'%.4f '),',',...
                        num2str(str2double(pd),'%.4f ')];
                    Object = Glass(glassName,'FixedIndex',[nd,vd,pd,0,0,0,0,0,0,0]');
                    tempSurfaceArray(k).Glass = Object;
                end
            else
                tempSurfaceArray(k).Glass = Glass;
            end
            
            % coating data
            coatName = (char(tempStandardData(k,9)));
            if ~isempty(coatName)
                % check for its existance and extract the coating among selected catalogues
                objectType = 'coating';
                objectName = coatName;
                % Coating Catalogue
                tableData1 = get(aodHandles.tblCoatingCatalogues,'data');
                if ~isempty(tableData1)
                    % Take only the selected ones
                    selectedRows1 = find(cell2mat(tableData1(:,1)));
                    if ~isempty(selectedRows1)
                        coatingCatalogueListFullNames = tableData1(selectedRows1,3);
                    else
                        coatingCatalogueListFullNames = '';
                    end
                else
                    coatingCatalogueListFullNames = '';
                end
                objectCatalogueListFullNames = coatingCatalogueListFullNames;
                objectIndex = 0;
                for pp = 1:size(objectCatalogueListFullNames,1)
                    objectCatalogueFullName = objectCatalogueListFullNames{pp};
                    [ Object,objectIndex ] = extractObjectFromObjectCatalogue...
                        (objectType,objectName,objectCatalogueFullName );
                    if objectIndex ~= 0
                        break;
                    end
                end
                
                if  objectIndex ~= 0
                    tempSurfaceArray(k).Coating = Object;
                else
                    disp(['Error: The coating of surface ',num2str(k),' is not found so it is ignored.']);
                    tempSurfaceArray(k).Coating = Coating;
                end
            else
                tempSurfaceArray(k).Coating = Coating;
            end
            
            % Other surface type specific standard data
            [fieldNames,fieldFormat,initialData] = tempSurfaceArray(k).getOtherStandardDataFields;
            tempSurfaceArray(k).OtherStandardData = struct;
            for ff = 1:10
                tempSurfaceArray(k).OtherStandardData.(fieldNames{ff}) = ...
                    (tempStandardData{k,ff+10});
            end
            
            % aperture data  taken from the first surrface
            tempSurfaceArray(k).ApertureType      = char(tempApertureData(1,3));
            tempSurfaceArray(k).ApertureParameter = ...
                [tempApertureData{1,5},tempApertureData{1,7},...
                tempApertureData{1,9},tempApertureData{1,11}];
            
            tempSurfaceArray(k).ClearAperture = tempApertureData{1,13};
            tempSurfaceArray(k).AdditionalEdge = tempApertureData{1,14};
            tempSurfaceArray(k).AbsoluteAperture = boolean(tempApertureData{1,15});
            
            
            % tilt decenter data taken from the first surrface
            if k == 1
                tempSurfaceArray(k).TiltDecenterOrder = char(tempTiltDecenterData(1,3));
                tempSurfaceArray(k).DecenterParameter = ...
                    [tempTiltDecenterData{1,5},tempTiltDecenterData{1,7}];
                tempSurfaceArray(k).TiltParameter     = ...
                    [tempTiltDecenterData{1,9},tempTiltDecenterData{k,11},tempTiltDecenterData{1,13}];
                tempSurfaceArray(k).TiltMode          = 'NAX';
            else
                tempSurfaceArray(k).TiltDecenterOrder = char(tempTiltDecenterData(1,3));
                tempSurfaceArray(k).DecenterParameter = ...
                    [0,0];
                tempSurfaceArray(k).TiltParameter     = ...
                    [0,0,0];
                tempSurfaceArray(k).TiltMode          = 'DAR';
            end
            
            
            % compute position from decenter and thickness
            if k == 1 %strcmpi((surface),'OBJECT') % Object surface
                objThickness = abs(tempSurfaceArray(k).Thickness);
                if objThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for graphing
                    objThickness = 0;
                end
                % since global coord but shifted by objThickness
                refCoordinateTM = [1,0,0,0;0,1,0,0;0,0,1,-objThickness;0,0,0,1];
                
                surfaceCoordinateTM = refCoordinateTM;
                referenceCoordinateTM = refCoordinateTM;
                % set surface property
                tempSurfaceArray(k).SurfaceCoordinateTM = ...
                    surfaceCoordinateTM;
                tempSurfaceArray(k).ReferenceCoordinateTM = ...
                    referenceCoordinateTM;
            else
                prevRefCoordinateTM = referenceCoordinateTM;
                prevSurfCoordinateTM = surfaceCoordinateTM;
                prevThickness = tempSurfaceArray(k-1).Thickness;
                if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                    prevThickness = 0;
                end
                [surfaceCoordinateTM,referenceCoordinateTM] = ...
                    tempSurfaceArray(k).TiltAndDecenter(prevRefCoordinateTM,...
                    prevSurfCoordinateTM,prevThickness);
                % set surface property
                tempSurfaceArray(k).SurfaceCoordinateTM = surfaceCoordinateTM;
                tempSurfaceArray(k).ReferenceCoordinateTM = referenceCoordinateTM;
                
            end
            tempSurfaceArray(k).Position = (surfaceCoordinateTM (1:3,4))';
        end
        
        
        surfaceArray = tempSurfaceArray;
     end

    function btnOk_Callback(~,~,compParamInputHandles,parentWindow,componentIndex, parameterIndex)
        aodHandles = parentWindow.AODParentHandles;
        figHandle = compParamInputHandles.FigureHandle;
        SaveComponentParameter(compParamInputHandles,parentWindow,componentIndex, parameterIndex);
        delete(figHandle);        
    end
    function btnCancel_Callback(~,~,compParamInputHandles,parentWindow,componentIndex, parameterIndex)
        aodHandles = parentWindow.AODParentHandles;
        figHandle = compParamInputHandles.FigureHandle;
        
        currentComponent =  aodHandles.OpticalSystem.ComponentArray(componentIndex);
        [ componentParametersTable ] = ...
            getComponentParametersTable(currentComponent);
        paramName = componentParametersTable{parameterIndex,1};
        paramValueOld = componentParametersTable{parameterIndex,2};
        
        aodHandles.OpticalSystem.ComponentArray(componentIndex).Parameters.(paramName) = paramValueOld;
        delete(figHandle);
    end

%% Local Function
    function RemoveThisSurfaceFromSQS(compParamInputHandles,aodHandles)
        global SELECTED_CELL_SQS
        global CAN_REMOVE_SURF_FROM_SQS
        
        if isempty(SELECTED_CELL_SQS)
            return
        end
        
        if CAN_REMOVE_SURF_FROM_SQS
            removePosition = SELECTED_CELL_SQS(1);
            
            %update standard data table
            tblData1 = get(compParamInputHandles.tblSQSStandardData,'data');
            sizeTblData1 = size(tblData1);
            parta1 = tblData1(1:removePosition-1,:);
            partb1 = tblData1(removePosition+1:sizeTblData1 ,:);
            newTable1 = [parta1; partb1];
            sysTable1 = compParamInputHandles.tblSQSStandardData;
            set(sysTable1, 'Data', newTable1);
            %         set(sysTable6, 'Data', newTable6);
        end
        CAN_REMOVE_SURF_FROM_SQS = 0;
        SELECTED_CELL_SQS = [];
    end
    function InsertNewSurfaceToSQS(compParamInputHandles,aodHandles)
        global SELECTED_CELL_SQS
        global CAN_ADD_SURF_TO_SQS
        
        if isempty(SELECTED_CELL_SQS)
            return
        end
        if CAN_ADD_SURF_TO_SQS
            insertPosition = SELECTED_CELL_SQS(1);
            %update standard data table
            tblData1 = get(compParamInputHandles.tblSQSStandardData,'data');
            sizeTblData1 = size(tblData1);
            parta1 = tblData1(1:insertPosition-1,:);
            newRow1 = {'Surf','','Standard','',[0],'','','','NONE','',[Inf],[0],[0],[0],[0],[0],[0],[0],[0],[0]};
            partb1 = tblData1(insertPosition:sizeTblData1 ,:);
            newTable1 = [parta1; newRow1; partb1];
            sysTable1 = compParamInputHandles.tblSQSStandardData;
            set(sysTable1, 'Data', newTable1);
            
            
            % If possible add here a code to select the first cell of newly added row
            % automatically
        end
        CAN_ADD_SURF_TO_SQS = 0;
        SELECTED_CELL_SQS = [];
    end
    function MakeThisStopSurfaceOfSQS (compParamInputHandles,aodHandles)
        global SELECTED_CELL_SQS
        if isempty(SELECTED_CELL_SQS)
            return
        end
        surfIndex = SELECTED_CELL_SQS(1);
        tblSQSTempData1 = get(compParamInputHandles.tblSQSStandardData,'data');
        if ~strcmpi(tblSQSTempData1{surfIndex,1},'OBJECT') &&...
                ~strcmpi(tblSQSTempData1{surfIndex,1},'IMAGE')&...
                ~strcmpi(tblSQSTempData1{surfIndex,1},'STOP')
            tblSQSTempData2 = get(compParamInputHandles.tblSQSApertureData,'data');
            tblSQSTempData5 = get(compParamInputHandles.tblSQSTiltDecenterData,'data');
            for kk = 1:size(tblSQSTempData1,1)
                if kk == surfIndex
                    surfTag = 'STOP';
                else
                    surfTag = 'Surf';
                end
                tblSQSTempData1{kk,1} = surfTag;
                set(compParamInputHandles.tblSQSStandardData, 'Data', tblSQSTempData1);
                
                if kk == 1 % for the fist surface
                    tblSQSTempData2{kk,1} = surfTag;
                    set(compParamInputHandles.tblSQSApertureData, 'Data', tblSQSTempData2);
                    
                    tblSQSTempData5{kk,1} = surfTag;
                    set(compParamInputHandles.tblSQSTiltDecenterData, 'Data', tblSQSTempData5);
                end
            end
        end
    end
    function setSQSStandardDataTableColumnNames (compParamInputHandles,aodHandles,surfaceType)
        % Initialize the panel and table for standard data
        surfDefinition = surfaceType;
        surfaceDefinitionHandle = str2func(surfDefinition);
        returnFlag = 'SSPB';
        [fieldNames,fieldFormat,initialData] = surfaceDefinitionHandle(returnFlag);
        nColumns = size(fieldNames,2);
        columnNames = fieldNames;
        columnWidth = num2cell(100*ones(1,nColumns));
        columnEditable = num2cell(ones(1,nColumns));
        columnFormat = fieldFormat;
        
        hGetSupportedSurfaces = str2func('GetSupportedSurfaces');
        supportedSurfaces = hGetSupportedSurfaces();
        
        
        columnName1 =   {'Surface', 'Name/Note', 'Surface Type', '',...
            'Thickness', '', 'Glass', '','Coating', '',columnNames{:}};
        columnWidth1 = {80, 100, 120, 15, 80, 15, 80, 15, 80, 15,columnWidth{:}};
        columnEditable1 =  [false true true false true false true false true ...
            false columnEditable{:}];
        set(compParamInputHandles.tblSQSStandardData, 'ColumnFormat', ...
            {'char', 'char',{supportedSurfaces{:}},'char','numeric', 'char','char', 'char',...
            'char', 'char', columnFormat{:}});
        set(compParamInputHandles.tblSQSStandardData,'ColumnEditable', logical(columnEditable1),...
            'ColumnName', columnName1,'ColumnWidth',columnWidth1);
        
    end
    function ret = checkTheCurrentSystemDefinitionType(aodHandles)
        if get(aodHandles.popSystemDefinitionType,'Value') == 2
            ret = 1;
        else
            choice = questdlg(['Your system is not defined using Component',...
                ' Based method. Editing in the component editor',...
                ' window automatically converts your system to Component',...
                ' Based definition. Do you want to continue editing?'], ...
                'Change System Definition Type', ...
                'Yes','No','No');
            % Handle response
            switch choice
                case 'Yes'
                    set(aodHandles.popSystemDefinitionType,'Value', 2);
                    ret = 1;
                case 'No'
                    ret = 0;
                    return;
            end
        end
    end
end

