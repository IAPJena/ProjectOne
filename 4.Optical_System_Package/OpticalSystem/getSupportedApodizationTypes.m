function [ fullNames,shortNames  ] = getSupportedApodizationTypes(index)
    %GETSUPPORTEDAPODIZATIONTYPE Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'None','SuperGaussian'};
    fullNames = {'None','SuperGaussian'};
     if nargin == 1
       shortNames = shortNames{index}; 
       fullNames = fullNames{index};
    end       
end

