function [ fieldNames,fieldFormat,uniqueParamStruct,fieldDisplayNames ] = getHFSourcePolarizationProfileParameters( variableInputArgument )
    %getPolarizationProfileParameters returns the fieldName,fieldType and
    %polarizationProfileParameter struct.
    % variableInputArgument:
    % 1. Struct/object --> inputHarmonicFieldSource
    % 2. Char --> profileType
    if nargin == 0
        returnDefault = 1;
        polarizationProfileType = 1; %'LinearPolarization';
    elseif isHarmonicFieldSource(variableInputArgument)
        inputHarmonicFieldSource = variableInputArgument;
        returnDefault = 0;
        polarizationProfileType = inputHarmonicFieldSource.PolarizationProfileType;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        [found,index] = ismember(variableInputArgument,getSupportedPolarizationProfiles);
        if found
            polarizationProfileType = index;
        else
            disp('Error: Invalid input to getpolarizationProfileParameters. So it is just ignored.');
            returnDefault = 1;
            polarizationProfileType = 1; % 'LinearPolarization';
        end
    elseif isnumeric(variableInputArgument)
        returnDefault = 1;
        polarizationProfileType = variableInputArgument;
    else
        disp('Error: Invalid input to getpolarizationProfileParameters. So it is just ignored.');
        returnDefault = 1;
        polarizationProfileType = 1; %'LinearPolarization';
    end
    
    % Connect the profile definition function
    polarizationProfileDefinitionHandle = str2func(getSupportedPolarizationProfiles(polarizationProfileType));
    returnFlag = 1;
    
    [returnDataStruct] = polarizationProfileDefinitionHandle(returnFlag);
    
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    fieldDisplayNames = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = inputHarmonicFieldSource.PolarizationProfileParameter;
    end
end

