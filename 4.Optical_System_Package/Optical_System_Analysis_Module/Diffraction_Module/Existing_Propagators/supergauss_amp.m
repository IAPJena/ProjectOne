function modamp = supergauss_amp(xp,m,w)
%___________________________________________________________________________________
%
%  Aufruf :  modamp = supergauss_amp(xp,m,w)
%
%  Berechnung einer eindimensionalen Super-Gauss-Amplitude.
%
% Calculation of a one-dimensional super-Gaussian amplitude.

%  Version :   06.03.03   H. Gross
%___________________________________________________________________________________
%
%  Input :  xp(np)     : Koordinatenraster
%           m          : Ordnung im Exponent, für m = 2 entsteht das Gaussprofil
%                        im Sonderfall m = 0 wird ein Rechteckprofil erzuegt
%           w          : Strahlradius
%
%
% Input: xp (np): coordinate grid
% M: order in the exponent, for m = 2 arises the Gaussian profile
% In the special case m = 0 is a rectangular profile erzuegt
% W: beam radius

%  Output : modamp(np) : Amplitude der Modenfunktion
%___________________________________________________________________________________
%
[ np ji ] = size( xp );
modamp = zeros(np,1);
%
ex = zeros(np,1);
if m == 0
    for j=1:np
        if abs(xp(j))< w ; modamp(j) = 1 ; end 
    end
else
%
   for j = 1 : np
      test = abs((xp(j)/w))^m ;
      if test > 40 ; 
          % ?????? why 40??
         modamp(j) = 0 ;
      else
         modamp(j) = exp( -test );
      end
   end
end
%

