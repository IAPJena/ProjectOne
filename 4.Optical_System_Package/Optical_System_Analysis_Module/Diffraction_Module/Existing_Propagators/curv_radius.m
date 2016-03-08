function [rxo,ryo] = curv_radius(efd,wl,xp,yp,varargin)
%_________________________________________________________________
%
% Aufruf:
% [rxo,ryo] = curv_radius(efd,wl,xp,yp)
% [rxo,ryo] = curv_radius(efd,wl,xp,yp,rxi,ryi)
% 
% Schlagworte: 
% radius, field, curvature, optimization, sampling, substract  
%
% Kurzbeschreibung:  
% Compute the radius of curvature of a 2-dim. complex field in x- and y-section.
%
% Beschreibung: 
% Computation of the radius of curvature of a one-dimensional complex field with
% optimal match of the phase front to get a minimal extension of the Fourier spectrum.
% If the initial guess rxi, ryi are given, they are chosen as a starting point. If not, 
% a brute force search is performed to get a good starting value for the optimization. The
% numerical optimization is done in the following manner:
% 1. brute force initial value in the x- and y-section or taking the given values
% 2. Optimization of the two sections independently with the derivative-free algorithm 
%    in fminsearch. The criterion is the 2. moment of the Fourier spectrum, which 
%    should be optimal compact
% 3. Optimization of the two sections together in two dimension analog to 2.
%
% Version:   06.06.2008  Herbert Gross  Matlab 7.4      first version
% Owner: Herbert Gross
%
% Input:
%    efd(npx)      : complex field
%    wl            : wavelength
%    xp(npx)       : x-coordinate 
%    yp(npx)       : y-coordinate 
%
% varargin:
%    rxi           : initial guess for the radius in x. If rxi is only known with poor
%                    precision, it is better to omit this parameter
%    ryi           : initial guess for the radius in y. r
%
% Output:
%    rxo           : radius of curvature in x
%    ryo           : radius of curvature in y
%
% Abhängigkeiten in 1. Ordnung: curv_radius_1d
% Referenzen:   --  
% Beispiel:     --
% Testfile:     curv_radiusoptim_1d_test.m
% ToDo:         --
%_________________________________________________________________
%
if nargin >  4 ; rxi = varargin{1} ; else ; rxi = 0 ; end
if nargin >  5 ; ryi = varargin{2} ; else ; ryi = 0 ; end
%
npx  = length( xp );  npy = length( yp );
idamp = 1 ; 
%
%  x-direction
%
efdx = efd(npy/2+1,:).';
rxo = curv_radius_1d(efdx,wl,xp,rxi);
if rxo == 0 ; roxo = 0 ; else ; roxo = 1/rxo ; end
%
%  y-direction
%
efdy = efd(:,npx/2+1);
ryo = curv_radius_1d(efdy,wl,yp,ryi);
if ryo == 0 ; royo = 0 ; else ; royo = 1/ryo ; end
%
%  full two-dimensional
%
roxom = fminsearch( @(rox) mom2xy(efd,xp,yp,wl,roxo,royo,idamp),[roxo,royo]);
roxo = roxom(1) ; royo = roxom(2);
if roxo == 0 ; rxo = 0 ; else ; rxo = 1/roxo ; end 
if royo == 0 ; ryo = 0 ; else ; ryo = 1/royo ; end 
%




function mom = mom2xy(efd,xp,yp,wl,rox,roy,idamp)
%_________________________________________________________________
%
%    Berechnung der Fourier-Momente für eine Ebnung mit rox,roy
%
%    15.02.06   H.Gross
%    25.02.06   reduziertes Feld betrachtet
%_________________________________________________________________
%
%  Input :    xpm(npx)        : x-Koordinate
%             ypm(npy)        : y-Koordinate
%             efd(npy,npx)    : Inputfeld
%             wl              : Wellenlänge
%             rox             : Krümmung in x
%             roy             : Krümmung in y
%             idamp           : Optionsparameter Dämpfung berechnen
%                               0=berechnen, 1=schon bekannt 
%
%  Output :   momr            : Moment 
%_________________________________________________________________
%   
[npy,npx] = size(efd);
[xpm,ypm] = meshgrid(xp,yp);
%
jp = [-npx/2:1:npx/2-1]';   kp = [-npy/2:1:npy/2-1]';
[jpm , kpm] = meshgrid( jp , kp ) ; 
jqm = jpm.^2 ; kqm = kpm.^2 ;
%
%  Optional Dämpfungsfilter berechnen
%
if idamp > 0 ; 
     dampx = 0.25 * ( 1 + cos([-npx/2:npx/2-1].'/(npx/2-1)*pi ) ).^0.5  ; 
     dampy = 0.25 * ( 1 + cos([-npy/2:npy/2-1].'/(npy/2-1)*pi ) ).^0.5  ; 
     [dampmx , dampmy ] = meshgrid( dampx , dampy );
     damp = dampmy .* dampmx ; 
end
%
%  Ebnung und Momente berechnen
%
fakx = i * pi / wl * rox  ;  faky = i * pi / wl * roy  ;
efd  = efd .* exp( fakx * xpm.^2 + faky * ypm.^2 );
pspec = abs( fftshift( fft2(damp.*efd) )).^2; 
pspec =  damp .* pspec / max(max(pspec)) ;
mom = sqrt( sum(sum( (jqm+kqm) .* pspec ) )/(npx*npy) ); 
%








