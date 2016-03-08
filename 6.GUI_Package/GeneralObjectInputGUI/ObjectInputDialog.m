function [ updatedObject, updatedHandleArray] = ObjectInputDialog(currentHandleArray,parentHandle)
    %ObjectInputDialog Dialog window used to input the
    %general objects using uitables
   if nargin == 0
        disp('Error: The ObjectInputDialog needs atleast the current object to be updated.');
        updatedObject = NaN;
        updatedHandleArray = NaN;
        return;
    elseif nargin == 1
        parentHandle = NaN;
        fontSize = 10;
        fontName = 'FixedSize';
    else
        fontSize = get(parentHandle.Data.btnOk,'FontSize');
        fontName = get(parentHandle.Data.btnOk,'FontName');
    end
    
    %
    initialObject = currentHandleArray(end).Data.Value;
    updatedObject = initialObject;
    
    % Define the size of child window based on the parent one
    if  length(currentHandleArray) > 1 
        parentFigurePosition = get(currentHandleArray(end-1).Data.InputGUI,'Position');
        figSizeRed = 0.075;
        figPosition = parentFigurePosition + ...
        [parentFigurePosition(3)*(figSizeRed/2),parentFigurePosition(4)*(figSizeRed/2),...
        -parentFigurePosition(3)*(figSizeRed),-parentFigurePosition(4)*(figSizeRed)];
    else
        figPosition = [0.3, 0.2, 0.4, 0.6];
    end    
    warning('off','all')
 
    currentHandleArray(end).Data.InputGUI = dialog ( ...
        'Tag', 'InputGUI', ...
        'Units', 'normalized', ...
        'Position',figPosition ,...
        'Name', class(initialObject), ...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
        'Resize', 'off','Visible','off',...
        'WindowStyle','normal');%,...
        %'CloseRequestFcn','');
   
    currentHandleArray(end).Data.btnOk = uicontrol( ...
        'Parent', currentHandleArray(end).Data.InputGUI,...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnOk', ...
        'String','OK',...
        'Units', 'Normalized', ...
        'Position', [0.55 0.01 0.2 0.07]);
    currentHandleArray(end).Data.btnCancel = uicontrol( ...
        'Parent', currentHandleArray(end).Data.InputGUI,...
        'Units', 'Normalized', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnCancel', ...
        'String','Cancel', ...
        'Position', [0.77 0.01 0.2 0.07]);
 
        currentHandleArray(end).Data.menuData = uimenu( ...
            'Parent', currentHandleArray(end).Data.InputGUI,...
             'Label','Data','visible', 'off');
        currentHandleArray(end).Data.menuAddInDim = uimenu( ...
            'Parent', currentHandleArray(end).Data.menuData,...
             'Label','Add In');
         currentHandleArray(end).Data.menuRemoveFromDim = uimenu( ...
            'Parent', currentHandleArray(end).Data.menuData,...
             'Label','Remove From');
         for k = 1:3
            currentHandleArray(end).Data.menuAddIn(k) = uimenu( ...
                'Parent', currentHandleArray(end).Data.menuAddInDim,...
                 'Label',['Dim ',num2str(k)]);
             currentHandleArray(end).Data.menuRemoveFrom(k) = uimenu( ...
                'Parent', currentHandleArray(end).Data.menuRemoveFromDim,...
                 'Label',['Dim ',num2str(k)]);             
         end
         currentHandleArray(end).Data.menuImportFromWS = uimenu( ...
            'Parent', currentHandleArray(end).Data.menuData,...
             'Label','Import From WS');
         
 
        
    displayObjectProperty(currentHandleArray,0);
    
    set(currentHandleArray(end).Data.btnOk,...
        'Callback', {@btnOk_Callback,currentHandleArray});
    set(currentHandleArray(end).Data.btnCancel,...
        'Callback', {@btnCancel_Callback,currentHandleArray});
    
    for k = 1:3        
        set(currentHandleArray(end).Data.menuAddIn(k),...
            'Callback', {@menuAdd_Callback,k,currentHandleArray});
        set(currentHandleArray(end).Data.menuRemoveFrom(k),...
            'Callback', {@menuRemove_Callback,k,currentHandleArray});        
    end
    set(currentHandleArray(end).Data.menuImportFromWS,...
            'Callback', {@menuImportFromWS_Callback,currentHandleArray}); 
        
    set(currentHandleArray(end).Data.InputGUI,'Visible','on');
    drawnow;
    
    if ishghandle(currentHandleArray(end).Data.InputGUI)
        % Go into uiwait if the figure handle is still valid.
        % This is mostly the case during regular use.
        uiwait(currentHandleArray(end).Data.InputGUI);
    end
    
    % Check handle validity again since we may be out of uiwait because the
    % figure was deleted.
    if ishghandle(currentHandleArray(end).Data.InputGUI)
        if strcmpi(get(currentHandleArray(end).Data.InputGUI,'UserData'),'OK')
            % Code to save the current object
            saveCurrentProperty(currentHandleArray);
            delete(currentHandleArray(end).Data.InputGUI);
            updatedObject = currentHandleArray(end).Data.Value;
            currentHandleArray(end) = [];
            if length(currentHandleArray) > 0
                displayObjectProperty(currentHandleArray,0);
                updatedHandleArray = currentHandleArray;
            end
        elseif strcmpi(get(currentHandleArray(end).Data.InputGUI,'UserData'),'Cancel')
            delete(currentHandleArray(end).Data.InputGUI);
            currentHandleArray(end) = [];
            if length(currentHandleArray) > 0
                displayObjectProperty(currentHandleArray,0);
                updatedHandleArray = currentHandleArray;
                updatedObject = initialObject;
            end
        end
    else
    end
    
end

function btnOk_Callback(~,~,currentHandleArray)
    set(currentHandleArray(end).Data.InputGUI,'UserData','OK');
    uiresume(currentHandleArray(end).Data.InputGUI);
end
function btnCancel_Callback(~,~,currentHandleArray)
    set(currentHandleArray(end).Data.InputGUI,'UserData','Cancel');
    uiresume(currentHandleArray(end).Data.InputGUI);
end



function menuAdd_Callback(~,~,dimIndex,currentHandleArray)
    % Increase the size of the table in selected dims and intialize to
    % to the 1st value in that dims
    currentObject = currentHandleArray(end).Data.Value;
    if dimIndex == 1
        currentObject(end+1,:,:) = currentObject(1,:,:) ;
    elseif dimIndex == 2
        currentObject(:,end+1,:) = currentObject(:,1,:) ;
    elseif dimIndex == 3
        currentObject(:,:,end+1) = currentObject(:,:,1) ;
    end
    currentHandleArray(end).Data.Value = currentObject;
    displayObjectProperty(currentHandleArray,0);
end
function menuRemove_Callback(~,~,dimIndex,currentHandleArray)
    % Remove the last element in the given direction#
    currentObject = currentHandleArray(end).Data.Value;
    if dimIndex == 1 && size(currentObject,1) > 1
        currentObject(end,:,:) = [] ;
    elseif dimIndex == 2 && size(currentObject,2) > 1
        currentObject(:,end,:) =  [] ;
    elseif dimIndex == 3 && size(currentObject,3) > 1
        currentObject(:,:,end) =  [] ;
    end
    currentHandleArray(end).Data.Value = currentObject;
    displayObjectProperty(currentHandleArray,0);
end

function menuImportFromWS_Callback(~,~,currentHandleArray)
    % Import varibales from workspace
    
    %First import .mat file
        [FileName,PathName] = uigetfile('*.mat','Select MAT File');
        if isempty(FileName)||isempty(PathName) || ...
                isnumeric(FileName) || isnumeric(PathName)
               return;
        end
    % then load available data
    S = load([PathName,FileName]);
    varNames =  fieldnames(S);
    str = '';
    myValue = currentHandleArray(end).Data.Value;
    myType = getObjectTypeValueDisplay(myValue);
    for k = 1:length(varNames)
        tempValue = S.(varNames{k}); 
        tempType = getObjectTypeValueDisplay(tempValue);       
        if strcmpi(tempType,myType)
            str{end+1} = varNames{k};
        end
    end
    if isempty(str)
       h = msgbox(strcat('No ', myType, ' varibales are found in the workspace'),'Data not Found');
     return;
    else
    [selectedIndex,ok] = listdlg('PromptString','Select a Workspace Variable',...
        'SelectionMode','single','ListString',str,'InitialValue',[1]);
    end
    wsData = S.(varNames{selectedIndex}); 
    currentHandleArray(end).Data.Value = wsData;
    displayObjectProperty(currentHandleArray,0);
end


function newProperty = saveCurrentProperty(currentHandleArray)
    initialProperty = currentHandleArray(end).Data.Value;
    % fill the uitable with initial object
    if isnumeric(initialProperty) || iscell(initialProperty)  || ischar(initialProperty)
        % save the current table values
        dim3 = length(currentHandleArray(end).Data.tblProperties);
        for k = 1:dim3
            tempData = (get( currentHandleArray(end).Data.tblProperties(k),'data'));
            if isnumeric (tempData{1,1})
                newProperty(:,:,k) = cell2mat(tempData);
            elseif ischar (tempData{1,1})
                newProperty = tempData{:};
            else
                newProperty(:,:,k) = tempData(:,:);
            end
        end
    else
        % each field has been saved iddividually
        newProperty =  initialProperty ;
    end
    currentHandleArray(end).Data.Value = newProperty;
    if length(currentHandleArray) > 1
        if currentHandleArray(end-1).Data.FixedSize
            propertyName = currentHandleArray(end).Data.Name;
            currentHandleArray(end-1).Data.Value.(propertyName) = newProperty;
        else
            propertyIndices = num2cell(currentHandleArray(end).Data.Indices);
            currentHandleArray(end-1).Data.Value(propertyIndices{:}) = newProperty;
        end
    end
end
function displayObjectProperty(currentHandleArray,offsetFromLast)
    % fill the uitable with initial object
    fontName = get(currentHandleArray(end+offsetFromLast).Data.btnOk,'FontName');
    fontSize = get(currentHandleArray(end+offsetFromLast).Data.btnOk,'FontSize');
    
    currentHandleArray(end+offsetFromLast).Data.TabGroup = uitabgroup(...
        'Parent', currentHandleArray(end+offsetFromLast).Data.InputGUI, ...
        'Units', 'Normalized', ...
        'Position', [0 0.1 1 0.9]);
    
    [ objectDisplayTable,fieldsExist ] = getObjectDisplayTable(currentHandleArray(end+offsetFromLast));
    if fieldsExist
        if (currentHandleArray(end+offsetFromLast).Data.FixedSize)
            % If the object has fixed size in all dimensions then just
            % display the fields of the current object
            nFields = size(objectDisplayTable,1);
            tempTableData = cell(nFields,4);
            tempTableData(:,1:3) = objectDisplayTable;
            tempTableData(:,4) = {'Edit'};
            currentHandleArray(end+offsetFromLast).Data.Tab(1) = ...
                uitab('Parent',currentHandleArray(end+offsetFromLast).Data.TabGroup,...
                'title',['Tab ',num2str(1)]);
            
            currentHandleArray(end+offsetFromLast).Data.tblProperties(1) =  uitable(...
                'Parent', currentHandleArray(end+offsetFromLast).Data.Tab(1),...
                'FontSize',fontSize,'FontName', fontName,...
                'units','normalized','Position',[0 0 1 1]);
            set(currentHandleArray(end+offsetFromLast).Data.tblProperties,...
                'data',tempTableData,...
                'ColumnWidth',{180,120,100,80},...
                'ColumnEditable',[false,false,false,false],...
                'ColumnName',{'Property Name','Property Type','Property Value','Edit'});
        else
            % If the object can be extended in one or more dimensions then
            % display Type of the object in ui table and visible buttons for
            % extension
            set(currentHandleArray(end+offsetFromLast).Data.menuData,'visible','On');
%             for k = 1:3
%                 set(currentHandleArray(end+offsetFromLast).Data.btnAdd(k),'visible','On');
%                 set(currentHandleArray(end+offsetFromLast).Data.lblDimension(k),'visible','On');
%                 set(currentHandleArray(end+offsetFromLast).Data.btnRemove(k),'visible','On');                
%             end
            % display the objType in the tblProperties which has size equal
            % to theat of
            [dim1,dim2,dim3] = size(objectDisplayTable);
            for k = 1:dim3
                currentHandleArray(end+offsetFromLast).Data.Tab(k) = ...
                    uitab('Parent',currentHandleArray(end+offsetFromLast).Data.TabGroup,...
                    'title',['Tab ',num2str(k)]);
                
                currentHandleArray(end+offsetFromLast).Data.tblProperties(k) =  uitable(...
                    'Parent', currentHandleArray(end+offsetFromLast).Data.Tab(k),...
                    'FontSize',fontSize,'FontName', fontName,...
                    'units','normalized','Position',[0 0 1 1]);
                tableData = objectDisplayTable(:,:,k);
                set( currentHandleArray(end+offsetFromLast).Data.tblProperties(k),...
                    'data',tableData);
            end
            
        end
    else
        % Datas other than User defined objects and structs are assumed to
        % be not fixed in all three dims
        set(currentHandleArray(end+offsetFromLast).Data.menuData,'visible','On');
%         for k = 1:3
%             set(currentHandleArray(end+offsetFromLast).Data.btnAdd(k),'visible','On');
%             set(currentHandleArray(end+offsetFromLast).Data.lblDimension(k),'visible','On');
%             set(currentHandleArray(end+offsetFromLast).Data.btnRemove(k),'visible','On');
%         end
        
        [dim1,dim2,dim3] = size(objectDisplayTable);
        for k = 1:dim3
            currentHandleArray(end+offsetFromLast).Data.Tab(k) = ...
                uitab('Parent',currentHandleArray(end+offsetFromLast).Data.TabGroup,...
                'title',['Tab ',num2str(k)]);
            
            currentHandleArray(end+offsetFromLast).Data.tblProperties(k) =  uitable(...
                'Parent', currentHandleArray(end+offsetFromLast).Data.Tab(k),...
                'FontSize',fontSize,'FontName', fontName,...
                'units','normalized','Position',[0 0 1 1]);
            tableData = objectDisplayTable(:,:,k);
            set( currentHandleArray(end+offsetFromLast).Data.tblProperties(k),...
                'data',tableData);
        end
    end
    
    set(currentHandleArray(end+offsetFromLast).Data.tblProperties,...
        'CellEditCallback',{@tblProperties_CellEditCallback,currentHandleArray},...
        'CellSelectionCallback',{@tblProperties_CellSelectionCallback,currentHandleArray});
end

% --- Executes when selected cell(s) is changed in aodHandles.tblComponentLis.
function tblProperties_CellSelectionCallback(~, eventdata,currentHandleArray)    
    selectedCellIndex = eventdata.Indices;
    if ~isempty(selectedCellIndex)
        selectedRow = selectedCellIndex(1,1);
        selectedCol = selectedCellIndex(1,2);
    else
        return;
    end
    
    [ objectDisplayTable,fieldsExist ] = getObjectDisplayTable( currentHandleArray(end) );
    if fieldsExist
        % For Objects and Structs of fixed size
        if selectedCol== 4
            % Edit column clicked
            tblData = get(currentHandleArray(end).Data.tblProperties,'data');
            propertyName = tblData{selectedRow,1};
            allProperties = currentHandleArray(end).Data.Value;
            selectedProperty = allProperties.(propertyName);
            
            currentHandleArray(end+1) = MyHandle();
            currentHandleArray(end).Data.Value = selectedProperty;
            currentHandleArray(end).Data.Name = propertyName;
            currentHandleArray(end).Data.FixedSize = 0;
            [newProperty,currentHandleArray] = ObjectInputDialog(currentHandleArray);
        end
    else
        % For non fixed data (numeric, char, Objects and Structs)
        % Additional fields can be added in three dimensions
        initialPropertyArray = currentHandleArray(end).Data.Value;
        if isnumeric(initialPropertyArray) || iscell(initialPropertyArray)
            % just make the table columns editable
            for k = 1:length(currentHandleArray(end).Data.tblProperties)
                set( currentHandleArray(end).Data.tblProperties(k),...
                    'ColumnEditable',[true]);
            end            
        elseif  ischar(initialPropertyArray)
            % just make the table columns editable and increase its width
            for k = 1:length(currentHandleArray(end).Data.tblProperties)
                set( currentHandleArray(end).Data.tblProperties(k),...
                    'ColumnEditable',[true],'ColumnWidth',{400});
            end 
        else
            % For non fixed structs and objects
            allProperties = currentHandleArray(end).Data.Value;
            selectedProperty = allProperties(selectedRow,selectedCol);
            
            currentHandleArray(end+1) = MyHandle();
            currentHandleArray(end).Data.Value = selectedProperty;
            currentHandleArray(end).Data.Indices = [selectedRow,selectedCol];
            currentHandleArray(end).Data.FixedSize = 1;
            [newProperty,currentHandleArray] = ObjectInputDialog(currentHandleArray);
        end
    end
end
% --- Executes when entered data in editable cell(s) in aodHandles.tblComponentLis.
function tblProperties_CellEditCallback(~, eventdata,handles)
    
end
