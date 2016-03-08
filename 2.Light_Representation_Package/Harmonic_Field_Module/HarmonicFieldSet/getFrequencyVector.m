function [ frequencyVector ] = getFrequencyVector( harmonicFieldSet )
    %GETFREQUENCYVECTOR returns the vector of frequency of the harmonic field
    %set
    c = 299792458;
    frequencyVector = c./[harmonicFieldSet.HarmonicFieldArray.Wavelength];
end

