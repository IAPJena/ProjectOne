function rcurv = curv_radius_1d(efd,wl,xp,varargin)
%_________________________________________________________________
%
% Aufruf:
% rcurv = curv_radius_1d(efd,wl,xp)
% rcurv = curv_radius_1d(efd,wl,xp,rini)
% 
% Schlagworte: 
% radius, field, curvature, optimization, sampling, flatten, smooth, substract, plane   
%
% Kurzbeschreibung:  
% Computation of the radius of curvature of a one-dimensional complex field.
%
% Beschreibung: 
% Computation of the radius of curvature of a one-dimensional complex field with
% optimal match of the phase front to get a minimal extension of the Fourier spectrum.
% If the initial guess rini is given, it is chosen as a starting point. If not, a brute 
% force search is performed to get a good starting value for the optimization. The
% numerical optimization is done with the derivative-free algorithm in fminsearch, because
% the behaviour of the 2. moment of the Fourier spectrum is not a smooth function due
% to discretization effects.
%
% Version:   02.06.2008  Herbert Gross  Matlab 7.4      First version
%            08.10.2008  Beate Böhme    matlab 7.3 
%            24.12.2008  Herbert Gross  Korrektur nach Vorschlag L.Stoppe
% Owner: Herbert Gross
%
% Input:
%       efd(npx)      : complex field
%       wl            : wavelength
%       xp(npx)       : x-coordinate at start
%   varargin:
%       rini          : initial guess for the radius. If rini is only known with poor
%                       precision, it is better to omit this parameter
% Output:
%       rcurv         : radius of curvature 
%
% Abhängigkeiten in 1. Ordnung: --
% Referenzen:  --  
% Beispiel:    --
% Testfile:    curv_radius_1d_test.m
% ToDo:        rcurv_** obsolet
%_________________________________________________________________
% 
se = 0; sx = 0; rcurv = 0 ;
%
%  Special case of vanishing field
%
if sum(abs(efd(:)))== 0;  return;     end; 
if size(efd,1) == 1; se = 1; efd = efd'; end; 
if size(xp,1)  == 1; sx = 1; xp  =  xp'; end; 
%    
if nargin >  3 ; rini = varargin{1} ; else ; rini = 0 ; end
%
idamp = 1 ;
npx  = numel( xp ); 
if rini == 0 ; rox = 0 ; else ; rox = 1/rini ; end
%
%  numerical evaluation of a good starting value
%
nv = 501 ; roma = 0.5/max(xp) ;
if rini == 0
%
  dr = 2*roma/(nv-1);
  mom = zeros(nv,1);
  for j=1:nv
     roxa = -roma +(j-1)*dr;
     mom(j) = mom2(roxa,npx,efd,wl,xp,idamp);
  end
  momi = min(mom); ind = find( mom == momi ); ind = ind(1);
  rox =  -roma + (ind-1)*dr  ;
% 
end
%
%  Optimization of the radius
%
roxo = fminsearch( @(rox) mom2(rox,npx,efd,wl,xp,idamp),rox);
if roxo == 0 ; rcurv = 0 ; else ; rcurv = 1/roxo ; end 
%
%
%
%
function mox = mom2(rox,npx,efd,wl,xp,idamp)
%_________________________________________________________________
%  
%  Routine for the calculation of the second moment of the field efd
%  in one dimension with damping in the field and the spectrum.
%_________________________________________________________________
%
weps = sqrt(1.e-13); mox = 0 ;
damp = ones(npx,1); 
if idamp > 0 ; damp = 0.25 * ( 1 + cos([-npx/2:npx/2-1].'/(npx/2-1)*pi ) ).^0.5  ; end
jp = [-npx/2:1:npx/2-1]';  jqm = jp.^2 ; 
efd  = efd .* exp( -i*pi/wl*rox * xp.^2  );
pspec = abs( fftshift( fft(damp.*efd) )).^2; 
pspec =  pspec / max(pspec) ;
mox = sqrt( sum( jqm .* pspec .* damp ) / npx ) ; 
%


