function [ gratingPeriodicity ] = getGratingPeriodicity( currentSurface )
    %GETGRATINGPERIODICITY Gives the period of the grating in meter
    % Inputs:
    %   (currentSurface)
    % Outputs:
    %   [gratingPeriodicity]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    % Grating period is just the inverse of the grating line densit which is
    % usually lines/um
    if isfield(currentSurface.UniqueParameters,'GratingLineDensity')
        gratingPeriodicity = (1/(currentSurface.UniqueParameters.GratingLineDensity))*10^-6;
    else
        gratingPeriodicity = 0;
    end
end

