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
    
    % If single harmonic field is passed then convert it to a harmonic
    % field set
    if isHarmonicField(harmonicFieldSet)
        harmonicFieldSet = HarmonicFieldSet(harmonicFieldSet);
    end
    modifiedHarmonicFieldSet = harmonicFieldSet;
    nHarmonicFields = length(harmonicFieldSet);
    for kk = 1:nHarmonicFields
        curentHarmonicField = harmonicFieldSet.HarmonicFieldArray(kk);
        oldComplexAmplitude = curentHarmonicField.ComplexAmplitude;
        sizeSampledField = size(curentHarmonicField.ComplexAmplitude);
        samplingPoints = sizeSampledField(1:2);
        samplingDistance = curentHarmonicField.SamplingDistance;
        centerXY = curentHarmonicField.Center;
        wavLen = curentHarmonicField.Wavelength;
        n = refractiveIndex;
        z = sphericalPhaseRadius;
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints,samplingDistance,centerXY);
        [x,y] = meshgrid(xlin,ylin);
        spahericalPhaseFactor = exp(1i*(2*pi*n/wavLen)*sqrt(x.^2+y.^2+z^2));
        newComplexAmplitude = oldComplexAmplitude.*repmat(spahericalPhaseFactor,1,1,2);
        curentHarmonicField.ComplexAmplitude = newComplexAmplitude;
        modifiedHarmonicFieldSet.HarmonicFieldArray(kk) = curentHarmonicField;
    end
end

