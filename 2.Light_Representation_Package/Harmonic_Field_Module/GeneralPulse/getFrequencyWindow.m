function [ freqWindow ] = getFrequencyWindow( generalPulse )
%GETFREQUENCYWINDOW Summary of this function goes here
%   Detailed explanation goes here
c = 299792458;
wavLenVector = [generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray.Wavelength];
freqVector = c./wavLenVector;
freqWindow = max(freqVector)-min(freqVector);
end

