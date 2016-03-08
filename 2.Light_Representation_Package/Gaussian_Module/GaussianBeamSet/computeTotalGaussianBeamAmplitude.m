function [ totalAmp,individualAmp,X,Y ] = computeTotalGaussianBeamAmplitude( gaussianBeamSet,xlin,ylin )
    %computeTotalGaussianBeamAmplitude Summary of this function goes here
    %   Detailed explanation goes here
    
    % Repeat the center, width and amplitude in the 3rd dimension  number of
    % sampling point times (N = nx*ny) so that the values of all gaussians can be
    % computed in each sampling points and then be superposed.
    
    nx = length(xlin);
    ny = length(ylin);
    [X,Y] = meshgrid(xlin,ylin);
    N = nx*ny;
    nGauss = gaussianBeamSet.nGaussian;
    
    gaussAmps = repmat(gaussianBeamSet.PeakAmplitude(:,1),[1,1,N]);
    
    gaussCentersX = repmat(gaussianBeamSet.CentralRayPosition(:,1),[1,1,N]);
    gaussCentersY = repmat(gaussianBeamSet.CentralRayPosition(:,2),[1,1,N]);
    
    gauss1eWaistRadiusX = repmat(gaussianBeamSet.WaistRadiusInX,[1,1,N]);
    gauss1eWaistRadiusY = repmat(gaussianBeamSet.WaistRadiusInY,[1,1,N]);

    % Assume orthogonal gaussians
    angleInRad = zeros(nGauss,1,N);
    
    yPoints = repmat(permute(Y(:),[3,2,1]),[nGauss,1]);
    xPoints = repmat(permute(X(:),[3,2,1]),[nGauss,1]);
    
    % Rotate and decenter the x and y points to transform to local
    % coordinates of each gaussian
    xLocal = (xPoints - gaussCentersX).*cos(angleInRad) + (yPoints - gaussCentersY).*sin(angleInRad);
    yLocal = -(xPoints - gaussCentersX).*sin(angleInRad) + (yPoints - gaussCentersY).*cos(angleInRad);
       
    individualAmp = gaussAmps.*(exp(-((xLocal.^2)./(gauss1eWaistRadiusX.^2)+(yLocal.^2)./(gauss1eWaistRadiusY.^2))));
    
    totalAmp = reshape(squeeze(sum(individualAmp,1)),[nx,ny]);
    individualAmp = reshape(squeeze(individualAmp),[nGauss,nx,ny]);
end

