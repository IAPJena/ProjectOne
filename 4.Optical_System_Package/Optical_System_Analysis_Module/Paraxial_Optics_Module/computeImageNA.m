function imgNA = computeImageNA...
        (exitPupilLocation,exitPupilDiameter, imageRefractiveIndex,imageThick, paraxialImageDistance) 
    % computeObjectNA: compute the paraxial object space NA
    % Inputs
    %   exitPupilLocation: location of exit pupil from image surface
    %   exitPupilDiameter: diameter of exit pupil 
    %   imageRefractiveIndex: image side refractive index
    %   imageThick: thickness from object surface to last surface
    %   paraxialImageDistance: paraxial image location
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    exitPupToParaxialImage = -exitPupilLocation - imageThick +...
        paraxialImageDistance;
    U0 = atan(0.5*exitPupilDiameter/(exitPupToParaxialImage));
    imgNA = abs(imageRefractiveIndex*sin(U0));
end
