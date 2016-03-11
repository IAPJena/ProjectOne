function [ fullNames,shortNames,conversionFactor  ] = getSupportedLensUnits(index)
    %GETSUPPORTEDWAVELENGTHUNITS Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'mm','cm','mt','in','um'};
    fullNames = {'Milimeter','Centimeter','Meter','Inch','Micrometer'};
    conversionFactor = [10^-3,10^-2,1,0.0254,10^-6];
    if nargin == 1
        shortNames = shortNames{index};
        fullNames = fullNames{index};
        conversionFactor = conversionFactor(index);
    end
end

