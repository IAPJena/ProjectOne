function [ dispName, imgFileName, compDescription ] = getComponentAboutInfo( currentComponent )
    % getComponentAboutInfo: Returns the help information related to the
    % current component.
    % Input:
    %   ( currentComponent )
    % Output:
    %   [ dispName, imgFileName, compDescription ]
    
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
    returnFlag = 1; % About the component
    [ returnDataStruct] = componentDefinitionHandle(returnFlag);
    dispName = returnDataStruct.Name;
    imgFileName = returnDataStruct.ImageFullFileName;
    compDescription = returnDataStruct.Description;
end

