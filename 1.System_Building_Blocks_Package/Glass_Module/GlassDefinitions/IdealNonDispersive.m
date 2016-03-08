function [ returnDataStruct] = IdealNonDispersive(returnFlag,glassParameters,inputDataStruct)
    % IdealNonDispersive Defn of glass with fixed index.
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined glass.
    % glassParameters = values of {'RefractiveIndex','ReferenceWavelength'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Glass specific 'UniqueGlassParameters' table field names
    % and initial values in Glass Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2:  Return the refractive index of given derivative order
    %   inputDataStruct:
    %       inputDataStruct.Wavelength
    %       inputDataStruct.DerivativeOrder
    %   returnDataStruct:
    %       returnDataStruct.RefractiveIndex,
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 07,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input values
    if nargin < 1
        disp(['Error: The function IdealNonDispersive() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 2
            disp(['Error: The function IdealNonDispersive() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 2
            disp(['Error: The function IdealNonDispersive() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    %%
    switch returnFlag(1)
        case 1 % Return the field names and initial values of glassParameters
            returnData1 = {'RefractiveIndex','ReferenceWavelength'};
            returnData1_Disp  = {'Refractive Index','Reference Wavelength'};
            returnData2 = {'numeric','numeric'};
            defaultGlassParameter = struct();
            defaultGlassParameter.RefractiveIndex = 1;
            defaultGlassParameter.ReferenceWavelength = 0.55*10^-6;
            returnData3 = defaultGlassParameter;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Return the refractive index of given derivative order
            wavelength = inputDataStruct.Wavelength;
            derivativeOrder =   inputDataStruct.DerivativeOrder;
            
            nWav = size(wavelength,2);
            %refWavLen = glassParameters.ReferenceWavelength;
            if derivativeOrder == 0
                n = glassParameters.RefractiveIndex;
            else
                n = 0;
            end
            % constant refractive index for all wavelengths
            refractiveIndex = n*ones(1,nWav); % refractive index
            returnDataStruct.RefractiveIndex = refractiveIndex;
    end
end

