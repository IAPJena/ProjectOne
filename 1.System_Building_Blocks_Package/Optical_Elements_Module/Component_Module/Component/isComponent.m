function [ isComponent ] = isComponent( currentComponent )
    %ISComponent Summary of this function goes here
    %   Detailed explanation goes here
    isComponent = 0;
    if isstruct(currentComponent)
        if isfield(currentComponent,'ClassName') && strcmpi(currentComponent.ClassName,'Component')
           isComponent = 1; 
        end
    else
        if strcmpi(class(currentComponent),'Component')
            isComponent = 1; 
        end
    end
    
end

