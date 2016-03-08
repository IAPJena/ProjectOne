function [ tlinInSI,xlinInSI,amplitude,pusedBeamParametersTxt ] = plotGaussianPulsedBeam( gaussianPulsedBeam,tlinInSI,xlinInSI,axesHandle )
%plotGaussianPulsedBeam plots the the normalized amplitude of a given
%gaussian pulsed beam in 1D i.e x-t plot

if nargin == 0
    disp('Error: The function plotGaussianPulsedBeam requires gaussian beam object.');
    tlinInSI= NaN;
    xlinInSI= NaN;
    amplitude= NaN;
    pusedBeamParametersTxt= NaN;
    return;
elseif nargin == 1 
    wt = getGlobalTemporalWidth(gaussianPulsedBeam);
    tMax = 3*wt/sqrt(2);
    tlinInSI = linspace(-tMax,tMax,200);
    wx = getGlobalSpatialWidth(gaussianPulsedBeam);
    xMax = 3*wx/sqrt(2);
    xlinInSI = linspace(-xMax,xMax,200);
    figure;
    axesHandle = axes;    
elseif nargin == 2 
    wx = getGlobalSpatialWidth(gaussianPulsedBeam);
    xMax = 3*wx/sqrt(2);
    xlinInSI = linspace(-xMax,xMax,200);
    figure;
    axesHandle = axes;   
elseif nargin == 3 
    figure;
    axesHandle = axes;     
else
    
end

[t,x] = meshgrid(tlinInSI,xlinInSI);

E0 = 1;
Qinv = gaussianPulsedBeam.QInverseMatrix;
centralWavelength = gaussianPulsedBeam.CentralWavelength;

% Amplitude
amplitude = E0*exp(real(-1i*(pi/(centralWavelength))*(Qinv(1,1)*x.^2 + (Qinv(1,2)-Qinv(2,1))*x.*t - Qinv(2,2)*t.^2)));
        
surf(axesHandle,t,x,amplitude,'facecolor','interp',...
             'edgecolor','none',...
             'facelighting','phong');
view(2);
t_min = min(tlinInSI);
t_max = max(tlinInSI);
x_min = min(xlinInSI);
x_max = max(xlinInSI);
axis([t_min t_max x_min x_max])
% axis equal;
% Display the beam parameters
pusedBeamParametersTxt = char(...
['Local Spatial Width   : ',num2str(getGlobalSpatialWidth(gaussianPulsedBeam),'%.4e'),' m'],...
['Global Spatial Width  : ',num2str(getGlobalSpatialWidth(gaussianPulsedBeam),'%.4e'),' m'],...
['Local Temporal Width  : ',num2str(getLocalTemporalWidth(gaussianPulsedBeam),'%.4e'),' s'],...
['Global Temporal Width : ',num2str(getGlobalTemporalWidth(gaussianPulsedBeam),'%.4e'),' s'],...
['Pulse Front Tilt      : ',num2str(getPulseFrontTilt(gaussianPulsedBeam),'%.4e'),' s/m']);
% disp(pusedBeamParametersTxt);
end

