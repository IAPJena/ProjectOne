%___________________________________________________________________________________
%
%   prop_bpm_2d_test
%
%   Test Beam Propagation in 3D with Fourier method.
%   There are three example cases prepared, which can be used alternatively by
%   out-commenting two of them.
%
%   Version      :  27.07.08    H.Gross
%___________________________________________________________________________________
%
clear; close all hidden ;
%___________________________________________________________________________________
%
%  Case 1 : Divergentes astigmatisches Gaussbündel, Start in Taille
%
npx =  128 ;   npy = 128 ;
wx = 0.050 ;   wy = 0.034 ; msg = 2 ;
z = 30.0  ;    bro = 1.0 ;  dux = 0.5 ;  duy = 0.5 ;
nz = 251 ;     nza = 51 ;   ibro = 0 ;
rcurvx = 0 ;   rcurvy = 0 ;  
%
%  Case 2 : Konvergentes Gaussbündel
%
% npx =  512 ;   npy = 512 ;
% wx = 0.600 ;   wy = 0.60  ; msg = 2 ;
% z = 40.0  ;    bro = 1.0 ;  dux = 8.0 ; duy = 6.0 ;
% nz = 401 ;     nza = 41 ;   ibro = 0 ;
% rcurvx = 50 ;   rcurvy = 50 ;  % Krümmung, fokussierend
%___________________________________________________________________________________
%
ibdc = 1 ;  param = 5 ;
dbro = -0.020 ; dzbro = 0.0 ; 
%
iplo1 = 1 ;                 % Plot-Optionen 1
iplo2 = 0 ;                 % Plot-Optionen 2 : H-Linien Isophoten
ibar = 1 ;                    %  Waitbar 0/1
%
%  Vorrechnungen
%
xp = [ -dux/2-dux/(npx-2) : dux/(npx-2) : dux/2 ]' ;
yp = [ -duy/2-duy/(npy-2) : duy/(npy-2) : duy/2 ]' ;
efd = zeros(npy,npx,1);
[xpm,ypm] = meshgrid(xp,yp);
wl = 0.0005 ;
efd = exp( -(xpm/wx).^msg -(ypm/wy).^msg );
if rcurvx > 0 ; efd = efd .* exp( i*pi/(wl*rcurvx)*xpm.^2 ); end
if rcurvy > 0 ; efd = efd .* exp( i*pi/(wl*rcurvy)*ypm.^2 ); end
%
% Inhomogeneous refractive index
%
nzb = 51 ;
brv = zeros(npy,npx,nzb,1) ;
if ibro == 1
   rpq = xpm.^2+ypm.^2 ;
   dzb = z / (nzb-1) ; zb = zeros(nzb,1);
   for j=1:nzb ; zb(j) = (j-1)*dzb ; end
   for jz=1:nzb
   brv(:,:,jz) = bro + dbro * 4 * rpq / (dux^2) .* ( 1 + dzbro * zb(jz)/z ) ;
   end
end
tic
%
%  Propagation
%
[exyz,zp,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar,ibro,bro,brv,ibdc,param);
%
%  Normierung in jeder z-Ebene
%
toc
ixyz = abs(exyz).^2 ;
for j=1:nza
 ima = max(max(ixyz(:,:,j)));
 ixyz(:,:,j) = ixyz(:,:,j) / ima ;
end
npy2 = round((npy+1)/2);
npx2 = round((npx+1)/2);
%
%  Profil in x am Ende
%
figure
set(gcf,'NumberTitle','off','Name','Distribution I(x), I(y) at final plane ');
set( gcf, 'Units' , 'Normalized');
set( gcf, 'Position', [ 0.1 , 0.53 , 0.4 , 0.4 ] );
plot(yp,ixyz(:,npx2,nza),'r-')
set(gca,'XLim',[xp(2) xp(npx) ]);
grid on
set( gca, 'FontSize' , 14 );
hold on
plot(xp,squeeze(ixyz(npy/2+1,:,nza)),'b-')
set(gcf,'Color',[1,1,1])
%
%  Graphik im x-z Schnitt
%
in = squeeze( ixyz( npy2 , 2:npx , : ) ) ;
[zpm,xpm] = meshgrid( zp,xp(2:npx) );
figure; 
set(gcf,'NumberTitle','off','Name','Distributions I(x,z) I(y,z) ');
set( gcf, 'Units' , 'Normalized');
set( gcf, 'Position', [ 0.52 , 0.03 , 0.47 , 0.9 ] );
matrix_plot(2,1,1,1);
contour(zpm,xpm,in,20); 
colormap(jet);
grid on ;
set( gca, 'FontSize' , 14 );
set(gca,'YLim',[ xp(2) xp(npx) ]);
set(gca,'XLim',[zp(1) zp(nza) ]);
set(gca,'ZLim',[ 0 1.03 ]);
%
%  Graphik im y-z Schnitt
%
in = squeeze( ixyz( 2:npy, npx2 , : ) ) ;
[zpm,ypm] = meshgrid( zp,yp(2:npy) );
matrix_plot(2,1,2,1);
contour(zpm,ypm,in,20); 
colormap(jet);
grid on ;
set( gca, 'FontSize' , 14 );
set(gca,'YLim',[ yp(2) yp(npy) ]);
set(gca,'XLim',[zp(1) zp(nza) ]);
set(gca,'ZLim',[ 0 1.03 ]);




















