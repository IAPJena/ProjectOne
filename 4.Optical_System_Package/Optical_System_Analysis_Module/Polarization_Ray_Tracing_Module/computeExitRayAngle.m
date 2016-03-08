function exitRayAngle = computeExitRayAngle( exitRayDirection,surfaceNormal )
    % computeExitRayAngle:  computes the angle of ray after the surface
    % Input:
    %   exitRayDirection: Direction cosine of the exit ray.
    %   surfaceNormal: Unit vector in the direction of surface normal.
    % Output:
    %   exitRayAngle: exit ray angle in radians.
    
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

    angle = asin(cross(exitRayDirection,surfaceNormal)/...
        (norm(exitRayDirection)*norm(surfaceNormal)));
    exitRayAngle = abs(angle);
end

