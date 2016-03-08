% get frequency sampling Interval
    function freqSamplingInterval = getFrequencySamplingInterval(generalPulse)
        % determine the wavLenInterval
        c = 299792458;
        wavLenVector = [generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray.Wavelength];
        freqVector = c./wavLenVector;
        % compute the interval as difference
        diffFreq = diff(freqVector);
        % check if all intervals are equal
        if  range(diffFreq) < 0.01*max(freqVector) % diff b/n max and min value is below 1% of max
            freqSamplingInterval = abs(diffFreq(1));
        else
            disp('Error: The pulse needs to be sampled at equidistance frequency.');
            return;
        end
    end

