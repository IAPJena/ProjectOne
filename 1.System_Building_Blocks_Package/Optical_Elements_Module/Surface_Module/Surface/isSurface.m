function [ isSurface ] = isSurface( currentSurface )
    %ISSurface Summary of this function goes here
    %   Detailed explanation goes here
    isSurface = 0;
    if isstruct(currentSurface)
        if isfield(currentSurface,'ClassName') && strcmpi(currentSurface.ClassName,'Surface')
           isSurface = 1; 
        end
    else
        if strcmpi(class(currentSurface),'Surface')
            isSurface = 1; 
        end
    end
    
end

