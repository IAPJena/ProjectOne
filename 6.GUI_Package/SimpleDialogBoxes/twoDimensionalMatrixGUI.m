function [figureHandle] = twoDimensionalMatrixGUI(nameOfTheMatrix,currentMatrixSourceFileName,allowDataManipulation)
    % Lets the user to enter numeric vector data and saves it as appdata by
    % the name StoredMatrix which can be accessed after the dialog box
    % is closed. This is useful for inputing the polynomial coefficients
    % of extended and freeform surfaces.
    
    if nargin < 1
        nameOfTheMatrix = 'Untitled Matrix';
    end
    if nargin < 2
        currentMatrixSourceFileName = 'NoFilename';
    end
    if nargin < 3
        allowDataManipulation = 1;
    end
    
    if exist(currentMatrixSourceFileName,'file')
        [folderPath,fileName,ext] = fileparts(currentMatrixSourceFileName);
        switch lower(ext)
            case {'.mat'}
                load(currentMatrixSourceFileName);
                if exist('StoredMatrix')
                    currentMatrix = StoredMatrix;
                else
                    currentMatrix = zeros(32,32);
                end
            case {'.jpg';'.bmp';'.png'}
                currentMatrix = double(flipud(rgb2gray(imread(currentMatrixSourceFileName))));
            otherwise
                currentMatrix = zeros(32,32);
        end
    else
        currentMatrix = zeros(32,32);
    end
    
    figureTitle = [nameOfTheMatrix,' [',num2str(size(currentMatrix,2)),...
        ':',num2str(size(currentMatrix,1)),']'];
    % Save initial values
    setappdata(0,'StoredMatrix',currentMatrix);
    setappdata(0,'StoredMatrixSourceFileName',currentMatrixSourceFileName);
    
    initialDiagram = currentMatrix;
    initialTabularData = num2cell(currentMatrix);
    
    fontSize = 12;
    fontName = 'FixedWidth';
    
    figureHandle = ObjectHandle(struct());
    figureHandle.Object.FontName = fontName;
    figureHandle.Object.FontSize = fontSize;
    figureHandle.Object.NameOfTheMatrix = nameOfTheMatrix;
    figureHandle.Object.CurrentMatrix = currentMatrix;
    figureHandle.Object.CurrentMatrixSourceFileName = currentMatrixSourceFileName;
    
    figureHandle.Object.MainFigureHandle = figure( ...
        'Tag', 'numericMatrixDataInputGUI', ...
        'Units', 'normalized', ...
        'Position',[0.3,0.25,0.4,0.5],...
        'Name', figureTitle, ...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Color', get(0,'DefaultUicontrolBackgroundColor'));
    set(figureHandle.Object.MainFigureHandle,'WindowStyle','Modal');
    
    figureHandle.Object.mainTabGroup = uitabgroup(...
        'Parent', figureHandle.Object.MainFigureHandle, ...
        'Units', 'Normalized', ...
        'Position', [0 0.1 1 0.9]);
    figureHandle.Object.diagramTab = uitab(figureHandle.Object.mainTabGroup, 'title','Diagram',...
        'BackgroundColor', 'w');
    figureHandle.Object.tabularDataTab = uitab(figureHandle.Object.mainTabGroup, 'title','Tabular');
    figureHandle.Object.resampleTab = uitab(figureHandle.Object.mainTabGroup, 'title','Resample');
    
    figureHandle.Object.axesDiagram = axes('parent',figureHandle.Object.diagramTab,...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Units', 'Normalized',...
        'Position', [0.1 0.1 0.8 0.8]);
    
    figureHandle.Object.tblNumericMatrixData = uitable('Parent',figureHandle.Object.tabularDataTab,...
        'FontSize',fontSize,'FontName', fontName,'Data',initialTabularData,...
        'units','normalized','Position',[0 0 1 1],...
        'CellEditCallback',{@tblNumericMatrixData_CellEditCallback},...
        'CellSelectionCallback',{@tblNumericMatrixData_CellSelectionCallback});
    
    
    figureHandle.Object.lblNumberOfSamplingPoint = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','text',...
        'Tag', 'lblNumberOfSamplingPoint', ...
        'String','Sampling Points (X:Y)',...
        'Units', 'normalized', ...
        'Position',[0.01,0.9,0.3,0.05]);
    
    figureHandle.Object.txtNumberOfSamplingPointInX_old = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'enable', 'off', ...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','edit',...
        'Tag', 'txtNumberOfSamplingPointInX', ...
        'String','64',...
        'Units', 'normalized', ...
        'Position',[0.31,0.9,0.1,0.05]);
    figureHandle.Object.txtNumberOfSamplingPointInY_old = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'enable', 'off', ...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','edit',...
        'Tag', 'txtNumberOfSamplingPointInY', ...
        'String','64',...
        'Units', 'normalized', ...
        'Position',[0.42,0.9,0.1,0.05]);
    
    figureHandle.Object.lblNumberOfSamplingPoints_new = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','text',...
        'Tag', 'lblNumberOfSamplingPoints_new', ...
        'String','New Sampling',...
        'Units', 'normalized', ...
        'Position',[0.54,0.90,0.2,0.05]);
    
    figureHandle.Object.txtNumberOfSamplingPointInX_new = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'Units', 'Normalized', ...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','edit',...
        'Tag', 'txtNumberOfSamplingPointInX', ...
        'String','64',...
        'Units', 'normalized', ...
        'Position',[0.75,0.9,0.1,0.05]);
    figureHandle.Object.txtNumberOfSamplingPointInY_new = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'Units', 'Normalized', ...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','edit',...
        'Tag', 'txtNumberOfSamplingPointInY', ...
        'String','64',...
        'Units', 'normalized', ...
        'Position',[0.86,0.9,0.1,0.05]);
    
    
    figureHandle.Object.lblInterpolationType = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','text',...
        'Tag', 'lblInterpolationType', ...
        'String','Interpolation',...
        'Units', 'normalized', ...
        'Position',[0.01,0.80,0.3,0.05]);
    
    figureHandle.Object.popInterpolationType = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'FontSize',fontSize,'FontName', fontName,...
        'Style','popupmenu',...
        'Tag', 'popInterpolationType', ...
        'String',{'linear','nearest','cubic','spline'},...
        'Units', 'normalized', ...
        'Position',[0.31,0.80,0.4,0.05]);
    
    figureHandle.Object.btnResample = uicontrol( ...
        'Parent',figureHandle.Object.resampleTab,...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnResample', ...
        'String','Resample',...
        'Units', 'normalized', ...
        'Position',[0.75,0.80,0.21,0.05],...
        'Callback',{@btnResample_Callback,figureHandle});
    
    
    
    figureHandle.Object.btnImport = uicontrol( ...
        'Parent',figureHandle.Object.MainFigureHandle,...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnImport', ...
        'String','Import',...
        'Units', 'normalized', ...
        'Position',[0.1,0.02,0.2,0.05],...
        'Callback',{@btnImport_Callback,figureHandle});
    
    figureHandle.Object.btnOk = uicontrol( ...
        'Parent',figureHandle.Object.MainFigureHandle,...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnOk', ...
        'String','OK',...
        'Units', 'normalized', ...
        'Position',[0.4,0.02,0.2,0.05],...
        'Callback',{@btnOk_Callback,figureHandle});
    
    
    figureHandle.Object.btnCancel = uicontrol( ...
        'Parent',figureHandle.Object.MainFigureHandle,...
        'Units', 'Normalized', ...
        'FontSize',fontSize,'FontName', 'FixedWidth',...
        'Style','pushbutton',...
        'Tag', 'btnCancel', ...
        'String','Cancel',...
        'Units', 'normalized', ...
        'Position',[0.7,0.02,0.2,0.05],...
        'Callback',{@btnCancel_Callback,figureHandle});
    
    if ~allowDataManipulation
        set(figureHandle.Object.btnImport,'enable','off');
        set(allchild(figureHandle.Object.resampleTab),'enable','off');
    end
    
    updateTheGUI(figureHandle);
end

function tblNumericMatrixData_CellSelectionCallback(hObject, eventdata)
end
function tblNumericMatrixData_CellEditCallback(hObject, eventdata)
end


function btnResample_Callback(~, ~,figureHandle)
    currentMatrix = figureHandle.Object.CurrentMatrix;
    
    oldNx = str2num(get(figureHandle.Object.txtNumberOfSamplingPointInX_old,'String'));
    oldNy = str2num(get(figureHandle.Object.txtNumberOfSamplingPointInY_old,'String'));
    newNx = str2num(get(figureHandle.Object.txtNumberOfSamplingPointInX_new,'String'));
    newNy = str2num(get(figureHandle.Object.txtNumberOfSamplingPointInY_new,'String'));
    
    interpolationOptionList = get(figureHandle.Object.popInterpolationType,'String');
    selectedInterpolation = interpolationOptionList{get(figureHandle.Object.popInterpolationType,'Value')};
    
    Xq = linspace(1,oldNx,newNx);
    Yq = (linspace(1,oldNy,newNy))';
    resampledMatrix = interp2(currentMatrix,Xq,Yq,selectedInterpolation);
    
    % Click graph tab programatically
    set(figureHandle.Object.mainTabGroup,'SelectedTab',...
        figureHandle.Object.diagramTab);
    
    figureHandle.Object.CurrentMatrix = resampledMatrix;
    updateTheGUI(figureHandle);
end

function btnImport_Callback(~, ~,figureHandle)
    
    % Click graph tab programatically
    set(figureHandle.Object.mainTabGroup,'SelectedTab',...
        figureHandle.Object.diagramTab);
    
    % Open either text file or picture file
    [FileNameWithExt,PathName] = uigetfile({'*.jpg;*.bmp;*.png'},'Select file');
    % FileName=0 when no file is selected
    if (FileNameWithExt==0)
        return;
    end
    fullFileName = [PathName,FileNameWithExt];
    storedDiagram = double(flipud(rgb2gray(imread(fullFileName))));
    figureHandle.Object.CurrentMatrix = storedDiagram;
    figureHandle.Object.CurrentMatrixSourceFileName = fullFileName;
    updateTheGUI(figureHandle);
end
function btnOk_Callback(~, ~,figureHandle)
    currentMatrix = figureHandle.Object.CurrentMatrix;
    currentMatrixSourceFileName = figureHandle.Object.CurrentMatrixSourceFileName;
    setappdata(0,'StoredMatrix',currentMatrix);
    setappdata(0,'StoredMatrixSourceFileName',currentMatrixSourceFileName);
    close(figureHandle.Object.MainFigureHandle);
end
function btnCancel_Callback(~, ~,figureHandle)
    % Do nothing
    close(figureHandle.Object.MainFigureHandle);
end

function updateTheGUI(figureHandle)
    storedDiagram = figureHandle.Object.CurrentMatrix;
    nameOfTheMatrix = figureHandle.Object.NameOfTheMatrix;
    
    set(figureHandle.Object.tblNumericMatrixData,'Data',storedDiagram);
    pcolor(figureHandle.Object.axesDiagram,linspace(-floor(size(storedDiagram,2)/2),floor(size(storedDiagram,2)/2),size(storedDiagram,2)),...
        linspace(-floor(size(storedDiagram,1)/2),floor(size(storedDiagram,1)/2),size(storedDiagram,1)),storedDiagram);
    shading(figureHandle.Object.axesDiagram,'interp');
    colormap(figureHandle.Object.axesDiagram,'gray');
    colorbar(figureHandle.Object.axesDiagram);
    
    figureTitle = [nameOfTheMatrix,' [',num2str(size(storedDiagram,2)),':',num2str(size(storedDiagram,1)),']'];
    set(figureHandle.Object.MainFigureHandle,'Name',figureTitle);
    set(figureHandle.Object.txtNumberOfSamplingPointInX_old,'String',size(storedDiagram,2));
    set(figureHandle.Object.txtNumberOfSamplingPointInY_old,'String',size(storedDiagram,1));
    
    set(figureHandle.Object.txtNumberOfSamplingPointInX_new,'String',size(storedDiagram,2));
    set(figureHandle.Object.txtNumberOfSamplingPointInY_new,'String',size(storedDiagram,1));
end
