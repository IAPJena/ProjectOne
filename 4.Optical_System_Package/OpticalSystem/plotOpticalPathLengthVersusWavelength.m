function [ wavelengthOpticalPathLength ] = ...
    plotOpticalPathLengthVersusWavelength( optSystem, fieldIndex, minWavelengthInM, maxWavelengthInM, nPoints, axesHandle)
%plotOpticalPathLengthVersusWavelength Plots optical path
%length vs wavelength in the same graph for given field index.

% Default values
if nargin == 0
    disp('Error: The function plotPathLengthVersusWavelength requires an optical object as argument.');
    wavelengthOpticalPathLength = NaN;
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
    wavelengthOpticalPathLength = NaN;
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

% % make uniform smaple in freq so that wavelength will not be uniformly
% % smapled allowing higher order numerical differentiation of the results
% minFreq = c/minWavelengthInM;
% maxFreq = c/maxWavelengthInM;
% freqVector = linspace(minFreq, maxFreq,nPoints);
% wavelengthVectorInM = c./freqVector;

wavelengthVectorInM = linspace(minWavelengthInM, maxWavelengthInM,nPoints);

[ geometricalOpticalGroupPathLength ] = ...
    computePathLengths( optSystem, fieldIndex, wavelengthVectorInM);

opl = geometricalOpticalGroupPathLength(:,2);
if axesHandle >= 0    
    plot(wavelengthVectorInM*10^6,opl*10^0);
    xlabel('Wavelength (um)')
    ylabel('OPL(m)')
    legend('OPL vs Wavelength');
    grid on
end
wavelengthOpticalPathLength = [wavelengthVectorInM' opl];
end

