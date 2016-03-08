function [ returnDataStruct] = GaussianPowerSpectrum(returnFlag,powerSpectrumParameters,inputDataStruct)
    % GaussianPowerSpectrum A user defined function for gaussian power spectrum
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined spectral profiles.
    % powerSpectrumParameters = values of {'CentralWavelength','HalfWidthHalfMaxima',
    % 'NumberOfSamplingPoints','CutoffPowerFactor'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Return the field names and initial values of powerSpectrumParameters
    % which could be used in the Source definition GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the spectral profile Wavelength and intensity vectors
    %   inputDataStruct:
    %        empty
    %   returnDataStruct:
    %       returnDataStruct.IntensityVector
    %       returnDataStruct.PhaseVector
    %       returnDataStruct.WavelengthVector
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 09,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input values
    if nargin < 1
        disp(['Error: The function GaussianPowerSpectrum() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 1
            % OK
        elseif returnFlag == 2
            % get the default parameters
            retF = 1;
            returnData = GaussianPowerSpectrum(retF);
            powerSpectrumParameters = returnData.DefaultUniqueParametersStruct;
        else
            disp(['Error: The function GaussianPowerSpectrum() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of powerSpectrumParametersers
            returnData1 = {'CentralWavelength','HalfWidthHalfMaxima',...
                'NumberOfSamplingPoints','CutoffPowerFactor'};
            returnData1_Disp = {'Central Wavelength','Half Width Half Maxima',...
                'Number Of Sampling Points','Cut off Power Factor'};
            returnData2 = {'numeric','numeric','numeric','numeric'};
            spectralParametersStruct = struct();
            spectralParametersStruct.CentralWavelength = 550*10^-9;
            spectralParametersStruct.HalfWidthHalfMaxima = 20*10^-9;
            spectralParametersStruct.NumberOfSamplingPoints = 20;
            spectralParametersStruct.CutoffPowerFactor = 0.01;
            returnData3 = spectralParametersStruct;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Return the spectral profile Wavelength and intensity vectors
            % Here we have used the same formulas from VirtualLab manual
            lambda0 = powerSpectrumParameters.CentralWavelength;
            lambdaHWHM = powerSpectrumParameters.HalfWidthHalfMaxima;
            nSampling = powerSpectrumParameters.NumberOfSamplingPoints;
            cutoffPowerFactor = powerSpectrumParameters.CutoffPowerFactor;
            
            % power spectrum is computed in frequency domain
            c = 299792458;
            omega0 = 2*pi*c/lambda0;
            omegaHWHM = -(omega0/lambda0)*lambdaHWHM;
            omegaMin = omega0 + omegaHWHM*sqrt(-log(cutoffPowerFactor)/log(2));
            omegaMax = 2*omega0 - omegaMin;
            
            lambdaMin = 2*pi*c/omegaMin;
            lambdaMax = 2*pi*c/omegaMax;
            
            % equidistance sampling in wavelength domain
            wavLenVector = (linspace(lambdaMin,lambdaMax,nSampling))';
            omegaVector =  2*pi*c./wavLenVector;
            intVector = exp(-log(2)*(omegaVector-omega0).^2/(omegaHWHM)^2);
            
            returnDataStruct.IntensityVector = intVector;
            returnDataStruct.PhaseVector = intVector*0;
            returnDataStruct.WavelengthVector = wavLenVector;
    end
end