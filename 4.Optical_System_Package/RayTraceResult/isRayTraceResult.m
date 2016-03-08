function [ isRayTraceResult ] = isRayTraceResult( currentRayTraceResult )
    %ISRayTraceResult Summary of this function goes here
    %   Detailed explanation goes here
    isRayTraceResult = 0;
    if isstruct(currentRayTraceResult)
        if isfield(currentRayTraceResult,'ClassName') && strcmpi(currentRayTraceResult.ClassName,'RayTraceResult')
           isRayTraceResult = 1; 
        end
    else
        if strcmpi(class(currentRayTraceResult),'RayTraceResult')
            isRayTraceResult = 1; 
        end
    end
    
end

