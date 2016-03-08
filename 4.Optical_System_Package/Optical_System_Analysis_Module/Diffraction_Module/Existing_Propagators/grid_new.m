function [xn,yn] = grid_new(npx,npy,dux,duy)
%___________________________________________________________________________________
%
%  Erzeugen der linearen Koordinaten für ein neues Raster
%  Die Punktzahlen npx, npy müssen geradzahlig sein.
%  Die Mittenkoordinate mit x = 0 liegt beim Index npx/2+1, y analog
%  Die erste Stützstelle j = 1 liegt außerhalb des gewünschten Durchmessers.

% English...
% Generating the linear coordinates for a new grid
% The point numbers Npx and NPY must be even.
% The center coordinate x = 0 is at index npx/2+1, y analogous
% The first support point j = 1 is outside of the desired diameter,

%  Version :   02.02.08   	H. Gross
%___________________________________________________________________________________
%
%  Input :  npx      : Punktzahl in x
%           npy      : Punktzahl in y
%           rx       : Durchmesser in x-Richtung
%           ry       : Durchmesser in y-Richtung
%
%  Output : xn(npx)  : Rasterkoordinaten in x-Richtung = Scanning coordinate in the x direction
%           yn(npy)  : Rasterkoordinaten in y-Richtung
%___________________________________________________________________________________
%
xn = zeros(npx,1);
yn = zeros(npy,1);
%
dx = dux / ( npx-2 );
dy = duy / ( npy-2 );
%
xn = ( -dux/2 - dx : dx : dux/2 )' ;
yn = ( -duy/2 - dy : dy : duy/2 )' ;

%
        
        


