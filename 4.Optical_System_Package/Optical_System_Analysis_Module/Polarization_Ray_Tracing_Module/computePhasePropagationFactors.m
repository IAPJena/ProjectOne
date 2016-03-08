function [ pc,ps ] = computePhasePropagationFactors( geometricalPathLength,vacumeWavelength )
    % computePhasePropagationFactors:  computes the cosine ans sign of the phase
    % accumulated by the field while propagating from previous surface to the current surface
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.     
    % Inputs:
    %   geometricalPathLength: The geometrical path of the ray
    %   vacumeWavelength: Wavelength of the wave
    % Outputs:
    %   pc,ps: cosie and sine of phase corresponding to the path length.

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

    % Assume path length and wavelength are passed in SI unit (m)
    phase = -(2*pi*geometricalPathLength)./(vacumeWavelength);
    pc = cos(phase);
    ps = sin(phase);
end

