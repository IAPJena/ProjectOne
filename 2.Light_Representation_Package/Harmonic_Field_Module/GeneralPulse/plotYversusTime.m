function [ yt_intensity_fliped,t_lin,y_lin  ] = plotYversusTime( generalPulse, nTimeSampling, draw )
%PLOTYVERSUSTIME Plots graph of y vs time

if nargin < 3
    draw = 1;
end
c = 299792458;
nXSamples = size(generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray(1).computeEx,2);
nYSamples = size(generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray(1).computeEx,1);
[ complexExFieldInTime,x_lin,y_lin,t_lin ] = convertToTemporalDomain( generalPulse,nTimeSampling );
% plot the intensity in y-t graph
yt_intensity = squeeze(abs(complexExFieldInTime(:,floor(nXSamples/2),:)).^2);
% flip the yt_intensity to reverse time direction
% yt_intensity_fliped = fliplr(yt_intensity);
yt_intensity_fliped = (yt_intensity);

if draw
    figure;
    axesHandle = axes;
    surf(axesHandle,(t_lin),y_lin,yt_intensity_fliped,'facecolor','interp',...
                 'edgecolor','none',...
                 'facelighting','phong');
    view([0,90]);
end
end

