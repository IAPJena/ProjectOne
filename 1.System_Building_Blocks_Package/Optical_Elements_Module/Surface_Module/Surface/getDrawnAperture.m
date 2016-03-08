function [drawnApertureParameters,drawnApertureType] =...
        getDrawnAperture( currentSurface )
    %GETDRAWNAPERTURE Returns the outer aperture size and type for plotting the surface
    % Inputs:
    %   (currentSurface)
    % Outputs:
    %   [drawnApertureParameters,drawnApertureType]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    currentAperture = currentSurface.Aperture;
    drawnApertureParameters = currentAperture.UniqueParameters;
    drawnApertureType = currentAperture.Type;
end

