function [ lensUnitFactor,lensUnitText ] = getLensUnitFactor( optSystem )
    %GETLENSUNITFACTOR returns the factor for unit used for lens 
    % length in the system
    
    [ fullNames,shortNames,conversionFactor  ] = getSupportedLensUnits();
    lensUnitIndex = optSystem.LensUnit;
    lensUnitText = fullNames{lensUnitIndex};
    lensUnitFactor = conversionFactor(lensUnitIndex);
end

