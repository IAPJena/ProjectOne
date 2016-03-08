function efelds = prop_fraun_fft(xp,yp,efeld,xs,ys,z,wl)
%_________________________________________________________________
%
%  Propagation of a complex field in farfield approximation in 2D.
%  in the case of a spherical wave it is assumed, that the field has a
%  radius of curvature very near to the propagation distance z
%
%  Version      :  2013-12-19   H.Gross
%_________________________________________________________________
%
%  Input :   xp(npx)         : x-coordinate pupil
%            yp(npy)         : y-coordinate pupil
%            efeld(npx,npy)  : Input field pupil
%            wl              : wavelength in mm
%            z               : distance of propagation
%            xs(npx)         : x-coordinate final plane
%            ys(npy)         : y-coordinate final plane
%
%  Output :  efelds(npx,npy) : output field
%_________________________________________________________________
%   
npx  = length( xp ); npy = length( yp );
nax  = max( xp ) / z ;   nay  = max( yp ) / z ; 
%
dx = abs( xs(2) - xs(1));  dy = abs( ys(2) - ys(1));
scalx = wl / ( 2 * dx * nax ) ;    scaly = wl / ( 2 * dy * nay ) ;
%
%  phase factor for z-plane
%
[ypm,xpm] = meshgrid( yp , xp );
v = pi * 1i / ( wl * z );
vn = 1/(npx*npy) ;
phas = exp( v*( xpm.^2 + ypm.^2 ) );
%
% Fourier transform
%
 efelds = czt_2d( efeld .* phas , scalx, scaly ,0 )*vn;

% % Try with my own written code and it works
% deltaInSpatial = [1,1];
% dimension = [1,2];
% scaleInFrequency = [scalx, scaly];
% efelds = computeCZFFT( efeld .* phas,...
%         deltaInSpatial,dimension,scaleInFrequency )*vn;
%

%  Correction of quadratic phase in final plane
%
[ysm,xsm] = meshgrid( ys , xs );
phas = exp( v * ( xsm.^2 + ysm.^2 ) );
efelds = efelds .* phas ;
%
