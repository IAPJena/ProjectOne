function [refractiveIndexRe,refractiveIndexIm, thickness] = ...
        plotCoatingRefractiveIndexProfile(coating,axesHandle,tableHandle,textHandle)
    % plotCoatingRefractiveIndexProfile: Plot refractive index profile of a user defined coating
    % Inputs:
    %   (coating,axesHandle,tableHandle,textHandle)
    % Outputs:
    %   [refractiveIndexRe,refractiveIndexIm, thickness]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Mar 07,2014   Worku, Norman G.
    
    
    % deafualt inputs
    if nargin < 1
        disp('Error: The function needs atleast a coating object as argument.');
        refractiveIndexRe = NaN;
        refractiveIndexIm = NaN;
        thickness = NaN;
        return;
    elseif nargin == 1
        axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
    else
    end
    
    % Plot the graph on axesHandle
    if strcmpi(coating.Type,'Multilayer')
        
        refIndex = coating.Parameters.RefractiveIndexProfile(:,1);
        
        % Separate the real and imaginary part of the refractive indixes
        refIndexReal = real(refIndex);
        refIndexImag = imag(refIndex);
        
        thickness = coating.Parameters.RefractiveIndexProfile(:,2);
        refractiveIndexRe = refIndexReal;
        refractiveIndexIm = refIndexImag;
        
        if isnumeric(axesHandle) && axesHandle == -1 % No ploting is required
            return
        end
        
        
        for kk=1:1:length(thickness)
            x(kk) = sum(thickness(1:kk));
        end
        
        stairs(axesHandle,[0 x],[refractiveIndexRe;refractiveIndexRe(kk)],'k');
        hold on;
        stairs(axesHandle,[0 x],[refractiveIndexIm;refractiveIndexIm(kk)],'r');
        
        hleg1 = legend('Refractive Index (Real)','Refractive Index (Imaginary)');
        set(hleg1,'Location','SouthEast')
        xlabel('Thickness','FontSize',12)
        ylabel('Refractive Index','FontSize',12)
        title([coating.Name,': Refractive Index Profile'],'FontSize',12)
    else
        msgbox 'The coating is not defined by its refractive index profile.';
        refractiveIndexRe = NaN;
        refractiveIndexIm = NaN;
        thickness = NaN;
        return;
    end
    
    if nargin == 3
        % Display tabular data on the tableHandle
        newTable1 = coating.Parameters.RefractiveIndexProfile;
        newTable1 = mat2cell(newTable1,[ones(1,size(newTable1,1))],[ones(1,size(newTable1,2))]);
        columnName1 = {'Refractive Index','Thickness (Lens Unit)'};
        columnWidth1 = {'auto','auto'};
        set(tableHandle, 'Data', newTable1,...
            'ColumnName', columnName1,'ColumnWidth',columnWidth1);
    end
    if nargin == 4
        % Write some note on the text window
        set(textHandle,'String','No text to display ...');
    end
end
