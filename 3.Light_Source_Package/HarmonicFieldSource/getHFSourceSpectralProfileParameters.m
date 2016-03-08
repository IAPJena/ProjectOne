function [ fieldNames,fieldFormat,uniqueParamStruct,fieldNamesDisplay ] = getHFSourceSpectralProfileParameters( variableInputArgument )
    %getSpectralProfileParameters returns the fieldName,fieldType and
    %SpectralProfileParameter struct.
    % variableInputArgument:
    % 1. Struct/object --> inputHarmonicFieldSource
    % 2. Char --> profileType
    if nargin == 0
        returnDefault = 1;
        spectralProfileType = 1; %'GaussianPowerSpectrum';
    elseif isHarmonicFieldSource(variableInputArgument)
        inputHarmonicFieldSource = variableInputArgument;
        returnDefault = 0;
        spectralProfileType = inputHarmonicFieldSource.SpectralProfileType;
    elseif ischar(variableInputArgument)
        returnDefault = 1;
        
        [found,index] = ismember(variableInputArgument,getSupportedSpectralProfiles);
        if found
            spectralProfileType = index;
        else
            disp('Error: Invalid input to getSpectralProfileParameters. So it is just ignored.');
            returnDefault = 1;
            spectralProfileType = 1; % ''GaussianPowerSpectrum';
        end
        
    elseif isnumeric(variableInputArgument)
        returnDefault = 1;
        spectralProfileType = variableInputArgument;
    else
        disp('Error: Invalid input to getSpectralProfileParameters. So it is just ignored.');
        returnDefault = 1;
        spectralProfileType = 1; %'GaussianPowerSpectrum';
    end
    % Connect the profile definition function
    spectralProfileDefinitionHandle = str2func(getSupportedSpectralProfiles(spectralProfileType));
    returnFlag = 1;
    [returnDataStruct] = spectralProfileDefinitionHandle(returnFlag);
    fieldNames = returnDataStruct.UniqueParametersStructFieldNames;
    fieldNamesDisplay = returnDataStruct.UniqueParametersStructFieldDisplayNames;
    fieldFormat = returnDataStruct.UniqueParametersStructFieldFormats;
    defaultUniqueParamStruct = returnDataStruct.DefaultUniqueParametersStruct;
    
    if returnDefault
        uniqueParamStruct = defaultUniqueParamStruct;
    else
        uniqueParamStruct = inputHarmonicFieldSource.SpectralProfileParameter;
    end
end

