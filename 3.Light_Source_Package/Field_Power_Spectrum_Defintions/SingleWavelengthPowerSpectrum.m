function [ returnDataStruct] = SingleWavelengthPowerSpectrum(returnFlag,powerSpectrumParameters,inputDataStruct)
    % SingleWavelengthPowerSpectrum A user defined function for single wavelength power spectrum
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined spectral profiles.
    % powerSpectrumParameters = values of {'Wavelength'}
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
        disp(['Error: The function HomogenousPowerSpectrum() needs atleast one argument',...
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
            returnData = SingleWavelengthPowerSpectrum(retF);
            powerSpectrumParameters = returnData.DefaultUniqueParametersStruct;
        else
            disp(['Error: The function HomogenousPowerSpectrum() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of powerSpectrumParameters
            returnData1 = {'Wavelength'};
            returnData1_Disp = {'Wavelength'};
            returnData2 = {'numeric'};
            spectralParametersStruct = struct();
            spectralParametersStruct.Wavelength = 550*10^-9;
            returnData3 = spectralParametersStruct;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Return the spectral profile as matrix of Wavelength-intensity
            centralWavLen = powerSpectrumParameters.Wavelength;
            
            wavLenVector = centralWavLen;
            intVector = 1;
            
            returnDataStruct.IntensityVector = intVector;
            returnDataStruct.PhaseVector = intVector*0;
            returnDataStruct.WavelengthVector = wavLenVector;
    end
end