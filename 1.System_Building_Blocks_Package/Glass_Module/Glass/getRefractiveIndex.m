function [refractiveIndex] = getRefractiveIndex(glass,wavLenInM,derivativeOrder)
    % getRefractiveIndex: Returns the refractive index or its derivatives
    % (upto 2nd order) of the glass It supports vector inputs of wavlengths
    % and gives vector output of dndl
    % Inputs:
    %   (glass,wavLenInM,derivativeOrder)
    % Outputs:
    %   [refractiveIndex]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    if nargin == 0
        disp('Error: The function getRefractiveIndex needs atleast the glass name as input.');
        refractiveIndex = 0;
        return;
    elseif nargin == 1
        disp(['Warning: No wavelength is specified for refractive index '...
            'computation. SO default value of 0.55 um is used.']);
        wavLenInM = 0.55 * 10^-6;
        derivativeOrder = 0;
    elseif nargin == 2
        derivativeOrder = 0;
    end
    
    % Connect to glass definition function and get the refractive index
    glassType = glass.Type;
    glassParameters = glass.UniqueParameters;
    
    % Connect to glass Defintion function
    glassDefinitionHandle = str2func(glassType);
    returnFlag = 2; % refractive index
    inputDataStruct = struct();
    inputDataStruct.Wavelength = wavLenInM;
    inputDataStruct.DerivativeOrder = derivativeOrder;
    [ returnDataStruct] = glassDefinitionHandle(returnFlag,glassParameters,inputDataStruct);
    refractiveIndex = returnDataStruct.RefractiveIndex;
end