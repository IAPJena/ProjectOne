function [ waistRayInX,waistRayInY ] = getOrthogonalGaussianBeamWaistRays( orthogonalGaussianBeamSet )
    %GETWAISTRAYS Gives the waist rays used to trace the given gaussian beam
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
    
    centralRayDirection = orthogonalGaussianBeamSet.CentralRayDirection;
    centralRayPosition = orthogonalGaussianBeamSet.CentralRayPosition;
    centralRayWavelength = orthogonalGaussianBeamSet.CentralRayWavelength;
    
    
    waistRayInXDirection  = centralRayDirection;
    waistRayInXWavelength  = centralRayWavelength;
    
    waistRayInYDirection  = centralRayDirection;
    waistRayInYWavelength  = centralRayWavelength;
    
    % Compute waist ray intersection with the reference plane where the gaussian beam set is defined
    waistRayInXPosition = centralRayPosition + ...
        (ones(3,1)*orthogonalGaussianBeamSet.WaistRadiusInX).*orthogonalGaussianBeamSet.LocalXDirection;
    waistRayInYPosition =  centralRayPosition + ...
        (ones(3,1)*orthogonalGaussianBeamSet.WaistRadiusInY).*orthogonalGaussianBeamSet.LocalYDirection;
    
    waistRayInX = ScalarRayBundle();
    waistRayInX.Position = waistRayInXPosition;
    waistRayInX.Direction = waistRayInXDirection;
    waistRayInX.Wavelength = waistRayInXWavelength;
    
    waistRayInY = ScalarRayBundle();
    waistRayInY.Position = waistRayInYPosition;
    waistRayInY.Direction = waistRayInYDirection;
    waistRayInY.Wavelength = waistRayInYWavelength;
    % NB: The direction of the wais t rays are left to be the same as that
    % of the centeral ray
end

