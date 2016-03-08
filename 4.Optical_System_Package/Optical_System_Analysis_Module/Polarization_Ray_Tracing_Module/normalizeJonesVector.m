function [ normalizedJonesVector ] = normalizeJonesVector( jonesVector )
    % normalizeJonesVector normalizes a given jones vector
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % Inputs:
    %   jonesVector = 2XN matrix([JsMag&JsPhase;JpMag&JpPhase])
    % Output:
    %   normalizedJonesVector: 3XN matrix Normalized jones vector

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
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    nRay = size(jonesVector,2);
    % Divide the jones vector to magnitude and phase
    magSP = abs(jonesVector);
    phaseSP = angle(jonesVector);
    % Compute the resultant maginute
    magE = sqrt(sum((magSP).^2,1)); 
    % Finally compute the normalizedJonesVector
    normalizedJonesVector = jonesVector./repmat(magE,[2,1]);
end

