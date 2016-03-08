function [  fullNames,shortNames ] = getSupportedFieldBoarderShapes(index)
    %GETSUPPORTED Summary of this function goes here
    %   Detailed explanation goes here 
    fullNames = {'Elliptical','Rectangular'};
    shortNames = {'Elliptical','Rectangular'};
    
    if nargin == 0
        
    elseif index ~= 0
        fullNames = fullNames{index};
        shortNames = shortNames{index};
    end    
end

