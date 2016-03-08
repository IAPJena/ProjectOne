function [ wavelength_GDD ] = ...
        plotGDDVsWavelength( optSystem,startSurfIndex,startSurfInclusive,...
        endSurfIndex, endSurfInclusive,pilotRayPosition,pilotRayDirection,...
        minWavelengthInM,maxWavelengthInM,wavelengthStep,axesHandle,tableHandle,textHandle)
    %plotGDDVsWavelength: Plots GDD vs wavelength of an optical system.
    
    % Default values
    if nargin == 0
        disp('Error: The function plotGDDVsWavelength requires an optical object as argument.');
        wavelength_GDD = NaN;
        return ;
    elseif nargin == 1
        startSurfIndex = 1;
        startSurfInclusive = 0;
        endSurfIndex = optSystem.NumberOfSurfaces;
        endSurfInclusive = 1;
        chiefRay = getChiefRay(optSystem);
        pilotRayPosition = chiefRay.Position;
        pilotRayDirection = chiefRay.Direction;
        
        minWavelength = getMinimumWavelength(optSystem);
        maxWavelength = getMaximumWavelength(optSystem);
        if (minWavelength==maxWavelength)
            primaryWavelength = getPrimaryWavelength(optSystem);
            minWavelengthInM = primaryWavelength - 0.1*10^-6;
            maxWavelengthInM = primaryWavelength + 0.1*10^-6;
        end
        nPoints = 99;
        wavelengthStep = (maxWavelength-minWavelength)/nPoints;
        axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
        tableHandle = uitable('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
        textHandle = uicontrol('Parent',figure,'Units','normalized',...
            'Style', 'text','Position',[0.1,0.1,0.8,0.8]);
        
    elseif nargin < 11
        disp('Error: The function plotGDDVsWavelength requires all parameters or no parameter as argument.');
        wavelength_GDD = NaN;
        return ;
    else
        
    end
    
    wavelengthVectorInM = [minWavelengthInM:wavelengthStep:maxWavelengthInM]';
    nPoints = length(wavelengthVectorInM);
    GDD = zeros(nPoints,1);
    for k = 1:nPoints
        
        pilotRay = ScalarRayBundle(pilotRayPosition,pilotRayDirection,wavelengthVectorInM(k)) ;
        % Compute Kostenbauder matrix
        finalKostenbauderMatrix = computeKostenbauderMatrix(...
            optSystem,startSurfIndex,startSurfInclusive,...
            endSurfIndex, endSurfInclusive,pilotRay );
        GDD(k) = finalKostenbauderMatrix(3,4)/(2*pi);
    end
    
    wavelength_GDD = [wavelengthVectorInM GDD];
    if isnumeric(axesHandle) && axesHandle < 0
        % No plot
    else
        plot(axesHandle,wavelengthVectorInM*10^6,GDD*10^30);
        grid on;
        xlabel(axesHandle,'Wavelength (um)','FontSize',12);
        ylabel(axesHandle,'GDD (fs^2)','FontSize',12);
        xlim(axesHandle,[minWavelengthInM,maxWavelengthInM]*10^6);
    end
end

