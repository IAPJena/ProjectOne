function [fieldNames,fieldFormat,uniqueParamStruct,fieldDisplayNames] = getCoatingUniqueParameters( variableInputArgument )
    %getCoatingUniqueParameters Returns the field names, formats, and current
    %struct of all unique parameters which are specific to this coating type
    % Inputs:
    % variableInputArgument:
    %       1. Struct/object --> currentCoating
    %       2. Char --> CoatingType
    % Outputs:
    %   [fieldNames,fieldFormat,uniqueParamStruct]
    
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
        returnDefault = 1;
        coatingType = 'NullCoating';
    elseif isCoating(variableInputArgument)
        currentCoating = variableInputArgument;
        returnDefault = 0;
        coatingType = currentCoating.Type;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        coatingType = variableInputArgument;
    else
        disp('Error: Invalid input to getCoatingUniqueParameters. So it is just ignored.');
        returnDefault = 1;
        coatingType = 'NullCoating';
    end
    
    % Connect the surface definition function
    coatingDefinitionHandle = str2func(coatingType);
    returnFlag = 1;
    [returnDataStruct] = coatingDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldDisplayNames = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = currentCoating.UniqueParameters;
    end
end

