function [ fullNames,shortNames ] = getSupportedSystemDefinitionTypes(index)
    %GETSUPPORTEDSYSTEMDEFINITIONTYPES Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'SurfaceBased','ComponentBased'};
    fullNames = {'SurfaceBased','ComponentBased'};    
     if nargin == 1
       shortNames = shortNames{index}; 
       fullNames = fullNames{index};
    end    
end

