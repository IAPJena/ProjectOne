function [ isGlass ] = isGlass( currentGlass )
    %ISGlass Summary of this function goes here
    %   Detailed explanation goes here
    isGlass = zeros(size(currentGlass));
    nGlass = length(currentGlass);
    for kk = 1:nGlass
        if isstruct(currentGlass(kk))
            if isfield(currentGlass(kk),'ClassName') && strcmpi(currentGlass(kk).ClassName,'Glass')
                isGlass(kk) = 1;
            end
        else
            if strcmpi(class(currentGlass(kk)),'Glass')
                isGlass(kk) = 1;
            end
        end
    end
    isGlass = min(isGlass);
end

