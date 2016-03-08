function [ isGaussianBeamSet ] = isGaussianBeamSet( gaussianBeamSet )
    %isGaussianBeamSet Summary of this function goes here
    %   Detailed explanation goes here
    isGaussianBeamSet = 0;
    if isstruct(gaussianBeamSet)
        if isfield(gaussianBeamSet,'ClassName') && strcmpi(gaussianBeamSet.ClassName,'GaussianBeamSet')
           isGaussianBeamSet = 1; 
        end
    else
        if strcmpi(class(gaussianBeamSet),'GaussianBeamSet')
            isGaussianBeamSet = 1; 
        end
    end
    
end

