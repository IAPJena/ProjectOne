function [ GVD, TOD ] = computeDispersion( optSystem, fieldIndex, centralWavelengthInM  )
%COMPUTEDISPERSION Computes the temporal dispersion of an optical system based on raytracing
% Method described in Donald C. O'Shea
% dispersionOrder: 2=> GDD, 3 => TOD,...(in future any order should be
% possibly computted)
% fieldIndex: Specify the direction of the rays
% centralWavelengthInM and wavelengthDeltaInM: The central wavelength and 
% small change in wavelength used for computation

if nargin == 0
    disp('Error: The function computeDispersion requires an optical object as argument.');
    GVD = NaN; 
    TOD = NaN;
    return ;    
elseif nargin == 1
    fieldIndex = 1;
    centralWavelengthInM = getPrimaryWavelength(optSystem);
elseif nargin == 2
    centralWavelengthInM = getPrimaryWavelength(optSystem);
else     
end
c =  299792458;
% According to O'Shea
wav0 = centralWavelengthInM;
lambda = [wav0-1.5*10^-7,wav0-0.5*10^-7,wav0+0.5*10^-7,wav0+1.5*10^-7];

% lambda = [0.4*10^-6,0.45*10^-6,0.75*10^-6];
% wav0 = 0.45*10^-6;

[ geometricalOpticalGroupPathLength ] = ...
    computePathLengths( optSystem, fieldIndex, lambda);
opl = (geometricalOpticalGroupPathLength(:,2))';
domega = 2*pi*c*(1./lambda(1:3)-1./lambda(2:4));
dphi = 2*pi*(opl(1:3)./lambda(1:3)- opl(2:4)./lambda(2:4));
tau = dphi./domega;
dtau = tau(1:2)-tau(2:3);
domega_average = (domega(1:2)+domega(2:3))/2;
gvd = dtau./domega_average;
gvd_average = (gvd(1)+gvd(2))/2;
GVD = gvd_average;
dgvd = gvd(1)-gvd(2);
TOD = dgvd/domega(2);    
end
