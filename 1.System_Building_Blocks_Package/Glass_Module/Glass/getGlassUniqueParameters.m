function [fieldNames,fieldFormat,uniqueParamStruct,fieldDisplayNames] = ...
        getGlassUniqueParameters( variableInputArgument )
    %getGlassUniqueParameters Returns the field names, formats, and current
    %struct of all unique parameters which are specific to this glass type
    % Inputs:
    % variableInputArgument:
    %       1. Struct/object --> currentGlass
    %       2. Char --> GlassType
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
        glassType = 'IdealNonDispersive';
    elseif isGlass(variableInputArgument)
        currentGlass = variableInputArgument;
        returnDefault = 0;
        glassType = currentGlass.Type;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        glassType = variableInputArgument;
    else
        disp('Error: Invalid input to getGlassUniqueParameters. So it is just ignored.');
        returnDefault = 1;
        glassType = 'IdealNonDispersive';
    end
    
    % Connect the surface definition function
    glassDefinitionHandle = str2func(glassType);
    returnFlag = 1;
    [returnDataStruct] = glassDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldDisplayNames = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = currentGlass.UniqueParameters;
    end
end

