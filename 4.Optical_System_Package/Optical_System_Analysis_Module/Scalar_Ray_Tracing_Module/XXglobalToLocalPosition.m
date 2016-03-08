function [ localPosition ] = globalToLocalPosition( globalPosition,surfaceCoordinateTM)
    % globalToLocalPosition: converts position given in global coordinate to
    % local surface coordinate.
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % Input
    %   globalPosition: position in global coordinate
    %   surfaceCoordinateTM: surface transformation matrix 4x4
    % Output
    %   localPosition: position in surface local coordinate system
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
    nRay = size(globalPosition,2);
    surfPosition = surfaceCoordinateTM(1:3,4);
    toLocalRotation = surfaceCoordinateTM(1:3,1:3); % from global to local
    newTranslatedPosition = globalPosition - repmat(surfPosition,[1,nRay]);      
    localPosition = (toLocalRotation*newTranslatedPosition);    
end

