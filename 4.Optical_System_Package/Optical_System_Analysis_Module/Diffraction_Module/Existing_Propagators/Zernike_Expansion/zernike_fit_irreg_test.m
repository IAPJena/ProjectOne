%___________________________________________________________________________________
%
%   Test script for Zernike fit on irregular grids
%
%   Version :  2014-01-14    H.Gross
%___________________________________________________________________________________
%
clear ;
% close all hidden ;
%
npx = 64 ; npy = npx ;
Diax = 2.0 ; Diay = Diax ;
w = Diax/2*1.0  ; Dia = 2*w ;
wl = 0.0010 ;
%
czv = [0 0 0 0.1 -0.1 0 -0.10 0 0.12 0.05 0 0.1 -.13 0 0 .1]'; nzern = numel(czv);
%
iplot = [ 1 1 1 1 1 ];
%___________________________________________________________________________________
%
%  Calculation grid
%
dx = Diax /(npx-2); xp = [-Diax/2-dx:dx:Diax/2]';
dy = Diax /(npy-2); yp = [-Diax/2-dy:dy:Diax/2]';
[xpm,ypm] = meshgrid(xp,yp); rpm = sqrt( xpm.^2+ypm.^2 );
indi = find( rpm <= Dia/2 ); indo = find( rpm > Dia/2 );
%
%------------------------------------------------------------------------
%  Initial phase 
%
   phase = zeros(numel(indi),1);
   zern_fun = zern_fun_irreg(nzern,xpm(indi),ypm(indi),max(xp));
   for iz=1:nzern;     
       phase(:) = phase(:) + czv(iz)*zern_fun(:,iz); 
   end
%
[cout,phasout,wrms,wpv] = zernike_fit_irreg(xpm(indi),ypm(indi),nzern,w, phase );
%
%__________________________________________________________________________________
%
disp(['Wrms = ',num2str(wrms)])
dc = cout-czv;
for j=4:nzern
    if czv(j)<0 ; stri = '%8.5f'; si=' '; else ; stri = '%9.5f';si='  ';end
    if cout(j)<0 ; stro = '%8.5f';so=' ';  else ; stro = '%9.5f';so='  ';end
    if dc(j)<0 ; strd = '%8.5f';  else ; strd = '%9.5f';end
    if j<10 ; sd='  ';  else ; sd=' ';end
disp(['Nr ',num2str(j,'%3.0f'),sd,'  cin = ',si,num2str(czv(j),stri),...
    '  cout = ',so,num2str(cout(j),stro),'   dc = ',...
     num2str(dc(j),strd)])
end
disp('----------------------------------------------------------')
%























