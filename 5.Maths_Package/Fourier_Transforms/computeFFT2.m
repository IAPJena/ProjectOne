function [ complexFFTofE,deltaInFrequency ] = computeFFT2( complexEin,deltaInSpatial )
    %COMPUTEFFT2 returns the FFT of complexE in 2d
    % Input:
    %   complexEin : A complex matrix (2D). It can also handle 1D vector
    %   deltaInSpatial : The sample spacing in spatial domain (2 x 1 vector)
    
    % Output:
    %   complexFFTofE : Th resulting field in the fourier space
    %   deltaInFrequency : The sample spacing in freq domain (2 x 1 vector)
    
    % Source: Schmidt Numerical Simulation of Wave Optical Propagation
    
    % Input validation and default input assignment
    if nargin < 1
        disp('Error: The function computeFFT needs atleast the input field.');
        complexFFTofE = NaN;
        deltaInFrequency = NaN;
        return;
    end
    inputDimSize = (size(complexEin))';
    
    if nargin < 2
        % Default input field size = 1 so the spacing will be
        deltaInSpatial = 1./inputDimSize;
    end
    sizeInSpatial = deltaInSpatial.*inputDimSize;
    complexFFTofE = fftshift(fft2(fftshift(complexEin)))*prod(deltaInSpatial)*(1/(2*pi));
    deltaInFrequency =  2*pi./(sizeInSpatial);
%     % Correction according to Manuel and Herbert
%     deltaInFrequency = deltaInFrequency.*(inputDimSize-1)./inputDimSize;
end

