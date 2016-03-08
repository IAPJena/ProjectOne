function [totalFieldInFocalRegion] = computeTotalFocalFieldUsingFFT(...
    initialComplexAmplitude, wavelength,xp,yp,spotPlotRadius, focalLength, deltaZ)
%COMPUTETOTALFOCUSFIELDUSINGFFT Propagate the initial complex amplitude to
%a plane near focal plane for each spectralcomponents and add to get the
%total field in that palane

% For the spot display
npx = size(xp,2);
npy = npx;
dus = spotPlotRadius; % size to see the result
xs = linspace(-dus,dus,npx);
ys = xs;

c = 299792458;


nSpectrum = size(initialComplexAmplitude,3);
totalField = zeros();
z = focalLength + deltaZ;

for ss = 1:nSpectrum
    [xpm,ypm] = meshgrid(xp(ss,:),yp(ss,:));
    
    rpm = sqrt(xpm.^2+ypm.^2);
    
    wl = wavelength(ss);
    v = c/wl;
    % Add spherical phase correction to the input complex amplitude
    % as the existing diffraction code assumes the wavefront has
    % curvature = Z of propagation
    efd = initialComplexAmplitude(:,:,ss) .* exp(-1i*pi/(wl*z)*(rpm.^2));
    %  Propagation
    efds = prop_fraun_fft(xp(ss,:),yp(ss,:),efd,xs,ys,z,wl);
    
    totalField = totalField + (efds);
    
    %  totalField = totalField + (efds)*exp(1i*2*pi*v*100*10^-15);
    %  totalField = totalField + abs(efds).^2;
    %     figure
    %     surf(abs(efds).^2)
    %     totalIntensityDistribution = totalIntensityDistribution + abs(efds).^2;
end
totalFieldInFocalRegion = totalField;
end

