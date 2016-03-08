function [ geometricalOpticalGroupPathLength ] = ...
    plotPathLengthVersusWavelength( optSystem, fieldIndex, minWavelengthInM, maxWavelengthInM, nPoints, axesHandle)
%PLOTPATHLENGTHVERSUSWAVELENGTH Plots gemetrical path length, optical path
%length and group path length vs wavelength in the same graph for given field index.

% Default values
if nargin == 0
    disp('Error: The function plotPathLengthVersusWavelength requires an optical object as argument.');
    geometricalOpticalGroupPathLength = NaN;
    return ;
elseif nargin == 1
    fieldIndex = 1;
    primaryWavelength = getPrimaryWavelength(optSystem);
    minWavelengthInM = primaryWavelength - 0.1*10^-6;
    maxWavelengthInM = primaryWavelength + 0.1*10^-6;
    nPoints = 99;
    axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
elseif nargin == 2
    primaryWavelength = getPrimaryWavelength(optSystem);
    minWavelengthInM = primaryWavelength - 0.1*10^-6;
    maxWavelengthInM = primaryWavelength + 0.1*10^-6;
    nPoints = 99;   
    axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
elseif nargin == 3
    disp('Error: The max wavelength is required as argument.');
    geometricalOpticalGroupPathLength = NaN;
    return ;    
elseif nargin == 4
    nPoints = 99;
    axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
elseif nargin == 5
    axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
end

% Make the number of points odd so that the central wavelength is
% calculated easily
nPoints = 2*floor(nPoints/2) + 1;
wavelengthVectorInM = linspace(minWavelengthInM, maxWavelengthInM,nPoints);

[ geometricalOpticalGroupPathLength ] = ...
    computePathLengths( optSystem, fieldIndex, wavelengthVectorInM);

x = wavelengthVectorInM;
y1 = geometricalOpticalGroupPathLength(:,1);
y2 = geometricalOpticalGroupPathLength(:,2);
y3 = geometricalOpticalGroupPathLength(:,3);
if axesHandle >= 0
    subplot(3,1,1) % second subplot
    plot(x*10^6,y1*10^3);   
    xlabel('Wavelength (um)')
    ylabel('Geometric PL(mm)')
    grid on
    
    subplot(3,1,2) % second subplot
    plot(x*10^6,y2*10^3);
    xlabel('Wavelength (um)')
    ylabel('Optical PL(mm)')
    grid on
    
    subplot(3,1,3) % second subplot
    plot(x*10^6,y3*10^3);
    xlabel('Wavelength (um)')
    ylabel('Group PL(mm)')  
    grid on
end

end

