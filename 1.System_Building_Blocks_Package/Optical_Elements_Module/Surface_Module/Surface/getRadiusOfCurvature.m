function [ radius ] = getRadiusOfCurvature( currentSurface )
    %GETRADIUSOFCURVATURE Returns the radius of curvature for standard surfaces
    %and INF for others.
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

    if isfield(currentSurface.UniqueParameters,'Radius')
        radius = currentSurface.UniqueParameters.Radius;
    else
        radius = Inf;
    end
end

