function [refCoeff_S,refCoeff_P,averRefCoeff, angleVectorInDeg] = ...
        plotCoatingReflectionVsAngle(coating,wavLenInUm,minAngleInDeg,maxAngleInDeg,...
        angleStepInDeg,primWavLenInUm,indexBefore,indexAfter,axesHandle,tableHandle,textHandle)
    % plotCoatingReflectionVsAngle: Plot amplitude reflection coefficient for the
    % coating versus  angle for fixed wavelength (s, p - polarizations, average)
    % Inputs:
    %   (coating,wavLenInUm,minAngleInDeg,maxAngleInDeg,angleStepInDeg,primWavLenInUm,
    %   indexBefore,indexAfter,axesHandle,tableHandle,textHandle)
    % Outputs:
    %   [refCoeff_S,refCoeff_P,averRefCoeff, angleVectorInDeg]
    
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
    
    % Check for inputs
    % deafualt inputs
    if nargin < 7
        disp(['Error: The function needs atleast 7 inputs: '...
            'Coating,wavLen,angleStep,minAngle,maxAngle,indexBefore and indexAfter.']);
        return;
    elseif nargin == 7
        axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
    else
    end
    
    localIncidenceAngle = minAngleInDeg:angleStepInDeg:maxAngleInDeg;
    referenceWavLenInUm = primWavLenInUm;
    [ampRs,ampRp,powRs,powRp] = ...
        getReflectionCoefficients(coating,wavLenInUm,...
        localIncidenceAngle*pi/180,indexBefore,indexAfter,referenceWavLenInUm);
    
    % decide which of three fresnels coefficients to plot
    % Case 1: amplitude coefficients not additive but may be complex.
    
    % Case 2: intensity coefficients not additive the abs of amp coeff.
    
    % Case 3: power coefficients additive to 1
    refCoeff_S = powRs;
    refCoeff_P = powRp;
    
    % Compute average
    averRefCoeff = 0.5*(refCoeff_S+refCoeff_P);
    angleVectorInDeg = minAngleInDeg:angleStepInDeg:maxAngleInDeg;
    
    if isnumeric(axesHandle) && axesHandle == -1 % No ploting is required
        return
    end
    
    % Display graphical output
    plot(axesHandle,angleVectorInDeg,refCoeff_S,angleVectorInDeg,refCoeff_P,angleVectorInDeg,averRefCoeff);
    hleg1 = legend(axesHandle,'S Reflectance','P Reflectance','Average Reflectance' );
    set(hleg1,'Location','NorthWest')
    
    xlabel(axesHandle,'Incidence Angle (deg)','FontSize',12)
    ylabel(axesHandle,'Power Reflection Coefficient','FontSize',12)
    title(axesHandle,[coating.Name,': Reflection Vs Incidence Angle'],'FontSize',12)
    if nargin >= 9
        % Display tabular data on the tableHandle
        newTable1 = [angleVectorInDeg',refCoeff_S,refCoeff_P,averRefCoeff];
        newTable1 = mat2cell(newTable1,[ones(1,size(newTable1,1))],[ones(1,size(newTable1,2))]);
        columnName1 = {'Angle (deg)','S Reflectance','P Reflectance','Average Reflectance'};
        columnWidth1 = {'auto','auto','auto','auto'};
        set(tableHandle, 'Data', newTable1,...
            'ColumnName', columnName1,'ColumnWidth',columnWidth1);
    end
    if nargin >= 10
        % Write some note on the text window
        set(textHandle,'String','No text to display ...');
    end
end
