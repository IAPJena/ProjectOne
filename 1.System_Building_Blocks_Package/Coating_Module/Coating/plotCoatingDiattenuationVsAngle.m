function [diattenuationTrans,diattenuationRef,angleVector] = plotCoatingDiattenuationVsAngle...
        (coating,wavLenInUm,minAngleInDeg,maxAngleInDeg,angleStepInDeg,primWavLenInUm,indexBefore,indexAfter,...
        axesHandle,tableHandle,textHandle)
    % plotCoatingDiattenuationVsAngle: Plot diattenuation related to the coating for both transmission
    % and reflection versus angle for fixed wavelength 
    % Inputs:
    %   (coating,wavLenInUm,minAngleInDeg,maxAngleInDeg,angleStepInDeg,primWavLenInUm,
    %    indexBefore,indexAfter,axesHandle,tableHandle,textHandle)
    % Outputs:
    %   [diattenuationTrans,diattenuationRef,angleVector]
    
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
        
    localIncidenceAngleInDeg = minAngleInDeg:angleStepInDeg:maxAngleInDeg;
    referenceWavLenInUm = primWavLenInUm;
    [ampRs,ampRp,powRs,powRp] = ...
            getReflectionCoefficients(coating,wavLenInUm,...
            localIncidenceAngleInDeg*pi/180,indexBefore,indexAfter,referenceWavLenInUm); 
    [ampTs,ampTp,powTs,powTp] = ...
            getTransmissionCoefficients(coating,wavLenInUm,...
            localIncidenceAngleInDeg*pi/180,indexBefore,indexAfter,referenceWavLenInUm); 

    % Reshape the vector to 1x1xN dimensional matrix and merge to get Jones
    % matrix of 2x2xN size
    ampRs3d = reshape(ampRs,[1,1,length(ampRs)]);
    ampRp3d = reshape(ampRp,[1,1,length(ampRp)]);
    ampTs3d = reshape(ampTs,[1,1,length(ampTs)]);
    ampTp3d = reshape(ampTp,[1,1,length(ampTp)]);
    
    powRs3d = reshape(powRs,[1,1,length(powRs)]);
    powRp3d = reshape(powRp,[1,1,length(powRp)]);
    powTs3d = reshape(powTs,[1,1,length(powTs)]);
    powTp3d = reshape(powTp,[1,1,length(powTp)]);    
    zeros3d = zeros(1,1,length(powRs));        
        
        
    % decide which of three fresnels coefficients to use for Jones Matrix
    % for computing the diattenuation
%     % Case 1: amplitude coefficients not additive but may be complex.  
%     JRM_Amp = cat(1,(cat(2,ampRs3d,zeros3d)),(cat(2,zeros3d,ampRp3d)));
%     JTM_Amp = cat(1,(cat(2,ampTs3d,zeros3d)),(cat(2,zeros3d,ampTp3d)));
%     
%     % Case 2: intensity coefficients not additive the abs of pow coeff.

    % Case 3: power coefficients additive to 1  
    % (As Used as in Zemax) 
    JRM_Pow = cat(1,(cat(2,powRs3d,zeros3d)),(cat(2,zeros3d,powRp3d)));
    JTM_Pow = cat(1,(cat(2,powTs3d,zeros3d)),(cat(2,zeros3d,powTp3d)));        
    
    diattenuationTrans = computeDiattenuation(sqrt(JTM_Pow));
    diattenuationRef =  computeDiattenuation(sqrt(JRM_Pow));    

    angleVector = minAngleInDeg:angleStepInDeg:maxAngleInDeg;
    
    if isnumeric(axesHandle) && axesHandle == -1 % No ploting is required
        return
    end
    
    plot(axesHandle,angleVector,diattenuationTrans,angleVector,diattenuationRef);
    hleg1 = legend(axesHandle,'Transmission Diattenuation','Reflection Diattenuation');
    set(hleg1,'Location','NorthWest')      
    xlabel(axesHandle,'Incidence Angle (deg)','FontSize',12)
    ylabel(axesHandle,'Diattenuation','FontSize',12)
    title(axesHandle,[coating.Name,': Diattenuation Vs Incidence Angle'],'FontSize',12)  
    if nargin >= 9
        % Display tabular data on the tableHandle
        newTable1 = [angleVector',diattenuationTrans',diattenuationRef'];
        newTable1 = mat2cell(newTable1,[ones(1,size(newTable1,1))],[ones(1,size(newTable1,2))]);
        columnName1 = {'Angle (deg)','Transmission Diattenuation','Reflection Diattenuation'};
        columnWidth1 = {'auto','auto','auto'};
        set(tableHandle, 'Data', newTable1,...
            'ColumnName', columnName1,'ColumnWidth',columnWidth1);
    end
    if nargin >= 10
        % Write some note on the text window
        set(textHandle,'String','No text to display ...');
    end
end        

