function [abbeNumber] = getAbbeNumber(glass,wavLenF,wavLend,wavLenC)
    % getAbbeNumber: Returns abbe number of glass computed from refractive indices
    % at three different wavelengths. It supports vector inputs of wavlengths and
    % gives vector output of abbeNumber.
    % Inputs:
    %   (glass,wavLenF,wavLend,wavLenC)
    % Outputs:
    %   [abbeNumber]
    
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
        disp('Error: Glass object is required to compute the Abbe Number.');
        abbeNumber = 0;
        return;
    elseif nargin == 1
        wavLenF = 486.13*10^-9;
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
    elseif nargin == 2
        wavLend = 587.56*10^-9;
        wavLenC = 656.27*10^-9;
    elseif nargin == 3
        wavLenC = 656.27*10^-9;
    end
    nRay = size(wavLenF,2);
    % Connect to glass definition function and get the abbe number
    glassType = glass.Type;
    if strcmpi(glassType,'IdealDispersive')
        abbeNumber = zeros([1,nRay]);
    elseif strcmpi(glassType,'IdealDispersive')
        abbeNumber = repmat(glass.Parameters.AbbeNumber(2),[1,nRay]);
    else
        % Compute refractive indices at different wavelengths Glass,wavLen,)
        nF = getRefractiveIndex(glass,wavLenF);
        nd = getRefractiveIndex(glass,wavLend);
        nC = getRefractiveIndex(glass,wavLenC);
        abbeNumber = (nd-1)./(nF-nC);
    end
end