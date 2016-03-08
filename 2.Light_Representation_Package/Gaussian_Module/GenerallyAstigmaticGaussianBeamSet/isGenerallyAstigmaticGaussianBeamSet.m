function [ isGenerallyAstigmatic ] = isGenerallyAstigmaticGaussianBeamSet( gaussianBeamSet )
    %ISGENERALLYASTIGMATICGAUSSIANBEAMSET Summary of this function goes here
    %   Detailed explanation goes here
    
    isGenerallyAstigmatic = 0;
    if isstruct(gaussianBeamSet)
        if isfield(gaussianBeamSet,'ClassName') && strcmpi(gaussianBeamSet.ClassName,'GenerallyAstigmaticGaussianBeamSet')
           isGenerallyAstigmatic = 1; 
        end
    else
        if strcmpi(class(gaussianBeamSet),'GenerallyAstigmaticGaussianBeamSet')
            isGenerallyAstigmatic = 1; 
        end
    end
end

