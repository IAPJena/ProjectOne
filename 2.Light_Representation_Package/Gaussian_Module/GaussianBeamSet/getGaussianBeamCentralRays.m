function [ centralRay ] = getGaussianBeamCentralRays( gaussianBeamSet )
    %getGaussianBeamCentralRays Gives the central rays used to trace the 
    % given gaussian beam
    % The code is also vectorized. Multiple inputs and outputs are possible.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Copy all ray data from central ray and then change the positions to shift
    centralRay = ScalarRayBundle();
    centralRay.Direction = gaussianBeamSet.CentralRayDirection;
    centralRay.Position = gaussianBeamSet.CentralRayPosition;
    centralRay.Wavelength = gaussianBeamSet.CentralRayWavelength;
end

