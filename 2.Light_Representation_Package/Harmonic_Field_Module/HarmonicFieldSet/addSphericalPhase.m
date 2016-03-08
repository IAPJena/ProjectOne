function [ modifiedHarmonicFieldSet ] = addSphericalPhase( harmonicFieldSet,sphericalPhaseRadius,refractiveIndex )
    %ADDSPHERICALPHASE Adds spherical phase of given radius on the hrmonic
    %field
    
    % Default Input
    if nargin < 1
        % Get all catalogues from current folder
        harmonicFieldSet = HarmonicFieldSet;
    end
    if nargin < 2
        sphericalPhaseRadius = 10^-3;
    end
    if nargin < 3
        refractiveIndex = 1;
    end

    modifiedHarmonicFieldSet = harmonicFieldSet;
    nHarmonicFields = (harmonicFieldSet.NumberOfHarmonicFields);
    for kk = 1:nHarmonicFields
        oldComplexAmplitude = harmonicFieldSet.ComplexAmplitude(:,:,:,kk);
        sizeSampledField = size(harmonicFieldSet.ComplexAmplitude);
        samplingPoints = (sizeSampledField(1:2))';
        samplingDistance = harmonicFieldSet.SamplingDistance(:,kk);
        centerXY = harmonicFieldSet.Center(:,kk);
        wavLen = harmonicFieldSet.Wavelength(kk);
        n = refractiveIndex;
        r = sphericalPhaseRadius;
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints,samplingDistance,centerXY);
        [x,y] = meshgrid(xlin,ylin);
        spahericalPhaseFactor = exp(sign(r)*1i*(2*pi*n/wavLen)*sqrt(r^2-x.^2-y.^2));
        newComplexAmplitude = oldComplexAmplitude.*repmat(spahericalPhaseFactor,1,1,2);
        modifiedHarmonicFieldSet.ComplexAmplitude = newComplexAmplitude;
    end
end

