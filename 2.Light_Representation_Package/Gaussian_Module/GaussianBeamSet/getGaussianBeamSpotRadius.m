function [ spotRadiusInX,spotRadiusInY ] = getGaussianBeamSpotRadius( gaussianBeamSet )
    %getGaussianBeamSpotRadius Returns the spot radius of the beam at z = DistanceFromWaist
    % The code is also vectorized. Multiple inputs and outputs are possible.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    [ rayleighRangeInX,rayleighRangeInY ] = getOrthogonalGaussianBeamRayleighRange(gaussianBeamSet);
    spotRadiusInX = (gaussianBeamSet.WaistRadiusInX).*...
        sqrt(1+(gaussianBeamSet.DistanceFromWaistInX./rayleighRangeInX).^2);
    spotRadiusInY = (gaussianBeamSet.WaistRadiusInY).*...
        sqrt(1+(gaussianBeamSet.DistanceFromWaistInY./rayleighRangeInY).^2);
end

