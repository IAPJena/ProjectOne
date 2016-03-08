function [ fullNames,dispNames  ] = getSupportedPolarizationProfiles(index)
    %GetSupportedpolarizationProfiles.m Summary of this function goes here
    %   Detailed explanation goes here
    fullNames = {'LinearPolarization','CircularPolarization','JonesVectorPolarization','RadialPolarization','AzimuthalPolarization'};
    dispNames = {'Linear Polarization','Circular Polarization','Jones Vector Polarization','RadialPolarization','Azimuthal Polarization'};
    
    if nargin == 0
        
    elseif index ~= 0
        fullNames = fullNames{index};
        dispNames = dispNames{index};
    end    
end