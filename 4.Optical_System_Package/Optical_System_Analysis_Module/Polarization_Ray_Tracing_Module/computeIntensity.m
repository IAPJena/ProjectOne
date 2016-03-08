function intensity = computeIntensity( polVector,refractiveIndex )
    % computeIntensity: compute intensity for a given polarization vector
    % The function is vectorized so it can work on
    % multiple inputs once at the same time.    
    % Inputs:
    %   polVector: Electric field vector
    %   refractiveIndex: can be used if the intensity affected by the
    %   refractive index of the medium 
    % Output:
    %   intensity: The intensity of electric field vector.

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
   nRay = size(polVector,2);
    if nargin == 1
        refractiveIndex = ones([1,nRay]);
    end
    intensity = refractiveIndex .* ((abs(polVector(1,:))).^2 + ...
        (abs(polVector(2,:))).^2 + (abs(polVector(3,:))).^2);
end

