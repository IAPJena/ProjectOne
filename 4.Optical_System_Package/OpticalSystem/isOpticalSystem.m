function [ isOpticalSystem ] = isOpticalSystem( currentOpticalSystem )
    %ISOpticalSystem Summary of this function goes here
    %   Detailed explanation goes here
    isOpticalSystem = 0;
    if isstruct(currentOpticalSystem)
        if isfield(currentOpticalSystem,'ClassName') && strcmpi(currentOpticalSystem.ClassName,'OpticalSystem')
           isOpticalSystem = 1; 
        end
    else
        if strcmpi(class(currentOpticalSystem),'OpticalSystem')
            isOpticalSystem = 1; 
        end
    end
    
end

