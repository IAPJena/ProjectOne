function [ waistAndDivergenceRaysAtObjectSurface ] = getGaussianBeamWaistAndDivergenceRaysAtObjectSurface...
        ( gaussianBeamSet,objectThickness )
    %getGaussianBeamWaistAndDivergenceRaysAtObjectSurface returns the 5 rays used to trace the gaussian beam
    %  waist x , waist y, divergence x, divergence y
    % The rays positions are traced back to the first surface and all positions
    % are in meter to make suitable for raytrace function
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
    [waistRayXAtSurface2,waistRayYAtSurface2] = getOrthogonalGaussianBeamWaistRays(gaussianBeamSet);
    [divergenceRayXAtSurface2,divergenceRayYAtSurface2] = getOrthogonalGaussianBeamDivergenceRays(gaussianBeamSet);
    
    % Compute their positions in the object plane (z = 0)
    waistRayXAtSurface1 = waistRayXAtSurface2;
    waistRayYAtSurface1 = waistRayYAtSurface2;
    divergenceRayXAtSurface1 = divergenceRayXAtSurface2;
    divergenceRayYAtSurface1 = divergenceRayYAtSurface2;
    centralRayPosition = [gaussianBeamSet.CentralRayPosition];
    centralRayDirection = [gaussianBeamSet.CentralRayDirection];
    centralRayWavelength = [gaussianBeamSet.CentralRayWavelength];
    
    centralRay = ScalarRayBundle();
    centralRay.Position = centralRayPosition;
    centralRay.Direction = centralRayDirection;
    centralRay.Wavelength = centralRayWavelength;
    
    divergenceRayInXDirection = [divergenceRayXAtSurface2.Direction];
    divergenceRayInYDirection = [divergenceRayYAtSurface2.Direction];
    
    % Waist rays
    waistRayXAtSurface2Position = [waistRayXAtSurface2.Position];
    waistRayYAtSurface2Position = [waistRayYAtSurface2.Position];
    distToObjectForWaistRayInX = -([waistRayXAtSurface2Position(3,:)]+objectThickness)./...
        centralRayDirection(3,:);
    distToObjectForWaistRayInY = -([waistRayYAtSurface2Position(3,:)]+objectThickness)./...
        centralRayDirection(3,:);
    
    
    % Convert to cell array for assigning to multimple rays at the same time
    waistRayXAtSurface1Position = mat2cell(([waistRayXAtSurface2.Position] + ...
        repmat(distToObjectForWaistRayInX,3,1).*centralRayDirection),[3],[ones(1,length(gaussianBeamSet))]);
    waistRayYAtSurface1Position = mat2cell(([waistRayYAtSurface2.Position] + ...
        repmat(distToObjectForWaistRayInY,3,1).*centralRayDirection),[3],[ones(1,length(gaussianBeamSet))]);
    [waistRayXAtSurface1.Position] = waistRayXAtSurface1Position{:};
    [waistRayYAtSurface1.Position] = waistRayYAtSurface1Position{:};
    % Divergence rays
    divergenceRayXAtSurface2Position = [divergenceRayXAtSurface2.Position];
    divergenceRayYAtSurface2Position = [divergenceRayYAtSurface2.Position];
    divergenceRayXAtSurface2Direction = [divergenceRayXAtSurface2.Direction];
    divergenceRayYAtSurface2Direction = [divergenceRayYAtSurface2.Direction];
    
    distToObjectForDivergenceRayInX = -([divergenceRayXAtSurface2Position(3,:)]+objectThickness)./...
        divergenceRayXAtSurface2Direction(3,:);
    distToObjectForDivergenceRayInY = -([divergenceRayYAtSurface2Position(3,:)]+objectThickness)./...
        divergenceRayYAtSurface2Direction(3,:);
    
    divergenceRayXAtSurface1Position = mat2cell(([divergenceRayXAtSurface2.Position] + ...
        repmat(distToObjectForDivergenceRayInX,3,1).*divergenceRayInXDirection),[3],[ones(1,length(gaussianBeamSet))]);
    divergenceRayYAtSurface1Position = mat2cell(([divergenceRayYAtSurface2.Position] + ...
        repmat(distToObjectForDivergenceRayInY,3,1).*divergenceRayInYDirection),[3],[ones(1,length(gaussianBeamSet))]);
    [divergenceRayXAtSurface1.Position] = divergenceRayXAtSurface1Position{:};
    [divergenceRayYAtSurface1.Position] = divergenceRayYAtSurface1Position{:};
    
    rayArray = [waistRayXAtSurface1;...
        waistRayYAtSurface1;divergenceRayXAtSurface1;divergenceRayYAtSurface1];
    
    waistAndDivergenceRaysAtObjectSurface = convertRayArrayToRayBundle(rayArray);
end

