function [  fullNames,shortNames ] = getSupportedSmoothEdgeSizeSpecifications(index)
    %GETSUPPORTED Summary of this function goes here
    %   Detailed explanation goes here
    fullNames = {'Relative','Absolute'};
    shortNames = {'Relative','Absolute'};
    if nargin == 0
        
    elseif index ~= 0
        fullNames = fullNames{index};
        shortNames = shortNames{index};
    end    
end

