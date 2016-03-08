function [ isCoating ] = isCoating( currentCoating )
    %ISCoating Summary of this function goes here
    %   Detailed explanation goes here
    isCoating = zeros(size(currentCoating));
    nCoating = length(currentCoating);
    for kk = 1:nCoating
        if isstruct(currentCoating(kk))
            if isfield(currentCoating(kk),'ClassName') && strcmpi(currentCoating(kk).ClassName,'Coating')
                isCoating(kk) = 1;
            end
        else
            if strcmpi(class(currentCoating(kk)),'Coating')
                isCoating(kk) = 1;
            end
        end
    end
    isCoating = min(isCoating);
end

