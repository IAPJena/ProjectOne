function [ wavUnitFactor, wavUnitText] = getWavelengthUnitFactor( optSystem )
    %GETWAVELENGTHUNITFACTOR returns the factor for unit used for wave
    %length in the system
    
    [ fullNames,shortNames,conversionFactor  ] = getSupportedWavelengthUnits();
    wavelengthUnitIndex = optSystem.WavelengthUnit;
    wavUnitText = fullNames{wavelengthUnitIndex};
    wavUnitFactor = conversionFactor(wavelengthUnitIndex);
end

