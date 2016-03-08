function [ X,Y,pupilApodization ] =...
        computePupilApodization(apodType,apodParam,gridSize)
    %computePupilApodization Computes the apodization of pupil used.
    %   apodType,apodParam : Apodization type (String) and corresponding
    %   apodization parameters.(Structure)
  
    % Default Inputs
    if nargin < 4
        X = NaN;
        Y = NaN;
        pupilApodization = NaN;
        disp(['Error: The function plotPupilApodization requires ',...
            'optSystem,gridSize,apodType,apodParam as input argument.']);
        return;
    else
        
    end
    
    % Determine exit pupil coordinates 
    % exitPupilDiameter = optSystem.getExitPupilDiameter;
    % xlin = linspace(-exitPupilDiameter/2,exitPupilDiameter/2,gridSize);
    
    xlin = linspace(-1,1,gridSize);
    ylin = xlin;
    [X,Y] = meshgrid(xlin,ylin);
    % Initialize all values to zero           
    pupilApodization(1:gridSize,1:gridSize) = zeros;
    
    switch lower(apodType)
        case lower('None') % None = uniform circular intensity
            pupilApodization((X./(max(max(X)))).^2+(Y./(max(max(Y)))).^2 < 1) = 1;
        case lower('Super Gaussian') % Super Gaussian Type and apodParam = struct with fields
            %  [MaximumIntensity I0, Order m, BeamRadius w];
            I0 = apodParam.MaximumIntensity;
            m = apodParam.Order;
            w = apodParam.BeamRadius;
            R = sqrt(X.^2 + Y.^2);
            pupilApodization = I0*exp(-2*(R./w).^m);
        case default
            X = NaN;
            Y = NaN;
            pupilApodization = NaN;            
            disp(['Error: The apodiazation type is not valid. ',...
                'Currently only Super gaussian profiles are supported.']);
            return;
    end
end

