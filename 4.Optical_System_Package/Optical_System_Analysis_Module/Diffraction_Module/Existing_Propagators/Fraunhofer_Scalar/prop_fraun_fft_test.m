%
%  Test Fraunhofer-Propagator
%
%  Version: 02.02.08 H. Gross
%_________________________________________________________________________________________
%
clear ;  
% close all hidden; 
%
% npx  = 256 ;   npy = 256 ;             % Punktzahl = number of points
npx  = 256 ;   npy = 16/1;
wl  = 0.000328;                        % Wellenlänge in mm
m = 10 ;                                % Exponent Startprofil Supergauss
wox = 1 ;  woy = 1 ;                   % Start-Taillenradius
dux = 3*wox ; duy = 3*woy ;            % Durchmessergröße Startraster = Diameter size starting grid
dus = 0.1 ;                            % Durchmessergröße Zielraster = Diameter size target grid
z = 100 ;                              % Brennweite = focal length
rxstart = 100 ; rystart = 100 ;        % Krümmungsradien Start = Radii of curvature Start
%
%  Startraster   : xp, yp
%  Feld erzeugen : efd
%
[xp,yp] = grid_new(npx,npy,dux,duy);
[xs,ys] = grid_new(npx,npy,dus,dus);
[xpm,ypm] = meshgrid(xp,yp);
ampx = supergauss_amp(xp,m,wox); 
ampy = supergauss_amp(yp,m,woy); 
phasx = -(xp.^2)/(2*wl*rxstart)  ;    % Vorzeichen Krümmungsradius !
phasy = -(yp.^2)/(2*wl*rystart) ;     % Vorzeichen Krümmungsradius !
efd = field_2D_aniso(xp,yp,ampx,ampy,phasx,phasy);

% rpm = sqrt( xpm.^2+ypm.^2 );
% ind = find( rpm > wox);
% efd(ind) = 0 ;

%
%  Propagation 
%
tic
efds = prop_fraun_fft(xp,yp,efd,xs,ys,z,wl);
toc
% efds = prop_fraun_fft(xp,yp,efd,xs,ys,z+10,wl);
% efds = prop_fraun_fft(xp,yp,efd,xs,ys,z-10,wl);
%
%  Intensität normiert
%  Plot-Darstellung  
%

int = abs(efds).^2; 
int = int./max(max(int)); 
[xbm,ybm] = meshgrid(xs,ys);
% %% Old code
% % 
% figure;
% set( gcf, 'Units' , 'Normalized');
% set( gcf, 'Position', [ 0.58 , 0.55 , 0.4 , 0.4 ] );
% plot(xs,int(:,npy/2+1),'r-'); hold on; 
% plot(ys,int(npx/2+1,:),'b-'); %hold on; 
% set( gca, 'FontSize' , 12, 'fontweight','bold' );
% set(gcf,'Color',[1,1,1])
% %
% figure
% set( gcf, 'Units' , 'Normalized');
% set( gcf, 'Position', [ 0.58 , 0.05 , 0.4 , 0.4 ] );
% pcolor(xbm,ybm,int')
% %% end of old code

%% EnhancedColorPlot
figure;
ax = axes;
[ph,ah] = EnhancedPColor( {ax,xbm,ybm,int'} );
%% End of EnhancedColorPlot

shading(gca,'interp');
daspect(gca,[1 1 0.8 ])
set(gcf,'Color',[1,1,1])
set( gca, 'FontSize' , 12, 'fontweight','bold' );
