function [ divergenceRayInX,divergenceRayInY  ] = getGaussianBeamDivergenceRays( gaussianBeamSet )
    %getGaussianBeamDivergenceRays Gives the divergence rays used to trace the given gaussian beam
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
    centralRayDirection = gaussianBeamSet.CentralRayDirection;
    centralRayPosition = gaussianBeamSet.CentralRayPosition;
    centralRayWavelength = gaussianBeamSet.CentralRayWavelength;
    
    divergenceRayInXPosition  = centralRayPosition;
    divergenceRayInXWavelength  = centralRayWavelength;
    
    divergenceRayInYPosition  = centralRayPosition;
    divergenceRayInYWavelength  = centralRayWavelength;
    
    [ divergenceHalfAngleInX,divergenceHalfAngleInY ] = getGaussianBeamDivergenceHalfAngle(gaussianBeamSet);
    
    divergenceRayInXDirection = ...
        (ones(3,1)*cos(divergenceHalfAngleInX)).*(centralRayDirection) + ...
        (ones(3,1)*sin(divergenceHalfAngleInX)).*(gaussianBeamSet.LocalXDirection);
    divergenceRayInYDirection = ...
        (ones(3,1)*cos(divergenceHalfAngleInY)).*(centralRayDirection) + ...
        (ones(3,1)*sin(divergenceHalfAngleInY)).*(gaussianBeamSet.LocalYDirection);
    
    divergenceRayInX = ScalarRayBundle();
    divergenceRayInX.Position = divergenceRayInXPosition;
    divergenceRayInX.Direction = divergenceRayInXDirection;
    divergenceRayInX.Wavelength = divergenceRayInXWavelength;
    
    divergenceRayInY = ScalarRayBundle();
    divergenceRayInY.Position = divergenceRayInYPosition;
    divergenceRayInY.Direction = divergenceRayInYDirection;
    divergenceRayInY.Wavelength = divergenceRayInYWavelength;
    
    % Intersection of the divergence rays with the reference plane are
    % left as the same as that of the central ray.
end

