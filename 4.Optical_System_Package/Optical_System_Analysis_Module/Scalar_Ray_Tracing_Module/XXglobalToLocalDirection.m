function [ localDirection ] = globalToLocalDirection( globalDirection,surfaceCoordinateTM)
    % globalToLocalDirection: converts Direction given in global coordinate to
    % local surface coordinate.
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % Input
    %   globalDirection: Direction in global coordinate
    %   surfaceCoordinateTM: surface transformation matrix 4x4
    % Output
    %   localDirection: Direction in surface local coordinate system
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written by: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% Jan 14,2014   Worku, Norman G.     Original Version         Version 3.0
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    nRay = size(globalDirection,2);
    surfPosition = surfaceCoordinateTM(1:3,4);
    toLocalRotation = surfaceCoordinateTM(1:3,1:3); % from global to local
    newTranslatedDirection = globalDirection;    
    localDirection = (toLocalRotation*newTranslatedDirection);    
end

