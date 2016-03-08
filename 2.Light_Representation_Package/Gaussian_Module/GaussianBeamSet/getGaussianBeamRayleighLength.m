function [ rayleighLengthInX,rayleighLengthInY ] = getGaussianBeamRayleighLength( gaussianBeamSet )
    %getGaussianBeamRayleighLength Returns the rayleigh range in local x and y directions
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
    rayleighLengthInX = (pi*(gaussianBeamSet.WaistRadiusInX).^2)./...
        (gaussianBeamSet.CentralRayWavelength);
    rayleighLengthInY = (pi*(gaussianBeamSet.WaistRadiusInY).^2)./...
        (gaussianBeamSet.CentralRayWavelength);
end

