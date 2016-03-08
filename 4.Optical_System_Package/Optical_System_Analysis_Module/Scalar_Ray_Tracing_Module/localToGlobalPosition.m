function [ globalPosition ] = localToGlobalPosition( localPosition,surfaceCoordinateTM)
    % localToGlobalPosition: converts position given in local coordinate to
    % global coordinate.
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.    
    % Input
    %   localPosition: position in local coordinate
    %   surfaceCoordinateTM: surface transformation matrix 4x4
    % Output
    %   globalPosition: position in global coordinate system
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
    nRay = size(localDirection,2);
    surfPosition = surfaceCoordinateTM(1:3,4);
    toLocalRotation = surfaceCoordinateTM(1:3,1:3); % from global to local
    toGlobalRotation = toLocalRotation';  
    globalPosition = (toGlobalRotation*localPosition + surfPosition*ones(1,nRay);%repmat(surfPosition,[1,nRay]));
end

