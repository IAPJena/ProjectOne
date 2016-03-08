function mainFigHandle = harmonicFieldSetViewer( variableInputArgument,fontSize,fontName )
    %HarmonicFieldSetViewer Displays a window to view the harmonic field set
    % variableInputArgument could be a harmonic field, a harmonic field
    % source or 'CurrentHarmonicFieldSource'
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
        variableInputArgument = HarmonicFieldSet;
    end
    if nargin < 2
        fontSize = 9.5;
    end
    if nargin < 3
        fontName = 'FixedWidth';
    end
    
    figureHandle.FontName = fontName;
    figureHandle.FontSize = fontSize;
    figureHandle.HarmonicFieldSet = variableInputArgument;
    % Allows dynamic source extraction while defining and viewing source simultanoulsly
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    figureHandle.MainFigureHandle = figure( ...
        'Units', 'normalized', ...
        'Name', 'Harmonic Field Set Viewer', ...
        'MenuBar', 'figure', ...
        'Toolbar','figure',...
        'NumberTitle', 'off', ...
        'Units','normalized',...
        'Position',[0.3,0.01,0.4,0.8],...
        'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
        'Resize', 'on');
    
    % Build the GUI
    %% Edit Standard Toolbar by removing the first two toolbar buttons
    % New Figure and Open File as they don't make sense in our case
    stdToolBar = (findall(...
        figureHandle.MainFigureHandle,'Type','uitoolbar'));
    stdToolBarBtns = allchild(stdToolBar);
    set(stdToolBarBtns(end),'Visible','off');
    set(stdToolBarBtns(end-1),'Visible','off');
    % Add a refresh button at the end
    updateIcon = rand(19,23,3)*0;
    updateIcon(4:17,5:7,:) = 1;
    updateIcon(4:17,16:18,:) = 1;
    updateIcon(15:17,5:16,:) = 1;
    
    
    figureHandle.btnRefresh = uitoggletool(stdToolBar,...
        'CData',updateIcon,...
        'Separator','on',...
        'TooltipString','Update',...
        'HandleVisibility','on');
    
    % Add a new menu for Manipulation of the displayed field
    menuFieldManipulation = uimenu('Label','Feild Manipulation');
    uimenu(menuFieldManipulation,'Label','Add Spherical Phase','Callback',{@menuAddSphericalPhase_Callback,figureHandle});
    uimenu(menuFieldManipulation,'Label','Fourier Transform (x->k)','Callback',{@menuFFT_Callback,figureHandle},...
        'Separator','on');
    uimenu(menuFieldManipulation,'Label','Inverse Fourier Transform (k->x)','Callback',{@menuIFFT_Callback,figureHandle});
    uimenu(menuFieldManipulation,'Label','Fraunhofer Propagator','Callback',{@menuFraunhoferPropagator_Callback,figureHandle},...
        'Separator','on');
    uimenu(menuFieldManipulation,'Label','SPW Propagator','Callback',{@menuSPWPropagator_Callback,figureHandle},...
        'Separator','on');
    uimenu(menuFieldManipulation,'Label','SPW Propagator Axial','Callback',{@menuSPWPropagatorAxial_Callback,figureHandle},...
        'Separator','on');
    
    
    figureHandle.panelSetting = uipanel( ...
        'Parent', figureHandle.MainFigureHandle, ...
        'Tag', 'panelSetting', ...
        'Units','Normalized',...
        'Position', [0.0,0.90,1.0,0.10], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','On');
    
    figureHandle.panelColorPlot = uipanel( ...
        'Parent', figureHandle.MainFigureHandle, ...
        'Tag', 'panelColorPlot', ...
        'Units','Normalized',...
        'Position', [0.0,0.35,1.0,0.55], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','On');
    
    figureHandle.panelLinePlot = uipanel( ...
        'Parent', figureHandle.MainFigureHandle, ...
        'Tag', 'panelLinePlot', ...
        'Units','Normalized',...
        'Position', [0.0,0.05,1.0,0.30], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','On');
    
    figureHandle.panelTaskBar = uipanel( ...
        'Parent', figureHandle.MainFigureHandle, ...
        'Tag', 'panelTaskBar', ...
        'Units','Normalized',...
        'Position', [0.0,0.0,1.0,0.05], ...
        'FontSize',fontSize,'FontName',fontName,...
        'Visible','On');
    
    % --------------------------------------------------------------------
    figureHandle.buttonGroupFieldComponent = uibuttongroup( ...
        'Parent', figureHandle.panelSetting, ...
        'Units','Normalized',...
        'Position',[0.0 0.5 0.25 0.5]);
    
    % Create three radio buttons in the button group.
    figureHandle.rbtnEx = uicontrol(figureHandle.buttonGroupFieldComponent,'Style',...
        'radiobutton',...
        'String','Ex',...
        'Units','Normalized', ...
        'FontSize',fontSize,'FontName',fontName,...
        'Position',[0.0 0.0 0.3 1.0]);
    
    figureHandle.rbtnEy = uicontrol(figureHandle.buttonGroupFieldComponent,'Style','radiobutton',...
        'String','Ey',...
        'Units','Normalized', ...
        'FontSize',fontSize,'FontName',fontName,...
        'Position',[0.35 0.0 0.3 1.0]);
    
    figureHandle.rbtnEz = uicontrol(figureHandle.buttonGroupFieldComponent,'Style','radiobutton',...
        'String','Ez',...
        'Units','Normalized', ...
        'FontSize',fontSize,'FontName',fontName,...
        'Position',[0.7 0.0 0.3 1.0]);
    % --------------------------------------------------------------------
    figureHandle.buttonGroupParameterToShow = uibuttongroup( ...
        'Parent', figureHandle.panelSetting, ...
        'Units','Normalized',...
        'Position',[0.25 0.5 0.55 0.5]);
    
    
    % Create three radio buttons in the button group.
    figureHandle.rbtnAmplitude = uicontrol(figureHandle.buttonGroupParameterToShow,'Style','radiobutton',...
        'String','A',...
        'Units','Normalized',...
        'Position',[0.3 0.0 0.15 1.0], ...
        'FontSize',fontSize,'FontName',fontName);
    figureHandle.rbtnPhase = uicontrol(figureHandle.buttonGroupParameterToShow,'Style','radiobutton',...
        'String','F',...
        'Units','Normalized',...
        'Position',[0.45 0.0 0.15 1.0],...
        'FontSize',fontSize*1.3,'FontName','symbol');
    
    figureHandle.rbtnReal = uicontrol(figureHandle.buttonGroupParameterToShow,'Style',...
        'radiobutton',...
        'String','Re',...
        'Units','Normalized',...
        'Position',[0.0 0.0 0.15 1.0], ...
        'FontSize',fontSize,'FontName',fontName);
    
    figureHandle.rbtnImaginary = uicontrol(figureHandle.buttonGroupParameterToShow,'Style','radiobutton',...
        'String','Im',...
        'Units','Normalized',...
        'Position',[0.15 0.0 0.15 1.0], ...
        'FontSize',fontSize,'FontName',fontName);
    
    
    figureHandle.rbtnEllipseOrientation = uicontrol(figureHandle.buttonGroupParameterToShow,'Style','radiobutton',...
        'String','q',...
        'Units','Normalized',...
        'Position',[0.70 0.0 0.15 1.0],...
        'FontSize',fontSize*1.3,'FontName','symbol');
    figureHandle.rbtnEllipseEccentricity = uicontrol(figureHandle.buttonGroupParameterToShow,'Style','radiobutton',...
        'String','e',...
        'Units','Normalized',...
        'Position',[0.85 0.0 0.15 1.0],...
        'FontSize',fontSize*1.3,'FontName','symbol');
    
    % --------------------------------------------------------------------
    %     figureHandle.lblPlane = uicontrol( ...
    %         'Parent', figureHandle.panelSetting, ...
    %         'Tag', 'lblPlane', ...
    %         'Style', 'text', ...
    %         'HorizontalAlignment','left',...
    %         'Units','Normalized',...
    %         'Position', [0.81,0.35,0.10,0.5], ...
    %         'FontSize',fontSize,'FontName',fontName,...
    %         'String', 'Plane');
    %
    %     figureHandle.popPlane = uicontrol( ...
    %         'Parent', figureHandle.panelSetting, ...
    %         'Tag', 'popPlane', ...
    %         'Style', 'popupmenu', ...
    %         'HorizontalAlignment','left',...
    %         'Units','Normalized',...
    %         'Position', [0.90,0.40,0.1,0.5], ...
    %         'BackgroundColor', [1 1 1], ...
    %         'FontSize',fontSize,'FontName',fontName,...
    %         'String', {'XY','YZ','XZ'});
    
    figureHandle.chkShowPolarizationEllipse = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'chkShowPolarizationEllipse', ...
        'Style', 'checkbox', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.81,0.55,0.20,0.35], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Pol Ellipse');
    % --------------------------------------------------------------------
    figureHandle.lblSpectralComponent = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'lblSpectralComponent', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.00,0.00,0.30,0.350], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Current Field Index');
    
    %     nHarmonicFields = length(harmonicFieldSet.HarmonicFieldArray );
    nHarmonicFields = (harmonicFieldSet.NumberOfHarmonicFields );
    
    AllFieldIndices = [num2cell(1:nHarmonicFields)];
    figureHandle.popCurrentFieldIndex = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'popCurrentFieldIndex', ...
        'Style', 'popupmenu', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.30,0.00,0.10,0.40], ...
        'BackgroundColor', [1 1 1], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', AllFieldIndices);
    
    figureHandle.lblCurrentWavelength = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'lblSpectralComponent', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.47,0.00,0.18,0.350], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Wavelength ');
    
    currentFieldIndex = get(figureHandle.popCurrentFieldIndex,'Value');
    currentWavelength = harmonicFieldSet.Wavelength(currentFieldIndex);
    figureHandle.txtCurrentWavelength = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'lblSpectralComponent', ...
        'Style', 'edit', ...
        'HorizontalAlignment','left',...
        'Units','Normalized','enable','off',...
        'Position', [0.650,0.05,0.15,0.35], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', currentWavelength);
    
    figureHandle.lblPlane = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'lblPlane', ...
        'Style', 'text', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.81,0.05,0.10,0.3], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', 'Plane');
    
    figureHandle.popPlane = uicontrol( ...
        'Parent', figureHandle.panelSetting, ...
        'Tag', 'popPlane', ...
        'Style', 'popupmenu', ...
        'HorizontalAlignment','left',...
        'Units','Normalized',...
        'Position', [0.90,0.05,0.1,0.35], ...
        'BackgroundColor', [1 1 1], ...
        'FontSize',fontSize,'FontName',fontName,...
        'String', {'XY','YZ','XZ'},...
        'enable','off');
    
    % --------------------------------------------------------------------
    figureHandle.axesColorPlot = axes( ...
        'parent',figureHandle.panelColorPlot,...
        'FontSize',fontSize,'FontName', fontName,...
        'Units', 'Normalized',...
        'Position', [0.15,0.15, 0.7, 0.75]);
    
    
    % --------------------------------------------------------------------
    figureHandle.axesLinePlot = axes( ...
        'parent',figureHandle.panelLinePlot,...
        'FontSize',fontSize,'FontName', fontName,...
        'Units', 'Normalized',...
        'Position', [0.15,0.25, 0.7, 0.60]);
    % Callbacks
    set(figureHandle.buttonGroupFieldComponent,'SelectionChangedFcn',...
        {@buttonGroupFieldComponent_SelectionChangedFcn,figureHandle});
    set(figureHandle.buttonGroupParameterToShow,'SelectionChangedFcn',...
        {@buttonGroupParameterToShow_SelectionChangedFcn,figureHandle});
    set(figureHandle.btnRefresh,'ClickedCallback', {@btnRefresh_Callback,figureHandle});
    set(figureHandle.chkShowPolarizationEllipse,'Callback', {@chkShowPolarizationEllipse_Callback,figureHandle});
    set(figureHandle.popCurrentFieldIndex,'Callback', {@popCurrentFieldIndex_Callback,figureHandle});
    
    % --------------------------------------------------------------------
    updateHarmonicFieldSetViewer(figureHandle)
    
end
function chkShowPolarizationEllipse_Callback(hObject, ~, figureHandle)
    % hObject    handle to checkbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox1
    updateHarmonicFieldSetViewer(figureHandle)
    
    if (get(hObject,'Value') == get(hObject,'Max'))
        % 	display('Selected');
    else
        % 	display('Not selected');
    end
end

function popCurrentFieldIndex_Callback(hObject, ~, figureHandle)
    % hObject    handle to checkbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox1
    updateHarmonicFieldSetViewer(figureHandle)
end
function btnRefresh_Callback(~,~,figureHandle)
    updateHarmonicFieldSetViewer(figureHandle)
end

function menuAddSphericalPhase_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    
    % Get the spherical phase radius
    prompt = {'Enter the spherical phase radius :','Enter the refractive index :'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'0.01','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return;
    end
    sphericalPhaseRad = str2num(answer{1});
    refractiveIndex = str2num(answer{2});
    
    if isempty(sphericalPhaseRad)
        sphericalPhaseRad = Inf;
    end
    if isempty(refractiveIndex)
        refractiveIndex = 1;
    end
    
    [ modifiedHarmonicFieldSet ] = addSphericalPhase( harmonicFieldSet,sphericalPhaseRad,refractiveIndex );
    % Open a new harmonuic field viewer window
    
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
end

function menuFFT_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    
    %     % Get the scaling factor
    %     prompt = {'Enter the scaling factor : '};
    %     dlg_title = 'Input';
    %     num_lines = 1;
    %     defaultans = {'1'};
    %     answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    %     scalingFactor = str2num(answer{1});
    %
    %     if isempty(scalingFactor)
    %         scalingFactor = 1;
    %     end
    scalingFactor = [1,1];
    
    [ modifiedHarmonicFieldSet ] = computeFieldFFT( harmonicFieldSet,scalingFactor);
    % Open a new harmonuic field viewer window
    
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
end

function menuIFFT_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    [ modifiedHarmonicFieldSet ] = computeFieldIFFT( harmonicFieldSet);
    % Open a new harmonuic field viewer window
    
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
end

function menuFraunhoferPropagator_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    
    prompt = {'Enter propagation distance (mm):','Enter output window size (mm):'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'10','0.1'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return;
    end
    propagationDistance = str2num(answer{1})*10^-3;
    outputWindowSize = str2num(answer{2})*10^-3;
    addSphericalCorrection = 1;
    [ modifiedHarmonicFieldSet ] = FraunhoferPropagator( harmonicFieldSet,propagationDistance,outputWindowSize,addSphericalCorrection );
    % Open a new harmonuic field viewer window
    
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
end
function menuSPWPropagator_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    
    prompt = {'Enter propagation distance (mm):'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {'10'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return;
    end
    propagationDistance = str2num(answer{1})*10^-3;
    [ modifiedHarmonicFieldSet ] = SPWPropagator( harmonicFieldSet,propagationDistance );
    % Open a new harmonuic field viewer window
    
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
end

function menuSPWPropagatorAxial_Callback(~,~,figureHandle)
    fontName = figureHandle.FontName;
    fontSize = figureHandle.FontSize;
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    
    prompt = {'From (mm):','To (mm):','Steps :','Field Index :'};
    dlg_title = 'Input axial propagation parameters';
    num_lines = 1;
    defaultans = {'10','20','100','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return;
    end
    propagationFrom = str2num(answer{1})*10^-3;
    propagationTo = str2num(answer{2})*10^-3;
    N = str2num(answer{3});
    fieldIndex = str2num(answer{4});
    propagationDistance = linspace(propagationFrom,propagationTo,N);
    for kk = 1:N
    [ harmonicFieldArray(kk) ] = SPWPropagator( harmonicFieldSet,propagationDistance(kk),fieldIndex );
    end
    % Open a new harmonuic field viewer window
    [ modifiedHarmonicFieldSet ] = ConvertHFArrayToHFSet( harmonicFieldArray );
    harmonicFieldSetViewer( modifiedHarmonicFieldSet,fontSize,fontName );
    % Show the YZ cross section of intensity
    
end


function buttonGroupFieldComponent_SelectionChangedFcn(~,~,figureHandle)
    updateHarmonicFieldSetViewer(figureHandle)
end
function buttonGroupParameterToShow_SelectionChangedFcn(~,~,figureHandle)
    updateHarmonicFieldSetViewer(figureHandle)
end

function updateHarmonicFieldSetViewer(figureHandle)
    harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle);
    fontSize = figureHandle.FontSize;
    fontName = figureHandle.FontName;
    colorPlotAxes = figureHandle.axesColorPlot;
    % Clear the color plot axis
    cla(colorPlotAxes,'reset')
    
    % Read all setting parameters
    showEx = get(figureHandle.rbtnEx,'Value');
    showEy = get(figureHandle.rbtnEy,'Value');
    showEz = get(figureHandle.rbtnEz,'Value');
    
    showReal = get(figureHandle.rbtnReal,'Value');
    showImaginary = get(figureHandle.rbtnImaginary,'Value');
    showAmplitude = get(figureHandle.rbtnAmplitude,'Value');
    showPhase = get(figureHandle.rbtnPhase,'Value');
    
    showEllipseOrientation = get(figureHandle.rbtnEllipseOrientation,'Value');
    showEllipseEccentricity = get(figureHandle.rbtnEllipseEccentricity,'Value');
    
    selectedFieldIndex = get(figureHandle.popCurrentFieldIndex,'Value');
    nField = harmonicFieldSet.NumberOfHarmonicFields;
    if selectedFieldIndex > nField
        selectedFieldIndex = nField;
        set(figureHandle.popCurrentFieldIndex,'String',num2cell([1:nField]));
        set(figureHandle.popCurrentFieldIndex,'Value',nField);
    end
    showPolarizationEllipse = get(figureHandle.chkShowPolarizationEllipse,'Value');
    selectedPlane = get(figureHandle.popPlane,'Value');
    % Set the wavelength
    wavlength = harmonicFieldSet.Wavelength(selectedFieldIndex);
    set(figureHandle.txtCurrentWavelength,'String',num2str(wavlength));
    
    % Plot the required quantity
    allExIn3D = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,1,selectedFieldIndex));
    allEyIn3D = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,2,selectedFieldIndex));
    Ex = allExIn3D;
    Ey = allEyIn3D;
    Nx = size(allExIn3D,2);
    Ny = size(allExIn3D,1);
    
    samplingPoints = [Nx;Ny];
    samplingDistance = harmonicFieldSet.SamplingDistance(:,selectedFieldIndex);
    centerXY = harmonicFieldSet.Center(:,selectedFieldIndex);
    [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);
    [xMesh,yMesh] = meshgrid(xlin,ylin);

    if showEx
        complexAmplitude = Ex;
        fieldComponent = 'Ex';
    elseif showEy
        complexAmplitude = Ey;
        fieldComponent = 'Ey';
    elseif showEz
        %         msgbox('Error: Ez can not be computed currently.');
        Ez = computeEz(harmonicFieldSet,selectedFieldIndex);
        complexAmplitude = Ez;
        fieldComponent = 'Ez';
    end
    
    minAmpThreshold = 0.0005; % Is the fraction of amplitude below which the phase is discarded
    if showReal
        requestedValue = real(complexAmplitude);
        valueDisplayedName = 'Real Part';
    elseif showImaginary
        requestedValue = imag(complexAmplitude);
        valueDisplayedName = 'Imaginary Part';
    elseif showAmplitude
        requestedValue = abs(complexAmplitude);
        valueDisplayedName = 'Amplitude';
    elseif showPhase
        requestedValue = angle(complexAmplitude);
        valueDisplayedName = 'Phase (rad)';
        % Avoid phase of very negligible amplitude values
        amplitude = abs(complexAmplitude);
        requestedValue(amplitude < minAmpThreshold*(max(max(amplitude)))) = 0;
    elseif showEllipseOrientation
        [ semiMajorAxisIn3D,semiMinorAxisIn3D,directionIn3D,orientationAngleIn3D] =...
            polarizationEllipseParametersIn3D( harmonicFieldSet,selectedPlane );
        requestedValue = orientationAngleIn3D(:,:,selectedFieldIndex);
        fieldComponent = 'Combined';
        valueDisplayedName = 'Ellipse Orientation \theta';
        % Avoid phase of very negligible amplitude values
        amplitude = abs(complexAmplitude);
        requestedValue(amplitude < minAmpThreshold) = 0;
    elseif showEllipseEccentricity
        [ semiMajorAxisIn3D,semiMinorAxisIn3D,directionIn3D,orientationAngleIn3D] =...
            polarizationEllipseParametersIn3D( harmonicFieldSet,selectedPlane );
        a = semiMajorAxisIn3D(:,:,selectedFieldIndex);
        b = semiMinorAxisIn3D(:,:,selectedFieldIndex);
        e = sqrt((a.^2-b.^2)./(a.^2));
        complexEntry = imag(e)~=0;
        if sum(sum(complexEntry))
            e(imag(e)~=0) = sqrt((b.^2-a.^2)./(b.^2));
        end
        requestedValue = e;
        fieldComponent = 'Combined';
        valueDisplayedName = 'Ellipse Eccentricity \eps';
        
        % Avoid phase of very negligible amplitude values
        amplitude = abs(complexAmplitude);
        requestedValue(amplitude < minAmpThreshold) = 0;
    else
        
    end
    
    
    
    sectionPlotAxesHandle = figureHandle.axesLinePlot;
    sectionTitle = 'Cross sectional view';
    if harmonicFieldSet.Domain == 1 % Spatial
        sectionXlabel = 'Position (m)';
    else
        sectionXlabel = 'Spatial Frequency (1/m)';
    end
    sectionYlable = [valueDisplayedName,' ,  ',fieldComponent];
    interpolationMethod = 'linear';%'spline';
    lineColor = 'w';
    lineWidth = 1.0;
    
    
    pause(0.00000001); % Sometimes with out this pause the pcolor will not be correctly plotted. I dont know why
    cla(colorPlotAxes,'reset');
    cla(sectionPlotAxesHandle,'reset');
    input_args = {colorPlotAxes,xMesh,yMesh,requestedValue};
    h = EnhancedPColor( input_args,...
        sectionPlotAxesHandle,interpolationMethod,lineColor,lineWidth,sectionTitle,sectionXlabel,sectionYlable );
    axis(colorPlotAxes,'equal');
    
    title(colorPlotAxes,[valueDisplayedName, ' , Component : ',fieldComponent])
    if harmonicFieldSet.Domain == 1 % Spatial
        xlabel(colorPlotAxes,'X Axis (m)') % x-axis label
        ylabel(colorPlotAxes,'Y Axis (m)') % y-axis label
    else
        xlabel(colorPlotAxes,'X Axis (1/m)') % x-axis label
        ylabel(colorPlotAxes,'Y Axis (1/m)') % y-axis label
    end
    
    
    c = colorbar(colorPlotAxes);
    c.Label.String = [valueDisplayedName,' ,  ',fieldComponent];
    
    axis(colorPlotAxes,'tight');
    grid(colorPlotAxes,'off');
    shading(colorPlotAxes,'interp');
    
    if showPolarizationEllipse
        [ semiMajorAxisIn3D,semiMinorAxisIn3D,directionIn3D,orientationAngleIn3D] =...
            polarizationEllipseParametersIn3D( harmonicFieldSet,selectedPlane );
        % Show only course sampling
        courseSampFact = 10;
        courseSampleX = [1:floor(Nx/courseSampFact):Nx];
        courseSampleY = [1:floor(Ny/courseSampFact):Ny];
        
        cx = xMesh(courseSampleY,courseSampleX);
        cy = yMesh(courseSampleY,courseSampleX);
        
        a = semiMajorAxisIn3D(courseSampleY,courseSampleX,selectedFieldIndex);
        b = semiMinorAxisIn3D(courseSampleY,courseSampleX,selectedFieldIndex);
        
        % Normalize a and b to maximum r value
        minDimension = min(max(max(xMesh)) - min(min(xMesh)),max(max(yMesh)) - min(min(yMesh)));
        nEllipse = max(length(courseSampleX),length(courseSampleY));
        maxEllipseRadius = max(max([a(:),b(:)])); % 0.5*minDimension/nEllipse;
        a = a*((0.5*minDimension/nEllipse)/maxEllipseRadius);
        b = b*((0.5*minDimension/nEllipse)/maxEllipseRadius);
        
        phi = orientationAngleIn3D(courseSampleY,courseSampleX,selectedFieldIndex);
        direction  = directionIn3D(courseSampleY,courseSampleX,selectedFieldIndex);
        hold(colorPlotAxes,'on');
        plotEllipse(a(:),b(:),cx(:),cy(:),phi(:),direction(:),colorPlotAxes);
        hold(colorPlotAxes,'on');
    end
    
end


function harmonicFieldSet = extractCurrrentHarmonicFieldSet(figureHandle)
    variableData = figureHandle.HarmonicFieldSet;
    if isHarmonicFieldSet(variableData)
        harmonicFieldSet = (variableData);
    elseif strcmpi(variableData,'CurrentHarmonicFieldSource')
        % To view the harmonic field source being built using harmonic field
        % source editor window, one can pass harmonicFieldSet = 'CurrentHarmonicFieldSource'
        harmonicFieldSource = getappdata(0,'HarmonicFieldSource');
        harmonicFieldSet = (getHFSourceHarmonicFieldSet(harmonicFieldSource));
    end
end
