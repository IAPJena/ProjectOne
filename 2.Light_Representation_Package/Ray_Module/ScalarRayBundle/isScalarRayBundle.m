function [ isScalarRayBundle ] = isScalarRayBundle( currentScalarRayBundle )
    %ISScalarRay Summary of this function goes here
    %   Detailed explanation goes here
    isScalarRayBundle = 0;
    if isstruct(currentScalarRayBundle)
        if isfield(currentScalarRayBundle,'ClassName') && strcmpi(currentScalarRayBundle.ClassName,'ScalarRayBundle')
           isScalarRayBundle = 1; 
        end
    else
        if strcmpi(class(currentScalarRayBundle),'ScalarRayBundle')
            isScalarRayBundle = 1; 
        end
    end
    
end

