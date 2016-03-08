function [dia,ierr,sterr,xl,xr] = thresh_diam_1d(xp,yp,thresh)
%_________________________________________________________________
%
% Copyright by Carl Zeiss AG    
% Confidence: OD internal
%
% Aufruf:
% du = thresh_diam_1d(xp,zp,thresh)
% 
% Schlagworte:
% Durchmesser, Schwellwert
%
% Kurzbeschreibung:  
% Berechnung des Schwellwert-Durchmessers einer eindimensionalen Verteilung.  
%
% Beschreibung: 
% Berechnung des Schwellwert-Durchmessers einer eindimensionalen Verteilung.  
% Die Verteilung wird von beiden Seiten angetastet und bzgl. der gewünschten 
% relativen Höhe ausgewertet und linear interpoliert.
% 
% Version:  20.07.2008  Herbert Gross  Matlab 7.4      first version
%           06.08.2008  Korrektur
% Owner: Herbert Gross
%
% Input :    xp(np)        : Koordinatenmvektor
%            yp(np)        : Profilwerte, auch komplex möglich
%            thresh        : Relativer Schwellwerte 0...1
%
% Output:    dia           : Durchmesser           
%            ierr          : Fehlerflag 
%                            ierr=0  Kein Fehler
%                            ierr=1  Thresh nicht zwischen 0 und 1
%                            ierr=2  Schwelle liegt am Rand vor
%                            ierr=3  Feld ist konstant
%            sterr         : Fehlertext               
%
% Abhängigkeiten in 1. Ordnung: 
% -
%
% Referenzen:  - 
%
% Testfile: thresh_diam_1d_test
%_________________________________________________________________
%
np = length(xp); xl = 0 ; xr = 0 ;
dia = 0 ; ierr = 0 ; sterr = ' ';
if thresh <=0 || thresh >=1 ; ierr = 1 ; sterr='Falscher Wert für thresh';end
%   
%  Umspeicherung auf normiertes 1-D-Feld im ersten Index
%
y = abs( squeeze(yp) );
ymax = max(y); 
ymin = min(y);
y = y / ymax;
klinks = 0 ; krechts = 0 ;
if ymax-ymin < 1.e-8 ; ierr = 3 ; sterr='y-Werte sind konstant';end
if y(1)>thresh ;  
   klinks = 1 ;  ierr = 2 ; sterr='Schwellwert liegt am linken Rand vor';end
if y(np)>thresh ; 
   krechts = np-1  ; ierr = 2 ; sterr='Schwellwert liegt am rechten Rand vor';end
imax = find( y == 1 );
%
%  Linke Schwelle
%  klinks ist der Index davor
%
if klinks == 0
   ind = find( y(1:imax(1)) <= thresh );
   klinks = max(ind);
end
%
%  Rechte Schwelle
%  krechts ist der Index davor
%
if krechts == 0
   ind = find( y(imax(1):np) <= thresh );
   krechts = imax(1) - 2 + min(ind);
end
%
%  Genaue Breite linearinterpoliert
%
if krechts-klinks==0
    dia = 0 ;
elseif y(krechts+1)-y(krechts)==0
    dia = 0 ;
elseif y(klinks+1)-y(klinks)==0
    dia = 0 ;
else
%
   k=klinks;
   zl = xp(k)+(xp(k+1)-xp(k))*(thresh-y(k))/(y(k+1)-y(k));
   k=krechts;
   zr = xp(k)+(xp(k+1)-xp(k))*(thresh-y(k))/(y(k+1)-y(k));
   dia = abs( zr - zl );
%
end
%

      
