function [ modifiedHarmonicFieldSet ] = computeFieldFFT( harmonicFieldSet,scale )
    %computeFieldFFT Computes forier transform using FFT algorithm
    
    % Default Input
    if nargin < 1
        % Get all catalogues from current folder
        harmonicFieldSet = HarmonicFieldSet;
    end
    if nargin < 2
        scale = [1,1];
    end
    if length(scale) == 1
        scale = repmat(scale,1,2);
    end
    
    modifiedHarmonicFieldSet = harmonicFieldSet;
    nHarmonicFields = (harmonicFieldSet.NumberOfHarmonicFields);
    deltaIn1stDomain = harmonicFieldSet.SamplingDistance(:,1);
    for kk = 1:nHarmonicFields
        oldComplexAmplitude = harmonicFieldSet.ComplexAmplitude(:,:,:,kk);
        [ ExIn2ndDomain,deltaIn2ndDomain ] = computeFFT2( oldComplexAmplitude(:,:,1),deltaIn1stDomain);
        [ EyIn2ndDomain ] = computeFFT2( oldComplexAmplitude(:,:,2),deltaIn1stDomain);
        
        newComplexAmplitude = cat(3,permute(ExIn2ndDomain,[1,2,4,3]),permute(EyIn2ndDomain,[1,2,4,3]));
        modifiedHarmonicFieldSet.ComplexAmplitude(:,:,:,kk) = newComplexAmplitude;
        modifiedHarmonicFieldSet.SamplingDistance(:,kk) = deltaIn2ndDomain; % in Spatial frequency domain
        if modifiedHarmonicFieldSet.Domain(kk) == 1
            modifiedHarmonicFieldSet.Domain(kk) = 2; % Spatial frequency domain
        else
            modifiedHarmonicFieldSet.Domain(kk) = 1; % Spatial domain
        end
    end
end

