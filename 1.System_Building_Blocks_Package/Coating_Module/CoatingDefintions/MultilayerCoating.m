function [ returnDataStruct] = MultilayerCoating(returnFlag,coatingParameters,inputDataStruct)
    % MultilayerCoating: A user defined function for multlayer coating. The function returns
    % differnt parameters when requested by the main program. It follows the common format
    % used for defining user defined coating.
    % coatingParameters = values of {'GlassArray','Thickness','ReferenceWavelength','RelativeThickness','UseInReverse'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Coating specific 'UniqueCoatingParameters' table field names
    % and initial values in Coating Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the Jones matrix elements for given input parameters
    %   inputDataStruct:
    %       inputDataStruct.Wavelength
    %       inputDataStruct.IncidenceAngleInDeg
    %       inputDataStruct.IndexBefore
    %       inputDataStruct.IndexAfter
    %   returnDataStruct:
    %       returnDataStruct.AmplitudeTransmissionMatrix,
    %       returnDataStruct.AmplitudeReflectionMatrix,
    %       returnDataStruct.PowerTransmissionMatrix,
    %       returnDataStruct.PowerReflectionMatrix,
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 03,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input values
    if nargin < 1
        disp(['Error: The function MultilayerCoating() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 2
            disp(['Error: The function MultilayerCoating() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 2
            disp(['Error: The function MultilayerCoating() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    %%
    switch returnFlag(1)
        case 1 % Return the field names and initial values of coatingParameters
            returnData1 = {'GlassArray','Thickness','ReferenceWavelength','RelativeThickness','UseInReverse'};  % FieldNames
            returnData2 = {'Glass','numeric','numeric','logical','logical'}; % FieldTypes
            
            defaultCoatingParameter = struct();
            defaultCoatingParameter.GlassArray = Glass;
            defaultCoatingParameter.Thickness = 0;
            defaultCoatingParameter.ReferenceWavelength = 0.55*10^-6;
            defaultCoatingParameter.RelativeThickness = 0;
            defaultCoatingParameter.UseInReverse = 0;
            returnData3 = defaultCoatingParameter; % DefaultCoatingParameter
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
            
        case 2 % Return the Jones Matrices
            wavLen = inputDataStruct.Wavelength;
            incAngle = inputDataStruct.IncidenceAngleInDeg;
            indexBefore = inputDataStruct.IndexBefore;
            indexAfter =  inputDataStruct.IndexAfter;
            
            nRayAngle = size(incAngle,2);
            nRayWav = size(wavLen,2);
            if nRayAngle == 1
                nRay = nRayWav;
                incAngle = repmat(incAngle,[1,nRay]);
            elseif nRayWav == 1
                nRay = nRayAngle;
                wavLen = repmat(wavLen,[1,nRay]);
            elseif nRayAngle == nRayWav % Both wavLen and incAngle for all rays given
                nRay = nRayAngle;
            else
                disp(['Error: The size of Incident Angle and Wavelength should '...
                    'be equal or one of them should be 1.']);
                returnDataStruct = NaN;
                return;
            end
            
            glassArray = coatingParameters.GlassArray;
            thicknessArray = coatingParameters.Thickness;
            relativeThicknessFlag = coatingParameters.RelativeThickness;
            reverse = coatingParameters.UseInReverse;
            wavLen0 = coatingParameters.ReferenceWavelength;
            
            % change relative thickness to absolute thickness
            relativeThicknessIndices = find(relativeThicknessFlag);
            absoluteThickness = thicknessArray;
            
            n0 = getRefractiveIndex(glassArray(relativeThicknessIndices),wavLen0);
            absoluteThickness(relativeThicknessIndices) = ...
                convertRelativeToActualThickness(thicknessArray(relativeThicknessIndices),n0,wavLen0);
            
            refIndexAll = getRefractiveIndex(glassArray,wavLen);
            thicknessAll = absoluteThickness;
            
            if reverse
                refIndexAll = flipud(refIndexAll);
                thicknessAll = flipud(thicknessAll);
            end
            
            wavLenInUm = wavLen/10^-6;
            ns = indexBefore;
            nc = indexAfter;
            
            [ampTs,ampRs,powTs,powRs]=computeMultilayerFresnelsCoefficients...
                (refIndexAll,thicknessAll,'TE',wavLenInUm,incAngle,ns,nc);
            [ampTp,ampRp,powTp,powRp]=computeMultilayerFresnelsCoefficients...
                (refIndexAll,thicknessAll,'TM',wavLenInUm,incAngle,ns,nc);
            
            ampTransJonesMatrix(1,1,:) = ampTs; ampTransJonesMatrix(1,2,:) = 0;
            ampTransJonesMatrix(2,1,:) = 0; ampTransJonesMatrix(2,2,:) = ampTp;
            
            ampRefJonesMatrix(1,1,:) = ampRs; ampRefJonesMatrix(1,2,:) = 0;
            ampRefJonesMatrix(2,1,:) = 0; ampRefJonesMatrix(2,2,:) = ampRp;
            
            powTransJonesMatrix(1,1,:) = powTs; powTransJonesMatrix(1,2,:) = 0;
            powTransJonesMatrix(2,1,:) = 0; powTransJonesMatrix(2,2,:) = powTp;
            
            powRefJonesMatrix(1,1,:) = powRs; powRefJonesMatrix(1,2,:) = 0;
            powRefJonesMatrix(2,1,:) = 0; powRefJonesMatrix(2,2,:) = powRp;
            
            returnDataStruct.AmplitudeTransmissionMatrix = ampTransJonesMatrix; % Amplitude transmission
            returnDataStruct.AmplitudeReflectionMatrix = ampRefJonesMatrix; % Amplitude reflection
            returnDataStruct.PowerTransmissionMatrix = powTransJonesMatrix; % Power transmission
            returnDataStruct.PowerReflectionMatrix = powRefJonesMatrix; % Power reflection 
    end
end

