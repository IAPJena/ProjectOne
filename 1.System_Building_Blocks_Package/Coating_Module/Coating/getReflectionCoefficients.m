function [ampRs,ampRp,powRs,powRp,jonesRefMatrix] = getReflectionCoefficients...
        (coating,wavLenInUm,incAngleInDeg,indexBefore,indexAfter,referenceWavLenInUm)
    % getReflectionCoefficients: Computes the amplitude and power coefficients of
    % reflection using general Fresnel's equations. The function is vectorized so
    % it can work on multiple sets of inputs once at the same time. i.e incAngle
    % or wavLen becomes array)
    % Inputs:
    %   (coating,wavLen,incAngleInDeg,substrateGlass,claddingGlass,referenceWavLen)
    % Outputs:
    %   [ampRs,ampRp,powRs,powRp,jonesRefMatrix]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    % Jun 17,2015   Worku, Norman G.     Support the user defined coating
    %                                    definitions
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    nRayAngle = size(incAngleInDeg,2);
    nRayWav = size(wavLenInUm,2);
    if nRayAngle == 1
        nRay = nRayWav;
        incAngleInDeg = repmat(incAngleInDeg,[1,nRay]);
    elseif nRayWav == 1
        nRay = nRayAngle;
        wavLenInUm = repmat(wavLenInUm,[1,nRay]);
    elseif nRayAngle == nRayWav % Both wavLen and incAngle for all rays given
        nRay = nRayAngle;
    else
        disp(['Error: The size of Incident Angle and Wavelength should '...
            'be equal or one of them should be 1.']);
        return;
    end
    
    coatingType = coating.Type;
    coatingParameters = coating.UniqueParameters;
    coatingDefinitionHandle = str2func(coatingType);
    returnFlag = 2; % Jones matrix
    wavLen = wavLenInUm*10^-6;

    inputDataStruct = struct();
    inputDataStruct.Wavelength = wavLen;
    inputDataStruct.IncidenceAngleInDeg = incAngleInDeg;
    inputDataStruct.IndexBefore = indexBefore;
    inputDataStruct.IndexAfter = indexAfter;
    [ returnDataStruct] = coatingDefinitionHandle(returnFlag,coatingParameters,inputDataStruct);
    
    %   returnDataStruct:
    ampRefJonesMatrix = returnDataStruct.AmplitudeReflectionMatrix;
    powRefJonesMatrix = returnDataStruct.PowerReflectionMatrix;
    
    ampRs = squeeze(ampRefJonesMatrix(1,1,:));
    ampRp = squeeze(ampRefJonesMatrix(2,2,:));
    powRs = squeeze(powRefJonesMatrix(1,1,:));
    powRp = squeeze(powRefJonesMatrix(2,2,:));
    jonesRefMatrix = ampRefJonesMatrix;
end
