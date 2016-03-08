function [ returnDataStruct] = JonesVectorPolarization(returnFlag,polarizationParameters,inputDataStruct)
    % JonesVectorPolarization A user defined function for polarization given by general Jones vector
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined polarization profiles.
    % powerSpectrumParameters = values of {'Angle'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Return the field names and initial values of polarizationParameters
    % which could be used in the Source definition GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the Jones vector for the given polarization parameter
    %   inputDataStruct:
    %       inputDataStruct.xMesh
    %       inputDataStruct.yMesh
    %       inputDataStruct.BeamCenter 
    %   returnDataStruct:
    %       returnDataStruct.JonesVector
    %       returnDataStruct.PolarizationDistributionType
    %       returnDataStruct.CoordinateSystem
    
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
        disp(['Error: The function JonesVectorPolarization() needs atleast one argument',...
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
            returnData = JonesVectorPolarization(retF);
            polarizationParameters = returnData.DefaultUniqueParametersStruct;
            
            inputDataStruct = struct();
        else
            disp(['Error: The function JonesVectorPolarization() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of polarizationParameters
            returnData1 = {'RealXOrAmplitudeX','ImaginaryXOrPhaseX','RealYOrAmplitudeY','ImaginaryYOrPhaseY','Coordinate','Representation'};
            returnData1_Disp = {'Real X Or Amplitude X','Imaginary X Or Phase (deg) X','Real Y Or Amplitude Y','Imaginary Y Or Phase (deg) Y','Coordinate','Representation'};
            returnData2 = {'numeric','numeric','numeric','numeric',{'SP','XY'},{'Real_Imaginary','Amplitude_Phase'}};
            polarizationParametersStruct = struct();
            polarizationParametersStruct.RealXOrAmplitudeX = 1;
            polarizationParametersStruct.ImaginaryXOrPhaseX = 0;
            polarizationParametersStruct.RealYOrAmplitudeY = 0;
            polarizationParametersStruct.ImaginaryYOrPhaseY = 0;
            polarizationParametersStruct.Coordinate = 1; %'SP';
            polarizationParametersStruct.Representation = 1; %'Real_Imaginary';
            returnData3 = polarizationParametersStruct;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
            
        case 2 % Return the Jones vector for the given polarization parameter
            polDistributionType = 'Global';
            
            param1X = polarizationParameters.RealXOrAmplitudeX;
            param2X = polarizationParameters.ImaginaryXOrPhaseX;
            param1Y = polarizationParameters.RealYOrAmplitudeY;
            param2Y = polarizationParameters.ImaginaryYOrPhaseY;
            coordTypes = {'SP','XY'};
            coordinate = coordTypes{polarizationParameters.Coordinate};
            representation = polarizationParameters.Representation;
            
            if representation == 1 % real - imaginary
                JV = [param1X + 1i*param2X; param1Y + 1i*param2Y];
                % Normalize
                jonesVector = JV/(sqrt((abs(JV(1)))^2 + (abs(JV(2)))^2));
            elseif representation == 2 % amplitude - phase
                JV = [param1X*exp(1i*param2X*pi/180); param1Y*exp(1i*param2Y*pi/180)];
                % Normalize
                jonesVector = JV/(sqrt((abs(JV(1)))^2 + (abs(JV(2)))^2));
            else
                
            end
            
            returnDataStruct.JonesVector = jonesVector;
            returnDataStruct.PolarizationDistributionType = polDistributionType;
            returnDataStruct.CoordinateSystem = coordinate;
    end
end