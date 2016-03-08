function [ generallyAstigmaticGaussianBeamSet ] = ...
        convertRayBundlesToGenerallyAstigmaticGaussianBeamSet( ...
        gaussianBeamRayBundle,totalPathLengths )
    %convertRayBundlesToGenerallyAstigmaticGaussianBeamSet Gives the gaussian beam from the five rays
    % used to represent the beams. In the input ray bundle, the ray properties
    % shall be put in agiven order corresonging for each gaussian beam.
    % They are put in the following order
    % central + waist x + waist y + div x + div y ray properties. That is
    % every 5th property corresponds to the centeral ray and so for others.
    % This speeds up ray tracing by enabling simultanous ray trace for all
    % rays.
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
    
    if nargin < 1
        disp(['Error: The function convertRayBundlesToGenerallyAstigmaticGaussianBeamSet',...
            ' needs atleast one argument, gaussianBeamRayBundle.']);
        generallyAstigmaticGaussianBeamSet = NaN;
        return;
    else
        % Check that the ray bundles passed has parameters which are multiple of 5
        % since each gaussian beam is represented by 5 rays.
        nRayParameters = size(gaussianBeamRayBundle.Position,2);
        if mod(nRayParameters,5) ~= 0
            disp(['Error: The number of rays represented by the input argument',...
                ' gaussianBeamRayBundle should be multiple of 5.']);
            generallyAstigmaticGaussianBeamSet = NaN;
            return;
        else
            nGaussian = size(gaussianBeamRayBundle.Position,2);
        end
    end
    if nargin < 2
        totalPathLengths = zeros(1,nGaussian);
    end
    
    centralRayDirection = gaussianBeamRayBundle.Direction(:,1:5:end);
    centralRayPosition = gaussianBeamRayBundle.Position(:,1:5:end);
    centralRayWavelength = gaussianBeamRayBundle.Wavelength(:,1:5:end);
    
    
    waistRayXDirection = gaussianBeamRayBundle.Direction(:,2:5:end);
    waistRayXIntersection = gaussianBeamRayBundle.Position(:,2:5:end);
    
    waistRayYDirection = gaussianBeamRayBundle.Direction(:,3:5:end);
    waistRayYIntersection = gaussianBeamRayBundle.Position(:,3:5:end);
    
    divergenceRayXDirection = gaussianBeamRayBundle.Direction(:,4:5:end);
    divergenceRayXIntersection = gaussianBeamRayBundle.Position(:,4:5:end);
    
    divergenceRayYDirection = gaussianBeamRayBundle.Direction(:,5:5:end);
    divergenceRayYIntersection = gaussianBeamRayBundle.Position(:,5:5:end);
    
    complexRay1Position = divergenceRayXIntersection + 1i*waistRayXIntersection;
    complexRay1Direction = divergenceRayXDirection + 1i*waistRayXDirection;
    complexRay2Position = divergenceRayYIntersection + 1i*waistRayYIntersection;
    complexRay2Direction = divergenceRayYDirection + 1i*waistRayYDirection;
    
    generallyAstigmaticGaussianBeamSet = GenerallyAstigmaticGaussianBeamSet(...
        complexRay1Position,complexRay1Direction,complexRay2Position,...
        complexRay2Direction,centralRayPosition,centralRayDirection,...
        centralRayWavelength,totalPathLengths);
end

