function [ primaryWavelength ] = getPrimaryWavelength( optSystem )
%getPrimaryWavelength: returns the primary wavelelngth in SI Unit (m)
    wavUnitFactor = getWavelengthUnitFactor( optSystem );
    wavLenMatrix = optSystem.WavelengthMatrix;
    primaryWavLenIndex = optSystem.PrimaryWavelengthIndex;
    if ~isempty(wavLenMatrix)        
        primaryWavelength = wavLenMatrix(primaryWavLenIndex,1)*wavUnitFactor;
    else
        disp('Error: No wavelength matrix defined.');
        primaryWavelength = NaN;
        return;
    end
end

