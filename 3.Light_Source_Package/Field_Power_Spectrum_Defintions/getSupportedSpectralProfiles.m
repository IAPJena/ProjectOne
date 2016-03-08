function [ fullNames,dispNames ] = getSupportedSpectralProfiles(index)
    %GetSupportedSpectralProfiles Summary of this function goes here
    %   Detailed explanation goes here
    fullNames = {'SingleWavelengthPowerSpectrum','GaussianPowerSpectrum','HomogenousPowerSpectrum'};
    dispNames = {'Single Wavelength','Gaussian Power Spectrum','Homogenous Power Spectrum'};
    
    if nargin == 0
        
    elseif index ~= 0
        fullNames = fullNames{index};
        dispNames = dispNames{index};
    end
end