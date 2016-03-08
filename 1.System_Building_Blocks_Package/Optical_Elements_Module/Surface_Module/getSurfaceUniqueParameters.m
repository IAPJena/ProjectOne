function [fieldNames,fieldDisplayNames,fieldFormat,uniqueParamStruct] = getSurfaceUniqueParameters( variableInputArgument )
    %getUniqueParameters Returns the field names, formats, and current
    %struct of all unique parameters which are specific to this surface type
    % Inputs:
    % variableInputArgument:
    %       1. Struct/object --> currentSurface
    %       2. Char/number --> surfaceType
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
        surfaceType = 1; %'Standard';
    elseif isSurface(variableInputArgument)
        currentSurface = variableInputArgument;
        returnDefault = 0;
        surfaceType = currentSurface.Type;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        
    % If the type is given as string instead of number, then find the index
    % corresponding to the type string

        supportedSurfaceTypes = GetSupportedSurfaceTypes();
        typeString = variableInputArgument;
        [isFound, foundAt] = ismember(typeString,supportedSurfaceTypes);
        if isFound
            surfaceType = foundAt;
        else
            disp(['Error: The surface type specified is not valid so the ',...
                'default Standard is used.']);
            surfaceType = 1;
        end
    
    elseif isnumeric(variableInputArgument)
        returnDefault = 1;
        surfaceType = variableInputArgument;    
    else
        disp('Error: Invalid input to getSurfaceUniqueParameters. So it is just ignored.');
        returnDefault = 1;
        surfaceType = 1; %'Standard';
    end
    
    % Connect the surface definition function
    surfaceDefinitionHandle = str2func(GetSupportedSurfaceTypes(surfaceType));
    returnFlag = 2;
    [returnDataStruct] = surfaceDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldTypes;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    fieldDisplayNames = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = currentSurface.UniqueParameters;
    end
end

