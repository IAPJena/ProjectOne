function [IntensityBeforeCoating,IntensityAfterCoating] = getIntensity(RayTraceResult)
     % getIntensity: Returns intensity parameters of the ray before
     % and after the coating of a surface
     %   The function is also vectorized so if the inputs are array then 
     %   the output will also be array of the same size.
     
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
     IntensityBeforeCoating = computeIntensity...
         ( [RayTraceResult.PolarizationVectorBeforeCoating]);
     IntensityAfterCoating = computeIntensity...
         ([RayTraceResult.PolarizationVectorAfterCoating]);
end
