function [ intensityVect, wavelengthVect, referenceWavelengthIndex ] = getHFSourcePowerSpectrumProfile( harmonicFieldSource )
    %GETSPECTRALPROFILE returns the power spectrum and wavelength vector
    
    spectralProfileType = harmonicFieldSource.SpectralProfileType;
    spectralProfileParameter = harmonicFieldSource.SpectralProfileParameter;
    % get the spectral profile from the corresponding
    % spectral profile function
    % Connect the spectral profile definition function
    spectralProfileDefinitionHandle = str2func(getSupportedSpectralProfiles(spectralProfileType));
    returnFlag = 2; %
    [returnDataStruct] = spectralProfileDefinitionHandle(returnFlag,spectralProfileParameter);
    intensityVect = returnDataStruct.IntensityVector ;
    wavelengthVect = returnDataStruct.WavelengthVector;
    
    referenceWavelengthIndex = floor(length(wavelengthVect)/2);
    if ~referenceWavelengthIndex
        referenceWavelengthIndex = 1;
    end
end

