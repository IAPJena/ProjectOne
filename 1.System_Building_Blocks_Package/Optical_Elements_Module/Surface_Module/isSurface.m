function [ isSurface ] = isSurface( currentSurface )
    %ISSurface Summary of this function goes here
    %   Detailed explanation goes here
    isSurface  = zeros(size(currentSurface));
    nSurface = length(currentSurface);
    for kk = 1:nSurface
        if isstruct(currentSurface(kk))
            if isfield(currentSurface(kk),'ClassName') && strcmpi(currentSurface(kk).ClassName,'Surface')
                isSurface(kk) = 1;
            end
        else
            if strcmpi(class(currentSurface(kk)),'Surface')
                isSurface(kk) = 1;
            end
        end
    end
    isSurface = min(isSurface);
end

