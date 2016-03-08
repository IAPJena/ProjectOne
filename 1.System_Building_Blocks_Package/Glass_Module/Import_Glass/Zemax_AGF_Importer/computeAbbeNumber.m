function [abbeNumber] = computeAbbeNumber(glass,wavLenF,wavLenD,wavLenC)
    % getAbbeNumber: Returns abbe number of glass computed from
    % refractive indices at three different wavelengths
    % It supports vector inputs of wavlengths and gives vector output of
    % abbeNumber
    % Inputs:
    %   (glass,wavLenF,wavLenD,wavLenC)
    % Outputs:
    %   [abbeNumber]
    
	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%	Optical System Design Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% July 28,2014   Worku, Norman G.     Original Version        
    
    nRay = size(wavLenF,2);
    glassParameters = glass.CoefficientData;
    switch lower(strtrim(glass.Type))
        case lower('FixedIndex')
            abbeNumber = repmat(glassParameters(2),[1,nRay]);
        otherwise
            % Compute refractive indices at different wavelengths
            nf = computeRefractiveIndex ...
                (wavLenF,glassParameters);
            nd = computeRefractiveIndex ...
                (wavLenD,glassParameters);
            nc = computeRefractiveIndex ...
                (wavLenC,glassParameters);
            abbeNumber = (nd-1)./(nf-nc);
    end
    end