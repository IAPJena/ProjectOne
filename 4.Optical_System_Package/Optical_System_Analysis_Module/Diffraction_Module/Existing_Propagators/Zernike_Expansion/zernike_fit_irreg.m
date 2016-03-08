function [cout,phasout,wrms,wpv] = zernike_fit_irreg(xp,yp,nzern,a,phasin)
%___________________________________________________________________________________
%
%  Aufruf :  
%
%  Berechnung der Zernikekoeffizienten auf einem irregulären Koordinaten-
%  raster durch least square Fit. Koordinaten und Phasenwerte sind linear
%  abgespeichert. 
%  Es sind maximal 64 Zernikes berücksichtigt
%
%  Version :   2010-04-02   H. Gross
%___________________________________________________________________________________
%
%  Input :  phasin(np)    : Input-Phasenfläche , skaliert in Lambda
%           a             : Normierungsradius Koordinaten
%           xp(np)        : x-Koordinatenvektoren
%           yp(np)        : y-Koordinatenvektoren
%           nzern         : Anzahl Zernikes
%
%  Output : cout(nzern)   : Zernikekoeffizienten in Lambda
%           phasout(np)   : Output-Phasenfläche , skaliert in Lambda
%           wrms          : Qualität der Anpassung, rms-Wert
%           wpv           : Qualität der Anpassung, Maximal-Wert
%___________________________________________________________________________________
%

% % Calculation of the Zernike coefficients on an irregular coordinate 
% % Grid by least square fit. Coordinates and phase values ??are linearly 
% % Stored.
% % Input: phasin (np): Input phase surface, scaled in lambda 
% % A: normalization radius coordinate 
% % Xp (np): x-coordinate vectors 
% % Yp (np): y-coordinate vectors 
% % nzern: number of Zernike 
% % 
% % Output: cout (nzern): Zernike coefficients in lambda 
% % Phasout (np): Output phase surface, scaled in lambda 
% % wrms: quality of the fit, the rms value 
% % wpv: quality of fit, maximum value

np   = length( xp );
%
zmat = zern_fun_irreg(nzern,xp,yp,a);
%
%  Phasenfläche und Zernikeflächen als Vektor formulieren
%
zmatinv = pinv( (zmat.') * zmat ) ;
wmat = phasin(:)' * zmat ;
cout = ( wmat * zmatinv )' ;
%
%  Abweichungen Original / Fit
%
phasout = zeros(np,1);
for j=1:nzern
phasout = phasout + cout(j) * zmat(:,j) ;
end
dwe = phasout-phasin;
%
%  PV- und Rms-Wert für synthetische Daten berechnen
%
wpv = max(abs( dwe));
wnor = numel( dwe );
wlin = sum( dwe ) / wnor;
wrms = sqrt( sum( ( dwe - wlin ).^2 ) / wnor );
%
% 