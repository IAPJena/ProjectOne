function [ minimumWavelength ] = getMinimumWavelength( optSystem )
%getMinimumWavelength: returns the minimum wavelelngth in SI Unit (m)
    wavUnitFactor = getWavelengthUnitFactor( optSystem );
    wavLenMatrix = optSystem.WavelengthMatrix;
    if ~isempty(wavLenMatrix)        
        minimumWavelength = min(wavLenMatrix(:,1))*wavUnitFactor;
    else
        disp('Error: No wavelength matrix defined.');
        minimumWavelength = NaN;
        return;
    end
end

