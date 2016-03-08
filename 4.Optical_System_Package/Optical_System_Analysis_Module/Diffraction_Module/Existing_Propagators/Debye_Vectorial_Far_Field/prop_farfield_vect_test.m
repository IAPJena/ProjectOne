%
%  Test Mansuripur's implmentation
%
%   27.07.08  H.Gross
%   15.07.13  G.Fente
%  
clear ; 
% close all hidden ;
%
% npx   = 128; npy = 128 ;             % sampling points
ff = 1; npx   = ff*256; npy = ff*256 ;             % sampling points

wl = 405e-9 ;
na = 0.95;                           % Numerical Aperture
scalx = 35 ; scaly = scalx ;
a = 1.0 ;
rcurv = a / na ; 
RE = wl /na/na;
dz = .0*RE ;                        % Defocus
ipol = 1 ;                          % 1=lin x, 2=lin y, 3=rad, 4=azi, 5=circ
%
z = rcurv + dz;
%
efd = ones(npy,npx,1);
dx = 2*a/(npx-2); xp = zeros(npx,1);
for j=1:npx ; xp(j) = -a-dx+dx*(j-1); end
dy = 2*a/(npy-2); yp = zeros(npy,1);
for j=1:npy ; yp(j) = -a-dy+dy*(j-1); end
[xpm,ypm] = meshgrid(xp,yp);
rpm = sqrt(xpm.^2+ypm.^2);
% if rcurv > 0 ; 
% efd = efd .* exp( 2*1i*pi/wl*(rcurv-sqrt(rcurv^2-rpm.^2)) ); end 
% //The if statement isn't nececessary for an aplanatic system.
% 
ind = find( rpm > a) ; efd(ind) = 0 ;
phi = atan2(ypm,xpm);
cophi = cos(phi);   siphi = sin(phi);
%_____________________________________________________________________________
%
% Polarization definition 
% Different polarization can be realized by varying the polarization number.
%
ipol =2 ;                     
if ipol ==1                              %x-polarization
   efdx = efd; efdy = zeros(npy,npx,1);
elseif ipol == 2                         %y-polarization
   efdy = efd; efdx = zeros(npy,npx,1);
elseif ipol == 3                         % radial polarization
   efdx = efd .* cophi ; efdy = efd .* siphi ;
elseif ipol == 4                         % azithmutal polarization
   efdx = -efd .* siphi ; efdy = efd .* cophi ;
elseif ipol == 5                         % circular polarization
   efdx = efd ; efdy = 1i*efd;
end
%
tic
[efdxs,efdys,efdzs,xs,ys] = prop_farfield_vect(efdx,efdy,wl,xp,yp,rcurv,dz,scalx,scaly);
toc
%

Ix=abs(efdxs).^2; Iy=abs(efdys).^2; Iz=abs(efdzs).^2;
Imax=max(max([Ix Iy Iz]));
%
% Normalization by the peak intensity
% 
Ix=Ix./Imax; Iy=Iy./Imax; Iz=Iz./Imax;
I=Ix+Iy+Iz; %incoherent normalized total intensity
Ixmax=max(max(Ix)); Iymax=max(max(Iy)); Izmax=max(max(Iz));
%
% Intensity plot
%
figure;

subplot(2,2,1)
imagesc(xs/wl,ys/wl,Ix);
axis equal;
axis xy;
axis tight;
title(['Ix ',num2str(Ixmax)])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );

subplot(2,2,2)
imagesc(xs/wl,ys/wl,Iy);
axis equal;
axis xy;
axis tight;
title(['Iy  ',num2str(Iymax)])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );

subplot(2,2,3)
imagesc(xs/wl,ys/wl,Iz);
axis equal;
axis xy;
axis tight;
title(['Iz  ',num2str(Izmax)])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );

subplot(2,2,4)
imagesc(xs/wl,ys/wl,I);
axis equal;
axis xy;
axis tight;
title(['I  ',num2str(max(max(I)))])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );


