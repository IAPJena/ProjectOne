function [ fullNames,shortNames  ] = getSupportedFieldTypes(index)
    %GETSUPPORTEDFIELDTYPES Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'ObjectHeight','Angle'};
    fullNames = {'ObjectHeight','Angle'}; 
    if nargin == 1
       shortNames = shortNames{index}; 
       fullNames = fullNames{index};
    end
end

