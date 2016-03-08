function [ maximumWavelength ] = getMaximumWavelength( optSystem )
%getMaximumWavelength: returns the maximum wavelelngth in SI Unit (m)
    wavUnitFactor = getWavelengthUnitFactor( optSystem );
    wavLenMatrix = optSystem.WavelengthMatrix;
    if ~isempty(wavLenMatrix)        
        maximumWavelength = max(wavLenMatrix(:,1))*wavUnitFactor;
    else
        disp('Error: No wavelength matrix defined.');
        maximumWavelength = NaN;
        return;
    end
end

