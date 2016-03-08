function accPhase = computeAccumulatedPhase( opticalPathLength,wavelengthInM )
    % computeAccumulatedPhase: Computs phase accumulated in agiven path by 
    % light with given frewuency.
    % The function is vectorized so it can work on
    % multiple sets of inputs once at the same time.
    % Inputs:
    %   opticalPathLength: the optical path length of the ray.
    %   wavelength: Wavelength of the ray traced
    % Outputs:
    %   accPhase: Accumulated phase in radian
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
    
    % path length and wavelength are in m
    accPhase = (2*pi* opticalPathLength)./(wavelengthInM);
end

