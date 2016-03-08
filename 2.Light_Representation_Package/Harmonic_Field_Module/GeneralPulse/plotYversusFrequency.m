function [ yv_intensity_interpolated,v_lin,y_lin  ] = plotYversusFrequency( generalPulse, nFreqSampling, draw )
%PLOTYVERSUSTIME Plots graph of y vs time

if nargin < 3
    draw = 1;
end
c = 299792458;
N1 = size(generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray(1).computeEx,1);
N2 = size(generalPulse.PulseHarmonicFieldSet.HarmonicFieldArray(1).computeEx,2);

[ allExIn3D,x_lin,y_lin,v_lin ] = computeFieldSpectrumIn3D( generalPulse.PulseHarmonicFieldSet,'Ex' );
yv_intensity = squeeze(abs(allExIn3D(:,floor(N2/2),:)).^2);
% Interpolate the intensity in freq axis to match nFreqSampling
% nFreqSampling = size(allExIn3D,3);
v_lin_new = linspace(min(v_lin),max(v_lin), nFreqSampling);
y_lin_new = y_lin;

% interpolate using grid function from matlab
[v_mesh_old,y_mesh_old] = meshgrid(v_lin,y_lin);
[v_mesh_new,y_mesh_new] = meshgrid(v_lin_new,y_lin_new);
interpMethod = 'spline';
yv_intensity_interpolated = interp2(v_mesh_old,y_mesh_old,yv_intensity,v_mesh_new,y_mesh_new,interpMethod);
if draw
    figure;
    axesHandle = axes;
    surf(axesHandle,v_mesh_new,y_mesh_new,yv_intensity_interpolated,'facecolor','interp',...
                 'edgecolor','none',...
                 'facelighting','phong');
    view([0,90]);
end
end

