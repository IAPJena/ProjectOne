function [ refractiveIndexArray,abbeNumberArray, glassNameCellArray ] = ...
        plotAbbeDiagram( glassObjectArray,label,wavLenF,wavLend,wavLenC,axesHandle );
    % plotAbbeDiagram: Plots the Glass map of a given glass struct array
    % Inputs:
    %   (glassObjectArray,label,wavLenF,wavLend,wavLenC,axesHandle )
    % Outputs:
    %   [refractiveIndexArray,abbeNumberArray,glassNameCellArray]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if nargin == 0
        disp('Warning: The function plotAbbeDiagram used SCHOTT as default glass catlaogue.');
        objectCatalogueName = 'SCHOTT_AGF.MAT';
        objectType = 'Glass';
        [ objectCatalogueFileNames ] = getAnObjectCatalogue(objectCatalogueName,objectType);
        schottCatalogue = objectCatalogueFileNames{1};
        load(schottCatalogue,'ObjectArray','FileInfoStruct');
        glassObjectArray = ObjectArray;
        label = 0;
        wavLenF = 486.13*10^-9;
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
        figure;
        axesHandle = axes;
    elseif nargin == 1
        disp('Warning: Default wavelengths of F,d and C are used for calculations.');
        label = 0;
        wavLenF = 486.13*10^-9;
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
        figure;
        axesHandle = axes;
    elseif nargin == 2
        disp('Warning: Default wavelengths of F,d and C are used for calculations.');
        wavLenF = 486.13*10^-9;
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
        figure;
        axesHandle = axes;
    elseif nargin == 3
        disp('Warning: Default wavelengths of d and C are used for calculations.');
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
        figure;
        axesHandle = axes;
    elseif nargin == 4
        disp('Warning: Default wavelengths of C is used for calculations.');
        wavLenC = 656.27*10^-9;
        figure;
        axesHandle = axes;
    elseif nargin == 5
        figure;
        axesHandle = axes;
    end
    numberOfGlass = size(glassObjectArray,2);
    
    allNames = cell(numberOfGlass,1);
    for gg = 1:numberOfGlass
        if isGlass(glassObjectArray(gg))
            glassObject = glassObjectArray(gg);
            name = glassObjectArray(gg).Name;
        else
            disp('Error: The GlassArray input should be either array of glass objects or glass structs!');
            plotted = 0;
            return;
        end
        
        nd(gg) = getRefractiveIndex(glassObject,wavLend);
        % Compute the abbe number
        vd(gg) = getAbbeNumber(glassObject,wavLenF,wavLend,wavLenC);
        
        if isnumeric(axesHandle) && axesHandle == -1 % No ploting is required
            continue;
        else
            % Plot on the map
            plot3(vd(gg),nd(gg),gg,'rx');
            allNames{gg} = name;
            if label
                text(vd(gg),nd(gg),gg,name);
            end
            hold on;
        end
    end
    refractiveIndexArray = nd;
    abbeNumberArray = vd;
    glassNameCellArray = allNames;
    
    if isnumeric(axesHandle) && axesHandle == -1 % No ploting is required
        return;
    else
        title(axesHandle,['Abbe Diagram Using Main Wavelengths: [',...
            num2str(wavLenF*10^6,4),',',num2str(wavLend*10^6,4),',',...
            num2str(wavLenC*10^6,4),'] um'],'FontSize',11);
        xlabel(axesHandle,'Abbe Number <-','FontSize',11) % x-axis label
        ylabel(axesHandle,'Refractive Index','FontSize',11) % y-axis label
        set(axesHandle,'Xdir', 'reverse');
        
        datacursormode on;
        axesFigure = get(axesHandle,'Parent');
        dcm_obj = datacursormode(axesFigure);
        
        setappdata(axesHandle,'glassNameCellArray',glassNameCellArray);
        
        set(dcm_obj,'UpdateFcn',@myupdatefcn)
        view(2);
    end
    
end


function txt = myupdatefcn(obj,event_obj)
    % Display the position of the data cursor
    % obj          Currently not used (empty)
    % event_obj    Handle to event object
    % output_txt   Data cursor text string (string or cell array of strings).
    
    pos = get(event_obj,'Position');
    glassPos = pos(3);
    
    % Get the parent of the target object (i.e. the axes):
    hAxes = get(get(event_obj,'Target'),'Parent');
    % Get the data stored with the axes object:
    glassNameCellArray = getappdata(hAxes,'glassNameCellArray');
    
    txt = {['Name: ',glassNameCellArray{pos(3)}],...
        ['Vd: ',num2str(pos(1),4)],...
        ['nd: ',num2str(pos(2),4)]};
end
