function matrix_plot(nzeil,nspalt,izeil,ispalt)
%___________________________________________________________________________________
%
%  Aufruf :  matrix_plot(nzeil,nspalt,izeil,ispalt)
%
%  Routine zum Zeichnen eines Teilplots aus einer Matrix mit fester 
%  Zeilen- und Spaltenzahl
%  Der Plot wird formatfüllend auf die Seite plaziert
%
%  Version :   23.02.03   H. Gross
%___________________________________________________________________________________
%
%  Input :        nzeil  : Anzahl der Zeilen
%                 nspalt : Anzahl der Spalten
%
%                 izeil  : aktuell Nr der Zeile
%                 ispalt : aktuell Nr der Spalte
%
%  Output :       -
%___________________________________________________________________________________
%
xwo = 1 / nspalt;
xw  = xwo * 0.9;
xl  = ( ispalt - 1 )*xwo + xwo/15 ;
%
yho = 1 / nzeil;
yh  = yho * 0.9;
yu  = ( nzeil - izeil )*yho + yho/20;
%
subplot('Position',[xl yu xw yh]);
%
