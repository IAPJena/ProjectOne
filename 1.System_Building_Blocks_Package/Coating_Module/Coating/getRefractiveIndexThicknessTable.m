function [ refIndexAll,absoluteThicknessAll ] = getRefractiveIndexThicknessTable( coating,wavLen )
    % getRefractiveIndexThicknessTable: Returns a 2D matrix corresponding to the
    % refractive index vs thickness  table of the multilayer coating. For other
    % types it is not valid function. It also performs repeating the coating 
    % layers and reversing the order of the coating layers.
    % Inputs:
    %   (coating,wavLen)
    % Outputs:
    %   [refIndexAll,absoluteThicknessAll]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    % Jun 17,2015   Worku, Norman G.     Support the user defined coating
    %                                    definitions
    
    coatingType = coating.Type;
    coatingParameters = coating.Parameters;
    
    if strcmpi(coatingType,'MultilayerCoating')
        glassArray = coatingParameters.GlassArray;
        thicknessArray = coatingParameters.Thickness;
        relativeThicknessFlag = coatingParameters.RelativeThickness;
        
        % change relative thickness to absolute thickness
        relativeThicknessIndices = find(relativeThicknessFlag);
        absoluteThickness = thicknessArray;
        wavLen0 = referenceWavLen;
        n0 = getRefractiveIndex(glassArray(relativeThicknessIndices),wavLen0);
        absoluteThickness(relativeThicknessIndices) = ...
            convertRelativeToActualThickness(thicknessArray(relativeThicknessIndices),n0,wavLen0);
        
        refIndexAll = getRefractiveIndex(glassArray,wavLen);
        absoluteThicknessAll = absoluteThickness;
    else
        refIndexAll = NaN;
        absoluteThicknessAll = NaN;
        disp('Error: Refractive index thickness table is defined only for multilayer coating.');
        return;
    end
    
end

