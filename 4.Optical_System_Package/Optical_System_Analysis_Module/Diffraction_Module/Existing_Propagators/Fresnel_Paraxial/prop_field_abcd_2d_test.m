%
%  Test Fresnel-Propagator nach Collins in zwei Dimensionen
%  Das System wird mittels der ABCD-Matrizen zusammengestellt
%
%  Version: 06.06.08 / H. Gross
%           21.07.08   R-Vorzeichen umgedreht, CZT-FFT, Vorzeichen bei Kippung
%                      korrigiert
%           07.02.10   Verschiedene Korrekturen
%_________________________________________________________________________________________
%% 
% Test Fresnel propagator according to Collins in two dimensions
% The system is assembled by means of the ABCD matrices
%
% Version: 6:06:08 / H. Gross
% 21:07:08 R-sign reversed, CZT FFT, sign in tilt corrected %
% 07:02:10 Various corrections

%%
clear ;  close all hidden; 
%
npx  = 256 ;   npy = npx ;             % Punktzahlen
wl  = 0.005;                          % Wellenlänge in mm
m = 2 ;                                % Exponent Startprofil Supergauss
dus = 1 ;                              % Durchmessergröße Zielraster
rx = 200 ; ry = 200 ;                    % Krümmungsradien Start, R>0 konvergent
xof = 0 ; yof = 0 ;                    % Offset
%
scalx = 4.00 ; scaly = scalx ;                % Skalenfaktoren
idampx = 0 ;  idampy = 0 ;             % Schalter Dämpfung Frequenzspektrum des Propagators
naxmax = 0.0 ; naymax = 0 ;              % Maximal aperturen in x/y für conjugierte Ebenen
xs = 0 ; ys = 0 ;                      % vorgegebene Zielraster
iptyp = 0 ;                            % Typ Propagator 0=Fresnel, 1=PWS 2=Sommerfeld
ipfix = 0 ;                            % vorgegebener Propagator 1=Ix-Ix , 2=Ox-Ix , 3=Ix-Ox , 4=Ox-Ox 
ipfiy = 0 ;                            % vorgegebener Propagator 1=Iy-Iy , 2=Oy-Iy , 3=Iy-Oy , 4=Oy-Oy 
iropt = 1 ;                           % Optimierung Krümmungsradien
iproxi = 0 ; iproyi = iproxi ;             %  vorgegebene Propagatoren
%
iplcomp = 1 ;                          % Plot Fehler
iplo = 2 ;                             % Plot Ergebnis 0 / 1 / 2
%
%  Systemmatrix für verschiedene Optionen bzw. Beispiele: 

% % System matrix for various options and examples:
%
% Case 1 : O-O
%  wox = 1.0000 ; woy = wox ;   rx = 200 ; ry = 200 ;     %
%  Startradius+Krümmung  == Start radius + curvature 
%  abcd = ABCD('dist',150);              abcdt=(abcd.'); abcdt=abcdt(:)'; 
%  iproxi = 4 ; iproyi = 4 ;
 
% Case 2 : O-I
wox = 4.0000 ; woy = wox ;   rx = 200 ; ry = 200 ;    % Startradius+Krümmung
abcd = ABCD('dist',200.0);            abcdt=(abcd.'); abcdt=abcdt(:)';

% Case 3 : I-I
% wox = 1.0000 ; woy = wox ;   rx = 2000 ; ry = 2000 ;   % Startradius+Krümmung
% abcd = ABCD('dist',500.0);             abcdt=(abcd.'); abcdt=abcdt(:)';

% Case 4 : I-O
% wox = 0.0050 ; woy = wox ;   rx = 00 ; ry = 00 ;    % Startradius+Krümmung
% abcd = ABCD('dist',500.0);            abcdt=(abcd.'); abcdt=abcdt(:)';

% Case 5 : O-O
% wox = 1.0000 ; woy = wox ;   rx = 00 ; ry = 00 ;    % Startradius+Krümmung
% abcd = ABCD('dist',20,'lens',100,'dist',50.0); abcdt=(abcd.'); abcdt=abcdt(:)';

% Case 6 : I-O
% wox = 0.00500 ; woy = wox ;   rx = 00 ; ry = 00 ;    % Startradius+Krümmung
% abcd = ABCD('dist',50,'lens',100,'dist',50);    abcdt=(abcd.'); abcdt=abcdt(:)';
%
abcdx = abcdt ; abcdy = abcdt ;
%
duox = 8*wox ;                         % Durchmessergröße Startraster
duoy = 8*woy ;
br = 1 ; brs = 1. ;              % Brechzahlen == refractive indices
%
%  Startraster   : xp, yp
%  Feld erzeugen : efd
%
dx = duox /(npx-2); xp = zeros(npx,1);
for j=1:npx ; xp(j) = -duox/2-dx +(j-1)*dx ; end
dy = duoy /(npy-2); yp = zeros(npy,1);
for j=1:npy ; yp(j) = -duoy/2-dy +(j-1)*dy ; end
% 
ampx = exp( -((xp-xof)/wox).^2 );ampy = exp( -((yp-yof)/woy).^2 );
[ampxm,ampym] = meshgrid(ampx,ampy);
phasx = ones(npx,1); phasy = ones(npy,1);
if abs(rx) > 0 ; phasx = ((xp-xof).^2)/(2*wl*rx)  ; end    
if abs(ry) > 0 ; phasy = ((yp-yof).^2)/(2*wl*ry) ;  end   
[phasxm,phasym] = meshgrid(phasx,phasy);
efd = ampxm.*ampym.*exp(2*i*pi*(phasxm+phasym));
teox = wl/pi/wox ;teoy = wl/pi/woy ;
%
%  Propagation 
%     
tic
[efds,xs,ys,rxs,rys,iprox,iproy,famp,Nfx,Nfy,Nfsx,Nfsy,ierr,sterr]=...
          prop_field_abcd_2d(efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,...
          iproxi,iproyi,xs,ys,br,brs,naxmax,naymax,iptyp,idampx,idampy) ;   
      toc
%
%  Intensität normiert
%
int = abs(efds).^2; 
int = int./max(max(int)); 
[xsm,ysm] = meshgrid(xs,ys);
%
%  Idealer Gauss
%
disp('---------------------------------------------------');
%
roxstart = 0 ; if abs(rx)>0 ; roxstart = 1/rx ; end
roystart = 0 ; if abs(ry)>0 ; roystart = 1/ry ; end
if roxstart==0 ; ztx = 0 ; else ; ztx = -rx/(1+(wl/pi*rx/wox/wox)^2);end
if roystart==0 ; zty = 0 ; else ; zty = -ry/(1+(wl/pi*ry/woy/woy)^2);end
zetx = pi * wox* wox / wl ;zety = pi * woy* woy / wl ;
%
wo = wox / sqrt(1+(pi*wox*wox/wl*roxstart)^2); brq = (pi*wox/wl*roxstart)^2 ;
wxideal = wox*sqrt( (wl*abcdx(2)/(pi*wox^2))^2 + (abcdx(1)-abcdx(2)*roxstart)^2 );
wo = woy / sqrt(1+(pi*woy*woy/wl*roystart)^2); brq = (pi*woy/wl*roystart)^2 ;
wyideal = woy*sqrt( (wl*abcdy(2)/(pi*woy^2))^2 + (abcdy(1)-abcdy(2)*roystart)^2 );
%
rxideal= -( (1/zetx*abcdx(2))^2 + ( abcdx(1) - abcdx(2)*roxstart )^2 )...
        /( ( abcdx(1) - abcdx(2)*roxstart )*( abcdx(3) - abcdx(4)*roxstart ) + abcdx(4)*abcdx(2)*zetx^(-2) );
ryideal= -( (1/zety*abcdy(2))^2 + ( abcdy(1) - abcdy(2)*roystart )^2 )...
        /( ( abcdy(1) - abcdy(2)*roystart )*( abcdy(3) - abcdy(4)*roystart ) + abcdy(4)*abcdy(2)*zety^(-2) );
%
%  Analyse des numerischen Ergebnisses:
%  Strahlradius und Korrelation
%
dxs = abs(xs(2)-xs(1));dys = abs(ys(2)-ys(1));
thresh = 0.1353 ;
intx = int(npy/2+1,:)';
wxnum = thresh_diam_1d(xs,intx,thresh)/2;
dwxs = abs( wxnum/wxideal-1);
inty = int(:,npx/2+1);
wynum = thresh_diam_1d(ys,inty,thresh)/2;
dwys = abs( wynum/wyideal-1);
%
intideal = exp( -2*(xsm/wxideal).^2 - 2*(ysm/wyideal).^2 );
ind = find( intideal > 0.001 ); npeff = numel(ind);
pnum = sqrt(1/npeff*sum(sum(dxs*dys*(intideal(ind)-int(ind)).^2)));
pnorm = sqrt(1/npeff*sum(sum(dxs*dys*intideal(ind).^2)));
rms = pnum/pnorm;
%
Mx = xs(npx)/xp(npx);
My = ys(npy)/yp(npy);
%
%  Textausgabe
%
if iprox ==1 ; tex = 'Ix-Ix (1)'; end
if iprox ==2 ; tex = 'Ox-Ix (2)'; end
if iprox ==3 ; tex = 'Ix-Ox (3)'; end
if iprox ==4 ; tex = 'Ox-Ox (4)'; end
if iproy ==1 ; tey = 'Iy-Iy (1)'; end
if iproy ==2 ; tey = 'Oy-Iy (2)'; end
if iproy ==3 ; tey = 'Iy-Oy (3)'; end
if iproy ==4 ; tey = 'Oy-Oy (4)'; end
%
%
disp(['Width-ideal   : wxi    = ',num2str(wxideal,'%10.6f'),'     wyi   = ',num2str(wyideal,'%10.6f')] ); 
disp(['Width-numeric : wxr    = ',num2str(wxnum,'%10.6f'),  '     wyr   = ',num2str(wynum,'%10.6f')] );
disp(['Width-diff    : dwx    = ',num2str(dwxs,'%10.6f'),   '     dwy   = ',num2str(dwys,'%10.6f')  ]);
disp(['Magnification : Mx     = ',num2str(Mx,'%10.6f'),     '     My    = ',num2str(My,'%10.6f') ]);
disp(['Curvature     : Rxsi   = ',num2str(rxideal,'%10.3f'),'     Rysi  = ',num2str(ryideal,'%10.6f') ]);
disp(['Curvature     : Rxsr   = ',num2str(rxs,'%10.3f'),    '     Rysr  = ',num2str(rys,'%10.6f')  ]);
disp(['Abweichung    : RmsPow = ',num2str(rms,'%10.6f') ])
disp(['Fresnel       : Nfx    = ',num2str(Nfx,'%10.6f'),    '     Nfy    = ',num2str(Nfy,'%10.6f') ])
disp(['Fresnel       : Nfxs   = ',num2str(Nfsx,'%10.6f'),   '     Nfys   = ',num2str(Nfsy,'%10.6f') ])
disp(['Propagator    : x      = ',tex,'    Propagator    : y     = ',tey]); 
disp(['ABCD-matrix   : ABCDx  = ',num2str(abcdx)] );
disp(['ABCD-matrix   : ABCDy  = ',num2str(abcdy)] );
if ierr > 0 ; disp(['Error : ',num2str(ierr)]);end
%
%  Plot-Darstellung  
%
if iplo > 0
%% Old code for 1D cross section plotting
% % 1D cross section
%    if iplo > 1
%    figure;
%    set( gcf, 'Units' , 'Normalized');
%    set( gcf, 'Position', [ 0.58 , 0.52 , 0.4 , 0.4 ] );
%    plot(xs,int(npy/2+1,:),'r-'); grid on ;
%    set(gca,'XLim',[ -abs(xs(2)) abs(xs(npx)) ])
%    hold on; 
%    plot(ys,int(:,npx/2+1),'b-'); 
%    title('x','color','r')
%    set( gca, 'FontSize' , 12, 'fontweight','bold' );
%    set(gcf,'Color',[1,1,1])
%    end
%% End of Old code
   figure;  
%% Old code
%    ah = axes;
%    ph = pcolor(xsm,ysm,int);
%% End of Old code

%% EnhancedColorPlot
   [ph,ah] = EnhancedPColor( {xsm,ysm,int} );
%% End of EnhancedColorPlot

   set( gcf, 'Units' , 'Normalized');
   set( gcf, 'Position', [ 0.58 , 0.05 , 0.4 , 0.4 ] );

   shading(ah, 'flat');
   daspect(ah,[1 1 0.8 ])
   set(gcf,'Color',[1,1,1])
   set( gca, 'FontSize' , 12, 'fontweight','bold' );
%
end
%
if iplcomp > 0
figure
%% Old code    
% ah = axes;
% ph = pcolor(xsm,ysm,(int-intideal));
%% End of Old code

%% EnhancedColorPlot
[ph,ah] = EnhancedPColor( {xsm,ysm,(int-intideal)} );
%% End of EnhancedColorPlot

set( gcf, 'Units' , 'Normalized');
set( gcf, 'Position', [ 0.058 , 0.052 , 0.4 , 0.4 ] );

colorbar(ah);
shading(ah, 'flat');
daspect(ah,[1 1 0.8 ])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );
end
