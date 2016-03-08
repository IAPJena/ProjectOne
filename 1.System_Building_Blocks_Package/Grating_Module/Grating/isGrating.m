function [ isGrating ] = isGrating( currentisGrating )
    %isGrating Summary of this function goes here
    %   Detailed explanation goes here
    isGrating = 0;
    if isstruct(currentisGrating)
        if isfield(currentisGrating,'ClassName') && strcmpi(currentisGrating.ClassName,'Grating')
           isGrating = 1; 
        end
    else
        if strcmpi(class(currentisGrating),'Grating')
            isGrating = 1; 
        end
    end
    
end

