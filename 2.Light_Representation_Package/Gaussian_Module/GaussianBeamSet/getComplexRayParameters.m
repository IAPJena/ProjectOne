function [ complexRay1Position,complexRay1Direction,complexRay2Position,...
        complexRay2Direction ] = getComplexRayParameters( gaussianBeamSet )
    %getComplexRayParameters Returns the parameters of complex rays
    % representing the gaussian beam which could be used for computing the
    % complex electric field for the beam.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Feb 12,2016   Worku, Norman G.     Original Version
    
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    [waistRay1,waistRay2] = getGaussianBeamWaistRays(gaussianBeamSet);
    [divergenceRay1,divergenceRay2] = getGaussianBeamDivergenceRays(gaussianBeamSet);

    complexRay1Position = divergenceRay1.Position + 1i*waistRay1.Position;
    complexRay1Direction = divergenceRay1.Direction + 1i*waistRay1.Direction;
    complexRay2Position = divergenceRay2.Position + 1i*waistRay2.Position;
    complexRay2Direction = divergenceRay2.Direction + 1i*waistRay2.Direction;
end

