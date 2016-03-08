function [ modifiedHarmonicFieldSet ] = computeFieldIFFT( harmonicFieldSet )
    %computeFieldIFFT Computes inverse forier transform using FFT algorithm
    
    % Default Input
    if nargin < 1
        % Get all catalogues from current folder
        harmonicFieldSet = HarmonicFieldSet;
    end

    modifiedHarmonicFieldSet = harmonicFieldSet;
    nHarmonicFields = length(harmonicFieldSet);
    for kk = 1:nHarmonicFields
        oldComplexAmplitude = modifiedHarmonicFieldSet.ComplexAmplitude(:,:,:,kk);
        deltaIn1stDomain = modifiedHarmonicFieldSet.SamplingDistance(:,kk);
        
        
        [ ExIn2ndDomain, deltaIn2ndDomain] = computeIFFT2( oldComplexAmplitude(:,:,1),deltaIn1stDomain);
        [ EyIn2ndDomain ] = computeIFFT2( oldComplexAmplitude(:,:,2),deltaIn1stDomain);

        newComplexAmplitude = cat(3,permute(ExIn2ndDomain,[1,2,4,3]),permute(EyIn2ndDomain,[1,2,4,3]));
        modifiedHarmonicFieldSet.ComplexAmplitude(:,:,:,kk) = newComplexAmplitude;
        modifiedHarmonicFieldSet.SamplingDistance = deltaIn2ndDomain; % in Spatial  domain
        
        if modifiedHarmonicFieldSet.Domain(kk) == 1
            modifiedHarmonicFieldSet.Domain(kk) = 2; % Spatial frequency domain
        else
            modifiedHarmonicFieldSet.Domain(kk) = 1; % Spatial domain
        end
    end
end

