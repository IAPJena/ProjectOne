function [fieldNames,fieldFormat,uniqueParamStruct,uniqueParamDisplayNames] =...
        getGratingUniqueParameters( variableInputArgument )
    %getGratingUniqueParameters Returns the field names, formats, and current
    %struct of all unique parameters which are specific to this Grating type
    % Inputs:
    % variableInputArgument:
    %       1. Struct/object --> currentGrating
    %       2. Char --> GratingType
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
    % Sep 17,2015   Worku, Norman G.     Original Version
    
    if nargin == 0
        returnDefault = 1;
        gratingType = 'ParallelPlaneGrating';
    elseif isGrating(variableInputArgument)
        currentGrating = variableInputArgument;
        returnDefault = 0;
        gratingType = currentGrating.Type;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        gratingType = variableInputArgument;
    else
        disp('Error: Invalid input to getGratingUniqueParameters. So it is just ignored.');
        returnDefault = 1;
        gratingType = 'ParallelPlaneGrating';
    end
    
    % Connect the surface definition function
    gratingDefinitionHandle = str2func(GetSupportedGratingTypes(gratingType));
    returnFlag = 1;
    [returnDataStruct] = gratingDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    uniqueParamDisplayNames  = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = currentGrating.UniqueParameters;
    end
end

