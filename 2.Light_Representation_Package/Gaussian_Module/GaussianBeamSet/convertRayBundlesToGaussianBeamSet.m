function [ gaussianBeamSetArray ] = convertRayBundlesToGaussianBeamSet( gaussianBeamRayBundleArray )
    %convertRayBundlesToGaussianBeamSet Gives the gaussian beam from the five rays
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
    
    
    nGaussianBeam = length(gaussianBeamRayBundleArray);
    for kk = 1:nGaussianBeam
        gaussianBeamRayBundle = gaussianBeamRayBundleArray(kk);
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
        
        % transform the 3d ray data to 2d
        [ heightOfDivergenceRayInX,angleOfDivergenceRayInX ] = transform3DRayDataTo2DCoordinate( ...
            centralRayDirection,centralRayPosition,divergenceRayXDirection,divergenceRayXIntersection,...
            centralRayPosition,localXDirection,localYDirection);
        [ heightOfDivergenceRayInY,angleOfDivergenceRayInY ] = transform3DRayDataTo2DCoordinate( ...
            centralRayDirection,centralRayPosition,divergenceRayYDirection,divergenceRayYIntersection,...
            centralRayPosition,localXDirection,localYDirection);
        
        [ heightOfWaistRayInX,angleOfWaistRayInX ] = transform3DRayDataTo2DCoordinate( ...
            centralRayDirection,centralRayPosition,waistRayXDirection,waistRayXIntersection,...
            centralRayPosition,localXDirection,localYDirection);
        [ heightOfWaistRayInY,angleOfWaistRayInY ] = transform3DRayDataTo2DCoordinate( ...
            centralRayDirection,centralRayPosition,waistRayYDirection,waistRayYIntersection,...
            centralRayPosition,localXDirection,localYDirection);
        
        heightOfDivergenceRayInX = heightOfDivergenceRayInX(1,:);
        heightOfDivergenceRayInY = heightOfDivergenceRayInY(2,:);
        heightOfWaistRayInX = heightOfWaistRayInX(1,:);
        heightOfWaistRayInY = heightOfWaistRayInY(2,:);
        angleOfDivergenceRayInX = angleOfDivergenceRayInX(1,:);
        angleOfDivergenceRayInY = angleOfDivergenceRayInY(2,:);
        angleOfWaistRayInX = angleOfWaistRayInX(1,:);
        angleOfWaistRayInY = angleOfWaistRayInY(2,:);
        
        waistRadiusInX = (heightOfWaistRayInX.*angleOfDivergenceRayInX - ...
            angleOfWaistRayInX.*heightOfDivergenceRayInX)./...
            sqrt(angleOfWaistRayInX.^2+angleOfDivergenceRayInX.^2);
        waistRadiusInY = (heightOfWaistRayInY.*angleOfDivergenceRayInY - ...
            angleOfWaistRayInY.*heightOfDivergenceRayInY)./...
            sqrt(angleOfWaistRayInY.^2+angleOfDivergenceRayInY.^2);
        
        
        distanceFromWaistInX = (heightOfDivergenceRayInX.*angleOfDivergenceRayInX + ...
            heightOfWaistRayInX.*angleOfWaistRayInX)./...
            (angleOfWaistRayInX.^2+angleOfDivergenceRayInX.^2);
        distanceFromWaistInY = (heightOfDivergenceRayInY.*angleOfDivergenceRayInY + ...
            heightOfWaistRayInY.*angleOfWaistRayInY)./...
            (angleOfWaistRayInY.^2+angleOfDivergenceRayInY.^2);
        
        gaussianBeamSetArray(kk) = GaussianBeamSet(centralRayPosition,...
            centralRayDirection,centralRayWavelength,waistRadiusInX,...
            waistRadiusInY,distanceFromWaistInX,distanceFromWaistInY);
    end
    
end

