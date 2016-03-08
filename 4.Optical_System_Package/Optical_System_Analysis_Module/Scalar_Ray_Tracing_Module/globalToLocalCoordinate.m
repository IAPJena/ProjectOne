function [localRayPosition,localRayDirection] = ...
    globalToLocalCoordinate(globalRayPosition,globalRayDirection,...
        surfaceCoordinateTM)
    
	%GLOBALTOLOCALCOORDINATE the transfer from the reference coordinate system 
	%   to the local surface coordinate system. 
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
	% Inputs:
	%   globalRayData: 
    %   surfaceCoordinateTM: 4x4 coordinate transfer
    %   matrices for local surface and reference coordinate system
    % Output 
	%   localRayData: 

   % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Part of the RAYTRACE toolbox
	%   Written by: Yi Zhong 05.03.2013
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University  
	
	%   Modified By With New Algorithm: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% 03.09.2012    Yi Zhong             Original Version         Version 2.1
	% Oct 14,2013   Worku, Norman G.     OOP Version              Version 3.0
    % Dec 22,2013   Worku, Norman G.     New Algorithm
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
         nRay = size(globalRayPosition,2);

        surfPosition = surfaceCoordinateTM(1:3,4);
        toLocalRotation = surfaceCoordinateTM(1:3,1:3); % from global to local

		newTranslatedPosition = globalRayPosition - surfPosition*ones(1,nRay);%repmat(surfPosition,[1,nRay]);
		newTranslatedDirection = globalRayDirection;
        
		localRayPosition = (toLocalRotation*newTranslatedPosition);
		localRayDirection = (toLocalRotation*newTranslatedDirection);        
end

