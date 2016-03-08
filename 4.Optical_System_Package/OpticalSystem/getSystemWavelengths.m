function [ wavelength, weight ] = getSystemWavelengths( optSystem,indices,returnInSIUnit )
    %GETSYSTEMWAVELENGTH returns the system wavelength with corresponding
    %weight for given index. If index is not given or == 0, then all
    %wavelengths in the wavelength matrix will be returned.
    
    if nargin < 2
        indices = 0;
    end
    if nargin < 3
        returnInSIUnit = 1;
    end
    wavelengthMatrix = optSystem.WavelengthMatrix;
    if returnInSIUnit
        unitFactor = getWavelengthUnitFactor(optSystem);
    else
        unitFactor = 1;
    end
    if length(indices) == 1 && indices == 0
        wavelength = (wavelengthMatrix(:,1))'*unitFactor;
        weight = (wavelengthMatrix(:,2))';
    else
        wavelength = (wavelengthMatrix(indices,1))'*unitFactor;
        weight = (wavelengthMatrix(indices,2))';
    end
    
end

