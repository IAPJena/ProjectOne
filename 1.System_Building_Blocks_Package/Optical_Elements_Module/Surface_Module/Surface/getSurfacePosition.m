function [ surfPosition ] = getSurfacePosition( surface )
    %GETSURFACEPOSITION returns the position of the surface in 3D space 
    % Inputs:
    %   (surface)
    % Outputs:
    %   [surfPosition]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    surfCoordinateTM = surface.SurfaceCoordinateTM;
    surfPosition = surfCoordinateTM(1:3,4);
end

