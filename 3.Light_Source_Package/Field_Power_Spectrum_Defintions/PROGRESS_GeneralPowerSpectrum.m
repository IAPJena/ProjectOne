function [ returnData1, returnData2, returnData3] = GeneralPowerSpectrum(...
    returnFlag,PowerSpectrumParameters)
%% Default input vaalues
if nargin < 2
    disp(['Error: The function GeneralPowerSpectrum() needs two arguments',...
        'return type and PowerSpectrumParameters.']);
    returnData1 = NaN;
    returnData2 = NaN;
    returnData3 = NaN;
    return;
end

%%
switch returnFlag(1)
    case 1 % Return the field names and initial values of PowerSpectrumParameters
        returnData1 = {'Wavelength','Intensity'}; 
        returnData2 = {'numeric','numeric'};  
        returnData3 = {[0],[0],[0]};
    case 2 % Return the spectral profile as matrix of Wavelength-intensity
        % NB. all memebers of spectralProfileparameters should be column
        % vector
        wavLenVector = PowerSpectrumParameters.Wavelength;
        intVector = PowerSpectrumParameters.Intensity;
        
        returnData1 = intVector;
        returnData2 = wavLenVector;  
        returnData3 = NaN;          
end
end