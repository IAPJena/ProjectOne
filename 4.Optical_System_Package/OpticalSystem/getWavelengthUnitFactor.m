function [ wavUnitFactor, wavUnitText, wavUnitTextShort] = getWavelengthUnitFactor( optSystem )
    %GETWAVELENGTHUNITFACTOR returns the factor for unit used for wave
    %length in the system
    
    [ fullNames,shortNames,conversionFactor  ] = getSupportedWavelengthUnits();
    wavelengthUnitIndex = optSystem.WavelengthUnit;
    wavUnitText = fullNames{wavelengthUnitIndex};
    wavUnitTextShort = shortNames{wavelengthUnitIndex};
    wavUnitFactor = conversionFactor(wavelengthUnitIndex);
end

