function [ isGaussianPulsedBeam ] = isGaussianPulsedBeam( currentGaussianPulsedBeam )
    %ISGaussianPulsedBeam Summary of this function goes here
    %   Detailed explanation goes here
    isGaussianPulsedBeam = 0;
    if isstruct(currentGaussianPulsedBeam)
        if isfield(currentGaussianPulsedBeam,'ClassName') && strcmpi(currentGaussianPulsedBeam.ClassName,'GaussianPulsedBeam')
           isGaussianPulsedBeam = 1; 
        end
    else
        if strcmpi(class(currentGaussianPulsedBeam),'GaussianPulsedBeam')
            isGaussianPulsedBeam = 1; 
        end
    end
    
end

