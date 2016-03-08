% function [ complexFieldInTime,dx,dy,dt ] = convertToTemporalDomain( generalPulse, timeWindow, nTimeSampling )
function [ complexExFieldInTime,x_lin,y_lin,t_lin ] = convertToTemporalDomain( generalPulse,nTimeSampling )
%convertToTemporalDomain converts field in spectral domain to temporal
%(time) domain. Basically it does  kind of 1D fourier transform

if nargin == 0
    disp('Error: no input for convertToTemporalDomain');
    return;
elseif nargin == 1
    nTimeSampling = 256;
else
end

c = 299792458;
harmonicFieldSet = generalPulse.PulseHarmonicFieldSet;
harmonicFieldArray = harmonicFieldSet.HarmonicFieldArray;
nSpectralSample = size(harmonicFieldArray,2);

nx = size(harmonicFieldArray(1).computeEx,2);
ny = size(harmonicFieldArray(1).computeEx,1);

dx = harmonicFieldArray(1).SamplingDistance(1);
dy = harmonicFieldArray(1).SamplingDistance(2);

freqWindow = generalPulse.getFrequencyWindow;
timeWindow = nSpectralSample/freqWindow;

% centered at origin
cx = 0;
cy = 0;

x_lin = uniformSampling1D(cx,nx,dx);
y_lin = uniformSampling1D(cy,ny,dy);

nt = nTimeSampling;
dt = timeWindow/nTimeSampling;
ct = 0;
t_lin = uniformSampling1D(ct,nt,dt);

% Put Ex and Ey in 3D matrix with the 3rd dimension being the spectral dim
[ allExIn3D] = computeFieldSpectrumIn3D( harmonicFieldSet,'Ex' );


% Perform FFT in 3rd dimension to get time domain result
% delta = generalPulse.getFrequencyInterval;
delta = 1;
dim = 3;
complexExFieldInTime = fftshift(fft(allExIn3D,nTimeSampling,dim),dim);
end

