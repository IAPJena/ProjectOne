function [ generalPulse, spatialDistribution, spectralDistribution ] = ...
    convertToGeneralPulse( gaussianPulsedBeam,nWavSampling,nXYSampling,timeWindowFactor )
%convertToGeneralPulse converts gaussian pulsed beam to general pulse
%(geral pulsed beam = set of harmonic fields ).

% Global widths are taken so that in the case of spatiotemporal coupling 
% the width is assumed to be width integrated over all time or positions.
% so it is more accurate in the absence of spatiotemporal coupling. 
if nargin == 0
    disp('Error: Atleast one argument required');
    generalPulse = [];
    spatialDistribution = [];
    spectralDistribution = [];
    return
elseif nargin == 1
    nWavSampling = 51; % shall be odd to get zero line
    nXYSampling = 64; % shall be power of 2 cos of FFT requirement  
    timeWindowFactor = 2; % factor for determining time window from timeFWHM
elseif nargin == 2
    nXYSampling = 64; % shall be power of 2 cos of FFT requirement  
    timeWindowFactor = 2; % factor for determining time window from timeFWHM
elseif nargin == 3
    timeWindowFactor = 2; % factor for determining time window from timeFWHM
else
end
c = 299792458;
nx = nXYSampling;
ny = nXYSampling;
nFreqSampling = nWavSampling;

spatialWidth = getGlobalSpatialWidth(gaussianPulsedBeam);
temporalWidth = getGlobalTemporalWidth(gaussianPulsedBeam);

timeFWHM = sqrt(2*log(2))*temporalWidth;
timeWindow = timeWindowFactor*timeFWHM;

freqSamplingDistance = 1/timeWindow;
freqWindow = nFreqSampling*freqSamplingDistance;

wav0 = gaussianPulsedBeam.CentralWavelength;
freq0 = c/wav0;

spectralWidthInFreq = (2/(2*pi))/temporalWidth; % NB. for gaussian w0*t0 >= 2 (using 1/e width)
% spectralWidthInFreq = (2)/temporalWidth; % NB. for gaussian w0*t0 >= 2 (using 1/e width)

freqFWHM = sqrt(2*log(2))*spectralWidthInFreq;
freqVector = linspace(freq0-freqWindow/2,freq0+freqWindow/2,nFreqSampling);
delFreq = freqVector - freq0;
spectralAmplitude = exp(-(delFreq.^2)/(spectralWidthInFreq^2));
spectralPhase = zeros(1,nFreqSampling);

spatialWindowFactor = 3;
spatialWindowSize = spatialWindowFactor*spatialWidth;

dx = spatialWindowSize/nx;
dy = spatialWindowSize/ny;

% centered at origin
cx = 0;
cy = 0;
x_lin = uniformSampling1D(cx,nx,dx);
y_lin = uniformSampling1D(cy,ny,dy);

        
[X,Y] = meshgrid(x_lin,y_lin);
w0 = spatialWidth;
R = sqrt(X.^2 + Y.^2);
spatialAmplitude = exp(-(R.^2)/(w0^2));
spatialPhase = zeros(nXYSampling,nXYSampling);
waveLenVector = c./freqVector;

% create complex plane wave
dir = gaussianPulsedBeam.Direction;
center = [0,0]';
harmonicFieldArray(nFreqSampling) = HarmonicField;
for ww = 1:nFreqSampling
    Ex = spatialAmplitude.*exp(1i*spatialPhase)*spectralAmplitude(ww)*exp(1i*spectralPhase(ww));
    Ey = 0*Ex;
    harmonicFieldArray(ww) = HarmonicField(Ex,Ey,dx,dy,waveLenVector(ww),center,dir);
end

spatialDistribution = cat(3,X,Y,spatialAmplitude,spatialPhase); % X Y spatialAmplitude spatialPhase
spectralDistribution = cat(1,waveLenVector,spectralAmplitude,spectralPhase);% wav spectralAmplitude spectralPhase

% generalPulsedBeam = GeneralPulsedBeam(spatialDistribution,spectralDistribution);
direction = gaussianPulsedBeam.Direction;
harmonicFieldSet = HarmonicFieldSet(harmonicFieldArray);
generalPulse = GeneralPulse(harmonicFieldSet,direction);

end

