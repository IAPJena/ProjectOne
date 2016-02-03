function [ orthogonalGaussianBeamSet ] = fromQParametersToOrthogonalGaussianBeamSet( ...
        qxArray,qyArray,centralRayPosition,centralRayDirection,...
        centralRayWavelength,localXDirection,localYDirection )
%FROMQPARAMETERSTOGAUSSIANBEAM Compute the gaussian beam from its complex q
% parameters        
% The code is also vectorized. The gaussian beam array could be computed
% from multiple inputs.
% qxArray,qyArray: Size 1xN for N gaussian beams
% centralRayPosition,centralRayDirection,centralRayWavelength,
% localXDirection,localYDirection: Size 3xN for N gaussian beams

% all  inputs are supposed to be of the same size
wavLen = centralRayWavelength;
distanceFromWaistInX = -real(qxArray);
distanceFromWaistInY = -real(qyArray);
if distanceFromWaistInX ~= distanceFromWaistInY
    disp(['Error: Waist shall be at the same position for both x and y ',...
        'directions. That is -real(qx) == -real(qy) ']);
    orthogonalGaussianBeamSet = NaN;
    return;
else
    distanceFromWaist = distanceFromWaistInY;
end

invalidWaistPositionIndices = (distanceFromWaistInX ~= distanceFromWaistInY);
distanceFromWaist = distanceFromWaistInY;
waistRadiusInX = sqrt(-wavLen./(pi*imag(1./qxArray)));
waistRadiusInY = sqrt(-wavLen./(pi*imag(1./qyArray)));
peakAmplitude = 1;
orthogonalGaussianBeamSet = ScalarGaussianBeamSet(centralRayPosition,centralRayDirection,...
    centralRayWavelength,waistRadiusInX,waistRadiusInY,distanceFromWaist,...
    peakAmplitude,localXDirection,localYDirection);
orthogonalGaussianBeamSet(invalidWaistPositionIndices) = NaN;
end

