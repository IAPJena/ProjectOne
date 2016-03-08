function [ newInterpolatedField ] = interpolateField( oldHarmonicField,interpMethod,...
        newCx,newCy,newDx,newDy,newNx,newNy )
    %interpolateField.m Interpolate harmonic field to new grid
    % supported in Matlab interMethod = 'linear', 'nearest', 'cubic', or
    % 'spline'
    if nargin < 4
        disp(['Error: Atleast 3 inputs (harmonicField,interMethod, newCenter)',...
            'are required for interpolateField functioon.']);
        newInterpolatedField = oldHarmonicField;
        return;
    elseif nargin == 4
        [oldEx,x_lin_old,y_lin_old] = oldHarmonicField.computeEx;
        oldEy = oldHarmonicField.computeEy;
        oldNy = size(oldEx,1);
        oldNx = size(oldEx,2);
        oldDx = oldHarmonicField.SamplingDistance(1);
        oldDy = oldHarmonicField.SamplingDistance(2);
        
        newNy = oldNy;
        newNx = oldNx;
        newDx = oldDx;
        newDy = oldDy;
    elseif nargin == 5
        [oldEx,x_lin_old,y_lin_old] = oldHarmonicField.computeEx;
        oldEy = oldHarmonicField.computeEy;
        oldNy = size(oldEx,1);
        oldNx = size(oldEx,2);
        oldDy = oldHarmonicField.SamplingDistance(2);
        
        newDy = oldDy;
        newNx = oldNx;
        newNy = oldNy;
    elseif nargin == 6
        [oldEx,x_lin_old,y_lin_old] = oldHarmonicField.computeEx;
        oldEy = oldHarmonicField.computeEy;
        oldNy = size(oldEx,1);
        oldNx = size(oldEx,2);
        
        newNx = oldNx;
        newNy = oldNy;
    elseif nargin == 7
        [oldEx,x_lin_old,y_lin_old] = oldHarmonicField.computeEx;
        oldEy = oldHarmonicField.computeEy;
        oldNy = size(oldEx,1);
        
        newNy = oldNy;
    else
        [oldEx,x_lin_old,y_lin_old] = oldHarmonicField.computeEx;
        oldEy = oldHarmonicField.computeEy;
    end
    
    x_lin_new = [-(newNx/2):1:((newNx/2)-1)]*newDx + newCx;
    y_lin_new = [-(newNy/2):1:((newNy/2)-1)]*newDy + newCy;
    
    % interpolate using grid function from matlab
    [x_mesh_old,y_mesh_old] = meshgrid(x_lin_old,y_lin_old);
    [x_mesh_new,y_mesh_new] = meshgrid(x_lin_new,y_lin_new);
    
    % Now separate the amp and phase part and interpolate them then recombine
    % Now works fine for real valued field only. Shall be checked with complex
    % field !!!!
    % But in future try with FFT interpolation it may help
    ampExOld = abs(oldEx);
    phaseExOld = unwrap(angle(oldEx));
    ampEyOld = abs(oldEy);
    phaseEyOld = unwrap(angle(oldEy));
    
    ampExNew = interp2(x_mesh_old,y_mesh_old,ampExOld,x_mesh_new,y_mesh_new,interpMethod);
    phaseExNew = interp2(x_mesh_old,y_mesh_old,phaseExOld,x_mesh_new,y_mesh_new,interpMethod);
    ampEyNew = interp2(x_mesh_old,y_mesh_old,ampEyOld,x_mesh_new,y_mesh_new,interpMethod);
    phaseEyNew = interp2(x_mesh_old,y_mesh_old,phaseEyOld,x_mesh_new,y_mesh_new,interpMethod);
    
    % replace  NaN with 0
    ampExNew(isnan(ampExNew)) = 0;
    phaseExNew(isnan(phaseExNew)) = 0;
    ampEyNew(isnan(ampEyNew)) = 0;
    phaseEyNew(isnan(phaseEyNew)) = 0;
    
    newEx = ampExNew.*exp(1i*phaseExNew);
    newEy = ampEyNew.*exp(1i*phaseEyNew);
    
    % construct new harmonic field
    wavelen = oldHarmonicField.Wavelength;
    direction = oldHarmonicField.Direction;
    domain = oldHarmonicField.Domain;
    newCenter = [newCx,newCy]';
    newInterpolatedField = HarmonicField(newEx,newEy,newDx,newDy,wavelen,newCenter,direction,domain);
    
end

