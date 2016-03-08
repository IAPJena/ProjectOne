function [ paramFormat ] = getParameterFormat( currentComponent,paramIndex )
    % getParameterType: returns the parameter type of current component with
    % parameter index
    % Input:
    %   ( currentComponent,paramIndex )
    % Output:
    %   [ paramType ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    componentDefinitionFileName = currentComponent.Type;
    % Connect the component definition function
    componentDefinitionHandle = str2func(componentDefinitionFileName);
    returnFlag = 2; % Basic parameters of the component
    %     [ paramNames, paramTypes, defaultValue] = componentDefinitionHandle(returnFlag);
    returnDataStruct = componentDefinitionHandle(returnFlag);
    paramFormats = returnDataStruct.UniqueParametersStructFieldFormats;
    paramFormat = paramFormats{paramIndex};
end

