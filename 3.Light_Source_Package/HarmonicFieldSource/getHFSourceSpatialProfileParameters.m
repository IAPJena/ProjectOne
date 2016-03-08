function [ fieldNames,fieldFormat,uniqueParamStruct,fieldDisplayNames ] = getHFSourceSpatialProfileParameters( variableInputArgument )
    %GETSPATIALPROFILEPARAMETERS returns the fieldName,fieldType and
    %spatialProfileParameter struct.
    % variableInputArgument:
    % 1. Struct/object --> inputHarmonicFieldSource
    % 2. Number/char --> profileType
    
    if nargin == 0
        returnDefault = 1;
        spatialProfileType = 1;% 'PlaneProfile';
    elseif isHarmonicFieldSource(variableInputArgument)
        inputHarmonicFieldSource = variableInputArgument;
        returnDefault = 0;
        spatialProfileType = inputHarmonicFieldSource.SpatialProfileType;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        [found,index] = ismember(variableInputArgument,getSupportedSpatialProfiles);
        if found
            spatialProfileType = index;
        else
            disp('Error: Invalid input to getSpatialProfileParameters. So it is just ignored.');
            returnDefault = 1;
            spatialProfileType = 1; % 'PlaneProfile';
        end
    elseif isnumeric(variableInputArgument)
        returnDefault = 1;
        spatialProfileType = variableInputArgument;
    else
        disp('Error: Invalid input to getSpatialProfileParameters. So it is just ignored.');
        returnDefault = 1;
        spatialProfileType = 1; % 'PlaneProfile';
    end
    % Connect the surface definition function
    spatialDefinitionHandle = str2func(getSupportedSpatialProfiles(spatialProfileType));
    returnFlag = 1;
    [returnDataStruct] = spatialDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldDisplayNames = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = inputHarmonicFieldSource.SpatialProfileParameter;
    end
end

