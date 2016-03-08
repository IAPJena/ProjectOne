function [ propagatedRayBundle ] = FreeSpacePropagator_ScalarRayBundle(...
        inputScalarRayBundle,propagationDistance )
    %FreeSpacePropagator_ScalarRayBundle Used to compute free space
    %propagation of scalar ray bundles using real ray tracing method.
    % The code is also vectorized for multiple propagation distance input
    
    if nargin < 1
        disp(['Error: The function FreeSpacePropagator_ScalarRayBundle',...
            ' requires atleast one input argument inputScalarRayBundle.']);
        propagatedRayBundle = NaN;
        return;
    end
    if nargin < 2
        propagationDistance = 0;
    end
    
    if isScalarRayBundle(inputScalarRayBundle)
        % Do nothing
    else
        disp(['Error: Invalid input to FreeSpacePropagator_ScalarRayBundle.',...
            'The first argument should be scalar ray bundle.']);
    end
    
    nPropagationDistance = length(propagationDistance);
    % The output raybundle will have parameters with length of
    % nPropagationDistance*the input ray bundle so that the final ray bundle
    % will have [Param after prop dist 1, Param for prop dist 2,...]
    tempPosition = [];
    for kk = 1:nPropagationDistance
        positionAfterPropgation = inputScalarRayBundle.Position + ...
            propagationDistance(kk)*inputScalarRayBundle.Direction;
        tempPosition = cat(2,tempPosition,positionAfterPropgation);
    end
    
    tempRayBundle.Position = tempPosition;
    tempRayBundle.Direction = repmat(inputScalarRayBundle.Direction,[1,nPropagationDistance]);
    tempRayBundle.Wavelength = repmat(inputScalarRayBundle.Wavelength,[1,nPropagationDistance]);
    
    propagatedRayBundle = tempRayBundle;
end

