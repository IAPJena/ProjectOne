function [ isaperture ] = isAperture( currentAperture )
    %ISAPERTURE Summary of this function goes here
    %   Detailed explanation goes here
    isaperture = 0;
    if isstruct(currentAperture)
        if isfield(currentAperture,'ClassName') && strcmpi(currentAperture.ClassName,'Aperture')
           isaperture = 1; 
        end
    else
        if strcmpi(class(currentAperture),'Aperture')
            isaperture = 1; 
        end
    end
    
end

