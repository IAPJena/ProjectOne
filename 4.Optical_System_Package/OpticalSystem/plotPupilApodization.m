function [ X,Y,pupilApodization ] =...
        plotPupilApodization( optSystem,apodType,apodParam,gridSize,axesHandle)
    %plotPupilApodization Plots the apodization of pupil used.
    %   if axesHandle is not given then plot is not needed and only
    %   calculated datas shall be returned.
    %   apodType,apodParam : Apodization type (String) and corresponding
    %   apodization parameters.(Structure)
  
    % Default Inputs
    if nargin < 4
        disp(['Error: The function plotPupilApodization requires ',...
            'optSystem,gridSize,apodType,apodParam as input argument.']);
        return;
    elseif  nargin == 4
        dispPlot = 0;
    elseif nargin == 5
        dispPlot = 1;
        cla(axesHandle,'reset')
    end
    
    
    
    % Determine exit pupil coordinates 
    % exitPupilDiameter = optSystem.getExitPupilDiameter;
    % xlin = linspace(-exitPupilDiameter/2,exitPupilDiameter/2,gridSize);
    
    xlin = linspace(-1,1,gridSize);
    ylin = xlin;
    [X,Y] = meshgrid(xlin,ylin);
    % Initialize all values to zero           
    pupilApodization(1:gridSize,1:gridSize) = zeros;
    
    switch (apodType)
        case 1 %lower('None') % None = uniform circular intensity
            pupilApodization((X./(max(max(X)))).^2+(Y./(max(max(Y)))).^2 < 1) = 1;
        case 2 %lower('Super Gaussian') % Super Gaussian Type and apodParam = struct with fields
            %  [MaximumIntensity I0, Order m, BeamRadius w];
            I0 = apodParam.MaximumIntensity;
            m = apodParam.Order;
            w = apodParam.BeamRadius;
            R = sqrt(X.^2 + Y.^2);
            pupilApodization = I0*exp(-2*(R./w).^m);
        case default
            disp(['Error: The apodiazation type is not valid. ',...
                'Currently only Super gaussian profiles are supported.']);
            return;
    end
        
    % plot if required
    if dispPlot
        surf(axesHandle,X,Y,pupilApodization,'facecolor','interp',...
                     'edgecolor','none','facelighting','phong');
        % Make the X and Y equal
%        daspect([max(daspect)*[1 1] 1])
    end
end

