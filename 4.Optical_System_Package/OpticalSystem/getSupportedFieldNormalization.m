function [ fullNames,shortNames  ] = getSupportedFieldNormalization(index)
    %GETSUPPORTEDFIELDNORMALIZATION Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'Rectangular','Radial'};
    fullNames = {'Rectangular','Radial'};
     if nargin == 1
       shortNames = shortNames{index}; 
       fullNames = fullNames{index};
    end       
end

