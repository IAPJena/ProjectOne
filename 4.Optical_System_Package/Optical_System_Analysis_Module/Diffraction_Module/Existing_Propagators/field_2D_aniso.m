function ftwo = field_2D_aniso(xp,yp,ampx,ampy,phasx,phasy)
%___________________________________________________________________________________
%
%  Erzeugung eines zweidimensionalen komplexen Feldes aus der eindimensionalen
%  Feldern von Amplitude und Phase
%  Die Amplitude wird multiplikativ überlagert
%  Die Phase wir additiv überlagert
%

% Generating a two-dimensional complex field from the one-dimensional
% Fields of amplitude and phase
%, The amplitude is superposed on a multiplicative
% The phase we additively superimposed


%  Version :   04.02.06   H. Gross
%              02.02.08   Korrektur
%___________________________________________________________________________________
%
%  Input :  xp(np)        : x-Koordinate
%           yp(np)        : y-Koordinate
%           ampx(np)      : Amplitude im x-Schnitt
%           ampy(np)      : Amplitude im y-Schnitt
%           phasx(np)     : Phase im x-Schnitt
%           phasy(np)     : Phase im y-Schnitt
%
%
%  Output : ftwo(np,np)   : Zweidimensionales Feld
%___________________________________________________________________________________
%
npx = length( xp ); npy = length(yp);
ftwo  = zeros(npx,npy,1);
famp  = zeros(npx,npy,1);
fphas = zeros(npx,npy,1);
%
%  2D-Überlagerung zu komplexem Feld
%
v = 2 * pi * i ;
for j=1:npx
    for k=1:npy
        ampxy  = ampx(j) * ampy(k) ;
        phasxy = phasx(j) + phasy(k);
        ftwo(j,k) = ampxy * exp( v * phasxy );
    end
end
%

        
        


