function [ chirpedPulse ] = addSpatialChirp( generalInputPulse,spatialChirpFactor )
%addSpatialChirp shifts each spectral component by given spatialChirpFactor 
% spatialChirpFactor given in m/Hz

c = 299792458;
harmonicFieldSet = generalInputPulse.PulseHarmonicFieldSet;
harmonicFieldArray = harmonicFieldSet.HarmonicFieldArray;
nSpectralSample = size(harmonicFieldArray,2);
centralFreqIndex = harmonicFieldSet.ReferenceFieldIndex;
centralFreq = c/(harmonicFieldArray(centralFreqIndex).Wavelength);
% newHarmonicFieldArray(nSpectralSample) = HarmonicField;
for ff = 1:nSpectralSample
    oldCenter = harmonicFieldArray(ff).Center;
    currentFreq = c/(harmonicFieldArray(ff).Wavelength);
    lateralShift = spatialChirpFactor*(currentFreq-centralFreq);
    
    harmonicFieldArray(ff).Center = oldCenter + lateralShift;
end
newHarmonicFieldSet = HarmonicFieldSet(harmonicFieldArray);

newDir = generalInputPulse.Direction;
chirpedPulse = GeneralPulse(newHarmonicFieldSet,newDir);
end

