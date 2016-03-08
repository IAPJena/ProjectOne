function [ propagatedGenerallyAstigmaticGaussianBeamSet ] = ...
        FreeSpacePropagator_GaussianBeamSet(inputGaussianBeamSet,...
        propagationDistance )
    %FreeSpacePropagator_GaussianBeamSet Used to compute free space
    %propagation of simply astigmatic or even generally astigmatic gaussian
    %beam using the complex ray tracing method.
    % Returns the generally astigmatic gussian beam
    
    if nargin < 1
        disp(['Error: The function FreeSpacePropagator_GaussianBeamSet',...
            ' requires atleast one input argument inputGaussianBeamSet.']);
        propagatedGenerallyAstigmaticGaussianBeamSet = NaN;
        return;
    end
    if nargin < 2
        propagationDistance = 0;
    end
    
    if isGaussianBeamSet(inputGaussianBeamSet)
        % Do nothing
    else
        disp(['Error: Invalid input to FreeSpacePropagator_GaussianBeamSet.',...
            'The first argument should be GaussianBeamSet.']);
    end
    
    % Extract the ray bundles from the gaussian beam set
    [ gaussianBeamRayBundle ] = getGaussianBeamRayBundle( inputGaussianBeamSet );
    
    % Propagate the ray bundle
    [ propagatedGaussianBeamSetRayBundle ] = FreeSpacePropagator_ScalarRayBundle(...
        gaussianBeamRayBundle,propagationDistance );
    
    % Convert the propagated ray bundle back to gaussian beam set
    totalPathLengths = propagationDistance;
    [ propagatedGenerallyAstigmaticGaussianBeamSet ] = convertRayBundlesToGenerallyAstigmaticGaussianBeamSet(...
        propagatedGaussianBeamSetRayBundle,totalPathLengths );
end

