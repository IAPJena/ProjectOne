function [ generalPulsedBeam, spatialDistribution, spectralDistribution ] = ...
    convertToGeneralPulsedBeam( gaussianPulsedBeam,nWavSampling,nXYSampling )
%CONVERTTOGENERALPULSEDBEAM converts gaussian pulsed beam to general pulsed
%beams (geral pulsed beam = array of plane wave with certain spatial and 
%spectral distribution ).

% Global widths are taken so that in the case of spatiotemporal coupling 
% the width is assumed to be width integrated over all time or positions.
% so it is more accurate in the absence of spatiotemporal coupling. 
if nargin == 0
    disp('Error: Atleast one argument required');
    generalPulsedBeam = [];
    spatialDistribution = [];
    spectralDistribution = [];
    return
elseif nargin == 1
    nWavSampling = 51; % shall be odd to get zero line
    nXYSampling = 64; % shall be power of 2 cos of FFT requirement    
elseif nargin == 2
    nXYSampling = 64; % shall be power of 2 cos of FFT requirement    
elseif nargin == 3
end
c = 299792458;
nx = nXYSampling;
ny = nXYSampling;

spatialWidth = getGlobalSpatialWidth(gaussianPulsedBeam);
temporalWidth = getGlobalTemporalWidth(gaussianPulsedBeam);

wav0 = gaussianPulsedBeam.CentralWavelength;
freq0 = c/wav0;
spectralWidthInFreq = 2/temporalWidth; % NB. for gaussian w0*t0 >= 2 (using 1/e width)
spectralWidthInWav = (c/freq0^2)*spectralWidthInFreq;

% 99.7% of gaussian falls inside 3*w0 so lets take these range for sampling
waveLenVector = linspace(wav0-1.5*spectralWidthInWav,wav0+1.5*spectralWidthInWav,nWavSampling);
delWav = waveLenVector - wav0;
spectralAmplitude = exp(-(delWav.^2)/(spectralWidthInWav^2));
spectralPhase = zeros(1,nWavSampling);

dx = 3*spatialWidth/nx;
dy = 3*spatialWidth/ny;

x_lin = [-(nx/2):1:((nx/2)-1)]*dx;
y_lin = [-(ny/2):1:((ny/2)-1)]*dy;
        
[X,Y] = meshgrid(x_lin,y_lin);
w0 = spatialWidth;
R = sqrt(X.^2 + Y.^2);
spatialAmplitude = exp(-(R.^2)/(w0^2));
spatialPhase = zeros(nXYSampling,nXYSampling);

% create complex plane wave
dir = gaussianPulsedBeam.Direction;
planeWaveArray(nWavSampling) = PlaneWave;
for ww = 1:nWavSampling
    Ex = spatialAmplitude.*exp(1i*spatialPhase)*spectralAmplitude(ww)*exp(1i*spectralPhase(ww));
    Ey = 0*Ex;
    planeWaveArray(ww) = PlaneWave(Ex,Ey,dx,dy,dir,waveLenVector(ww));
end

spatialDistribution = cat(3,X,Y,spatialAmplitude,spatialPhase); % X Y spatialAmplitude spatialPhase
spectralDistribution = cat(1,waveLenVector,spectralAmplitude,spectralPhase);% wav spectralAmplitude spectralPhase

% generalPulsedBeam = GeneralPulsedBeam(spatialDistribution,spectralDistribution);
direction = gaussianPulsedBeam.Direction;
generalPulsedBeam = GeneralPulsedBeam(planeWaveArray,direction);

end

