function [ finalHarmonicField ] = SPWPropagator( initialHarmonicField,...
        propagationDistance,givenFieldIndex)
    %SPWPropagator computes the SPW Propagator
    % Formulas are taken from VirtualLab Manual and Lecture notes
    
    Z = propagationDistance;
    if nargin < 3
        givenFieldIndex = 0;
    end
    nHarmonicFields = (initialHarmonicField.NumberOfHarmonicFields);
    allWavelength = initialHarmonicField.Wavelength;
    propagatedHarmonicField = initialHarmonicField;
    
    [ harmonicFieldSetIn2ndDomain] = computeFieldIFFT(initialHarmonicField);
    % All fields are in K domain
    ExInk = squeeze(harmonicFieldSetIn2ndDomain.ComplexAmplitude(:,:,1,:)); % 3rd dim for different fields in the set
    EyInk = squeeze(harmonicFieldSetIn2ndDomain.ComplexAmplitude(:,:,2,:)); % 3rd dim for different fields in the set
    nx = size(EyInk,2);
    ny = size(EyInk,1);
    Nkxy = [nx;ny];
    dk = harmonicFieldSetIn2ndDomain.SamplingDistance;
    centerXY = harmonicFieldSetIn2ndDomain.Center;
    [kxlin,kylin] = generateSamplingGridVectors(Nkxy ,dk, centerXY);
    if givenFieldIndex
        [Kx,Ky] = meshgrid(kxlin(:,:,givenFieldIndex),kylin(:,:,givenFieldIndex));
        Kz = sqrt((2*pi/allWavelength(givenFieldIndex)).^2 - Kx.^2 - Ky.^2);
        ExFinal = computeFFT2(ExInk(:,:,givenFieldIndex).*exp(1i*Kz*Z),dk);
        EyFinal = computeFFT2(EyInk(:,:,givenFieldIndex).*exp(1i*Kz*Z),dk);
        propagatedComplexAmplitude = cat(3,permute(ExFinal,[1,2,4,3]),permute(EyFinal,[1,2,4,3]));
        propagatedHarmonicField.ComplexAmplitude(:,:,:,givenFieldIndex) = propagatedComplexAmplitude;
    else
        for kk = 1:nHarmonicFields
            [Kx,Ky] = meshgrid(kxlin(:,:,kk),kylin(:,:,kk));
            Kz = sqrt((2*pi/allWavelength(kk)).^2 - Kx.^2 - Ky.^2);
            ExFinal = computeFFT2(ExInk(:,:,kk).*exp(1i*Kz*Z),dk);
            EyFinal = computeFFT2(EyInk(:,:,kk).*exp(1i*Kz*Z),dk);
            propagatedComplexAmplitude = cat(3,permute(ExFinal,[1,2,4,3]),permute(EyFinal,[1,2,4,3]));
            propagatedHarmonicField.ComplexAmplitude(:,:,:,kk) = propagatedComplexAmplitude;
        end
    end
    finalHarmonicField = propagatedHarmonicField;
end

