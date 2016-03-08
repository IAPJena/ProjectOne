function [ paramType ] = getParameterType( currentSurface,parameterID )
    %GETPARAMETERTYPE returns the parameter type of current surface with
    %parameter index
    % Inputs:
    %   (currentSurface,parameterID)
    % Outputs:
    %   [paramType]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    if isnumeric(parameterID)
        
        [fieldNames,fieldFormat,uniqueParamStruct] = getSurfaceUniqueParameters( currentSurface );
        paramType = fieldFormat{parameterID};
    else
        parameterName = parameterID;
        paramType = class(currentSurface.(parameterName));
    end
end

