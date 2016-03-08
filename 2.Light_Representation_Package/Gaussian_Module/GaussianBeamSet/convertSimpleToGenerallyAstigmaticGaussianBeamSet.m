function [ generallyAstigmaticGaussianBeamSet ] = ...
        convertSimpleToGenerallyAstigmaticGaussianBeamSet...
        ( gaussianBeamSet )
    %convertSimpleToGenerallyAstigmaticGaussianBeamSet Returns the
    %generally astigmatic gaussian beam set described by the complex ray
    %parameters.
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
    % Get the rays at surface 2 (first surface after object)
    [waistRay1,waistRay2] = getOrthogonalGaussianBeamWaistRays(gaussianBeamSet);
    [divergenceRay1,divergenceRay2] = getOrthogonalGaussianBeamDivergenceRays(gaussianBeamSet);

    complexRay1Position = divergenceRay1.Position + 1i*waistRay1.Position;
    complexRay1Direction = divergenceRay1.Direction + 1i*waistRay1.Direction;
    complexRay2Position = divergenceRay2.Position + 1i*waistRay2.Position;
    complexRay2Direction = divergenceRay2.Direction + 1i*waistRay2.Direction;
    
    centralRayPosition = [gaussianBeamSet.CentralRayPosition];
    centralRayDirection = [gaussianBeamSet.CentralRayDirection];
    centralRayWavelength = [gaussianBeamSet.CentralRayWavelength];
    
    generallyAstigmaticGaussianBeamSet = GenerallyAstigmaticGaussianBeamSet(...
        complexRay1Position,complexRay1Direction,complexRay2Position,...
        complexRay2Direction,centralRayPosition,centralRayDirection,centralRayWavelength);
end

