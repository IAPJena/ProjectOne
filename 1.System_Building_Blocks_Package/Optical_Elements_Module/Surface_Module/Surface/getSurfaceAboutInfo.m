function [ dispName, imgFileName, surfDescription ] = getSurfaceAboutInfo( currentSurface )
    %getSurfaceAboutInfo: Returns the information related to the surface
    %type of current surface
    % Inputs:
    %   (currentSurface)
    % Outputs:
    %   [dispName, imgFileName, surfDescription]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    % Jul 10,2015   Worku, Norman G.     input and output are made struct    
    
    surfaceDefinitionFileName = currentSurface.Type;
    % Connect the surface definition function
    surfaceDefinitionHandle = str2func(surfaceDefinitionFileName);
    returnFlag = 1; % Basic parameters of the surface
    [returnDataStruct] = surfaceDefinitionHandle(returnFlag);
    dispName = returnDataStruct.Name;
    imgFileName = returnDataStruct.ImageFullFileName;
    surfDescription = returnDataStruct.Description;
end

