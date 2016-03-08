function [efds,xs,ys,rxsg,rysg,iprox,iproy,famp,Nfx,Nfy,Nfsx,Nfsy,ierr,sterr]=...
prop_field_abcd_2d(efd,wl,xp,yp,abcdx,abcdy,varargin)
%_________________________________________________________________
%
%
% Aufruf:
% [efds,xs,ys,rxsg,rysg,iprox,iproy,famp,Nfx,Nfy,Nfsx,Nfsy,ierr,sterr]=prop_field_abcd_2d
%
% (efd,wl,xp,yp,abcdx,abcdy)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys,br)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys,br,brs)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys,br,brs,
%                                                                 naxmax,naymax)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys,br,brs,
%                                                           naxmax,naymax,iptyp)
% (efd,wl,xp,yp,abcdx,abcdy,rx,ry,iropt,scalx,scaly,iproxi,iproyi,xs,ys,br,brs,
%                                             naxmax,naymax,iptyp,idampx,idampy)
% 
% Schlagworte: 
% Propagation, Fresnel, diffraction, Collins, integral, abcd, field   
%
% Kurzbeschreibung:  
% 2-D-beam propagation in Fresnel approximation through paraxial orthogonal systems 
%
% Beschreibung:  
% Propagation of a complex field through a paraxial orthogonal ABCD-segment 
% in two dimensions.
% The computation is performed independently in the x- and y-section.
% Most of the parameters can be made different in x and y.
% The system is considered as to be orthogonal without mixing x- and
% y-components. The input-field may have coupling terms. 
% The control of the optimal choice of the algorithm is done 
% automatically if desired. This automatic may fail, if the parameters are
% critical. The case of a collimated beam is realized, if the divergence
% angle is less than 5 mrad. The critical value of the Fresnel number is
% chosen at Nf = 1. These values are arbitrary. If the automatic choice of
% the propagator fails, it must be chosen explicite by the user.
% In this case, the zero padding of the given profile, the scaling factor scalx
% and a control of a proper calculation of the spatial spectrum famp is recommended.
% Internal, the geometrical contributions of the phase curvature are removed
% to get a better conditioning of the Fourier transform. The geometrical contribution
% in the final plane is indicated at the output. If the beam undergoes an intermediate 
% focus, the direction of the coordinate system is not flipped.
% The absolute phase factor due to exp(ikz) is not taken into account in this routine.
% Usually, it is recommended to use the scaling factor to get a proper resolution of the
% spatial spectrum. This is controlled by the parameter scalx. In this case, the chirp-z-
% transform is used. If scalx = 1, the classical FFT is used internally to save 
% computational time.
% In the computation, the beam power should remain constant. This energie conservation
% can be violated, if the spectrum or the final beam is truncated. 
%
% 
% Version:  08.06.08  Herbert Gross  Matlab 7.4      first version
%           13.06.08  Erweiterung: auch 2x2-ABCD Matrizen möglich 
%           18.06.08  Verbesserung: nan entfernt
%           20.07.08  Sign of curvature reversed, sign of FFT/CZT, 
%                     smooth transition between FFT+CZT
%           20.02.09  Modified by Ingrid Schuster:  
%                     fft routines and call of chirp-z exchanged to prevent 
%                     flip of coordinate system
%           10.12.09  Correction by H. Gross for case I-O
%           07.02.10   Correction by H. Gross, starting values of rx, ry,
%                     Phase of O-I and I-O cases,
%                     Sign-reversal for single-FFT cases
%           13.10.10  Correction of finite indices br
%                     Correction of a special error case for nearly I-I
%
%  Input:
%    efd(npy,npx)  : complex 2d input field
%    wl            : wavelength
%    xp(npx)       : x-coordinate at start
%    yp(npy)       : y-coordinate at start
%    abcdx(4)      : paraxial matrix of transfer in x-section
%                    a matrix abcdx(2,2) is also possible
%    abcdy(4)      : paraxial matrix of transfer in y-section
%                    a matrix abcdy(2,2) is also possible
%
%  varargin:
%    rx            : radius of curvature in starting plane in x-section
%                    rx > 0 describes a convergent wave
%    ry            : radius of curvature in starting plane in y-section
%    iropt         : automatic optimization of inital curvatures rx, ry
%                    0= must be given, 1=automatic adaptation [ 0 ]
%                    if 1, rx, ry serves as starting guess values
%    scalx         : scale factor into frequency space in x-section
%                    scalx > 1 better resolution in frequency space       
%                    scalx = 1 corresponds to FFT and is faster
%    scaly         : scale factor into frequency space in y-section (see above)
%    iproxi        : fixed propagator type in x-section, internal choice is overwritten
%                    with this input, 0= no forced propagator
%                    1=Ix-Ix , 2=Ox-Ix , 3=Ix-Ox , 4=Ox-Ox 
%    iproyi        : fixed propagator type in y-section, internal choice is overwritten
%                    1=Iy-Iy , 2=Oy-Iy , 3=Iy-Oy , 4=Oy-Oy 
%    xs(npx)       : Option : fixed given exit coordinate grid in x-section
%    ys(npy)       : Option : fixed given exit coordinate grid in y-section
%    br            : refractive index in starting plane
%    brs           : refractive index in final plane
%    naxmax        : maximum apertur for cases O-O, I-I and I-O in x-section      
%                    naxmax = 0 : no truncation
%    naxmay        : maximum apertur for cases O-O, I-I and I-O in y-section      
%    iptyp         : type of x/y-propagator: 0=Fresnel 1=plane waves 2=Sommerfeld
%                    For 1+2 no separated propagation distances are possible Bx = By
%    idampx        : option : damping of frequency spectrum towards the rim in x
%                    idampx < 1 is the exponent of the cos-shape
%    idampy        : option : damping of frequency spectrum towards the rim in y
%
%  Output:   
%
%    efds(npy,npx) : complex field in final plane
%    xs(npx)       : final coordinate grid in x-section
%    ys(npy)       : final coordinate grid in y-section
%    famp(npy,npx) : absolute value of frequency spectrum
%    rxsg          : radius of curvature in the final plane in x-section,
%                    rxs > 0 is a divergent wave
%    rysg          : radius of curvature in the final plane in y-section,
%    iprox         : realized propagation type in x-section :
%                    1=Ix-Ix , 2=Ox-Ix , 3=Ix-Ox , 4=Ox-Ox 
%    iproy         : realized propagation type in y-section :
%                    1=Iy-Iy , 2=Oy-Iy , 3=Iy-Oy , 4=Oy-Oy 
%    ierr          : error flag:
%                    ierr = 0 : no error 
%                    ierr = 1 : determinante of matrix ist not consistent
%                    ierr = 2 : xs/ys is given with non-compatible length
%                    ierr = 3 : fixed xs causes sampling error
%                    ierr = 4 : wrong input value of scalx, scaly
%    sterr         : string with error comment
%
% Abhängigkeiten in 1. Ordnung:  czt_2d
%                                curv_radius
% Referenzen:  prop_field_abcd.doc  
% Beispiel: --
% Testfile: prop_field_abcd_2d_test.m
% ToDo:  1. different refractive indices not tested until now
%_________________________________________________________________
%

%  Defaults for optional input parameters
%

if nargin >  7 ; rx = varargin{1} ; ry = varargin{2} ; 
else ; rx = 0 ; ry = 0 ;end
if nargin >  8 ; iropt = varargin{3} ; else ; iropt = 0 ; end
if nargin > 10 ; scalx = varargin{4} ; scaly = varargin{5} ;
else ; scalx = 2 ; scaly = 2 ; end
if nargin > 12 ; iproxi = varargin{6} ; iproyi = varargin{7} ;
else ; iproxi = 0 ; iproyi = 0 ; end
if nargin > 14 ; xs = varargin{8} ;   ys = varargin{9} ; 
else ; xs = 0 ; ys = 0 ;end
if nargin > 15 ; br = varargin{10} ; else ; br = 1 ; end
if nargin > 16 ; brs = varargin{11} ; else ; brs = 1 ; end
if nargin > 18 ; naxmax = varargin{12} ;  naymax = varargin{13} ; 
else ; naxmax = 0 ;naymax = 0 ; end
if nargin > 19 ; iptyp = varargin{14} ; else ; iptyp = 0 ; end
if nargin > 21 ; idampx = varargin{15} ;  idampy = varargin{16} ; 
else ; idampx = 0 ; idampy = 0 ; end
%
%  check of matrix dimension
%
if size(abcdx) == [ 2 2 ] ; abcdx = abcdx' ; abcdx = abcdx(:) ; end
if size(abcdy) == [ 2 2 ] ; abcdy = abcdy' ; abcdy = abcdy(:) ; end
%
%  defaults
%
efd(find(isnan(efd)==1))=0 ;
npx  = numel( xp ); npy  = numel( yp );
ddx = abs( xp(2) - xp(1) );  ddy = abs( yp(2) - yp(1) );
xpmax = abs(xp(npx)); ypmax = abs(yp(npy));
efds = zeros(npy,npx,1);
ierr = 0 ; sterr = ' ' ;
iprox = 0 ; iproy = 0 ;
sx = zeros(npx,1); sy = zeros(npy,1);
Nfc = 1.0 ;                                     % critical Fresnel number
lawc = 0.005 ;                                  % critical value collimation
%
%  input error conditions
%
if sum(abs(xs)) == 0 || numel(xs) == 1 ; ixsfix = 0 ; else ixsfix = 1 ; end
if sum(abs(ys)) == 0 || numel(ys) == 1 ; iysfix = 0 ; else iysfix = 1 ; end
if ixsfix == 0 ; xs = zeros(npx,1); end
if iysfix == 0 ; ys = zeros(npy,1); end
detx = abs( br - brs*( abcdx(1)*abcdx(4)-abcdx(2)*abcdx(3)) );
if detx > 1.e-6 ; ierr = 1 ; sterr ='No consistence between indices abcdx matrix'; end
dety = abs( br - brs*( abcdy(1)*abcdy(4)-abcdy(2)*abcdy(3)) );
if dety > 1.e-6 ; ierr = 1 ; sterr ='No consistence between indices abcdy matrix'; end
%
if ixsfix == 1 && abs(npx-numel(xs))>0 ; ierr = 2 ; 
sterr ='incorrect length of the fixed grid vector xs'; end
if iysfix == 1 && abs(npy-numel(ys))>0 ; ierr = 2 ; 
sterr ='incorrect length of the fixed grid vector ys'; end
if scalx < 1 ; ierr = 4 ; sterr ='wrong value of scalex factor, must be s => 1'; end
if scaly < 1 ; ierr = 4 ; sterr ='wrong value of scaley factor, must be s => 1'; end
%
%  optional optimization of the best initial radii of curvature to flatten the field
%
if iropt > 0
[rx,ry] = curv_radius(efd,wl,xp,yp,rx,ry);
end
%
%  spatial frequencies sx, sy in 1/mm
%
dsx = 1 / ( npx * ddx * scalx );  sxmax = (npx/2-1)*dsx ;
for j=1:npx ;    sx(j) = -sxmax-dsx +(j-1)*dsx ; end ; 
%
dsy = 1 / ( npy * ddy * scaly );  symax = (npy/2-1)*dsy ;
for j=1:npy ;    sy(j) = -symax-dsy +(j-1)*dsy ; end ; 
%__________________________________________________________________________
%
%  second moment in x and y direction and beam widths
%
[xpm,ypm] = meshgrid( xp , yp );
pow = sum(sum(abs(efd).^2)) ;
wxmom = 2*sqrt( sum(sum( (xpm.^2).*abs(efd).^2 ))/pow );
wymom = 2*sqrt( sum(sum( (ypm.^2).*abs(efd).^2 ))/pow );
if rx == 0 ; roxmom = 0 ; else ; roxmom = 1/rx ; end
if ry == 0 ; roymom = 0 ; else ; roymom = 1/ry ; end
%
%  Propagation of w and R according to gaussian formulas
%
zoxi = wl /(pi*wxmom^2);
zoyi = wl /(pi*wymom^2);
wxsmom = wxmom * sqrt( (abcdx(2)*zoxi)^2 + ( abcdx(1) - abcdx(2)*roxmom )^2 );
wysmom = wymom * sqrt( (abcdy(2)*zoyi)^2 + ( abcdy(1) - abcdy(2)*roymom )^2 );
rxsmom =-( (zoxi*abcdx(2))^2 + ( abcdx(1) - abcdx(2)*roxmom )^2 )...
/( ( abcdx(1) - abcdx(2)*roxmom )*( abcdx(3) - abcdx(4)*roxmom ) + abcdx(4)*abcdx(2)*zoxi^2 );
rysmom =-( (zoyi*abcdy(2))^2 + ( abcdy(1) - abcdy(2)*roymom )^2 )...
/( ( abcdy(1) - abcdy(2)*roymom )*( abcdy(3) - abcdy(4)*roymom ) + abcdy(4)*abcdy(2)*zoyi^2 );
if rxsmom == 0 ; roxsmom = 0 ; else ; roxsmom = 1/rxsmom ; end
if rysmom == 0 ; roysmom = 0 ; else ; roysmom = 1/rysmom ; end
%
%  Fresnel numbers for case decision
%
Nfx  = wxmom*wxmom*abs(roxmom) / wl ;
Nfsx = wxsmom*wxsmom*abs(roxsmom) / wl ;
Nfy  = wymom*wymom*abs(roymom) / wl ;
Nfsy = wysmom*wysmom*abs(roysmom) / wl ;
%
lawx = wl/wxmom/br ;   lawy = wl/wymom ;
lawxs = wl/wxsmom  ;   lawys = wl/wysmom  ;
%__________________________________________________________________________
%
%  case selction in x
%
if rx == 0 ; rox = 0 ; else ; rox = 1/rx ; end
%
if iproxi > 0 ;    
iprox = iproxi ;
else 
if Nfx > Nfc && Nfsx > Nfc ;   iprox = 4 ;   end   %  O - O
if Nfx < Nfc && Nfsx > Nfc ;   iprox = 3 ;   end   %  I - O
if Nfx > Nfc && Nfsx < Nfc  ;  iprox = 2 ;   end   %  O - I
if Nfx < Nfc && Nfsx < Nfc ;   iprox = 1 ;   end   %  I - I
%
%  special cases with one side collimated
%
if iprox == 2 && lawxs < lawc ; iprox = 4 ; end
if iprox == 3 && lawx  < lawc ; iprox = 4 ; end
if iprox == 1 && lawxs < lawc && lawx  > lawc ; iprox = 3 ; end
if iprox == 1 && lawx  < lawc && lawxs > lawc ; iprox = 2 ; end
end
%
%  magnification in x
%
Mgeo = abcdx(1) - abcdx(2) * rox  ;
xdif = wl * abs(abcdx(2)) * sxmax ;
Mdif = xdif / xpmax ;
%
if iprox == 1 ;    Mx = abcdx(1);  end                   %  case 1 : I - I
if iprox == 2 ;    if abs(Mgeo)> Mdif ; Mx = Mgeo ;      %  case 2 : O - I
else ;             Mx = Mdif ;     end  ;end
if iprox == 3 ;    if abs(Mgeo)> Mdif ; Mx = Mgeo ;      %  case 3 : I - O
else ;             Mx = Mdif ;end; end     
if iprox == 4 ;    Mx = Mgeo  ;                 end      %  case 4 : O - O
%
%  fixed Mx in the case of given xs
%  corrected flattening radius rox for I-O and O-O 
%  corrected scaling scalx for I-I and O-I 
%
if ixsfix > 0 
Mx = max(xs)/xpmax;
if iprox == 4 || iprox == 3 ; rox = -(Mx-abcdx(1))/abcdx(2) ; end
if iprox == 1 || iprox == 2
xsmax = abs(xs(npx)) ; 
scalx = wl*abs(abcdx(2))*npx/(4*xsmax*xpmax);
if scalx < 1 ; ierr = 3 ; sterr = 'fixed xs causes sampling error'; end
dsx = 1 / ( npx * ddx * scalx );  sxmax = (npx/2-1)*dsx ;
for j=1:npx ;    sx(j) = -sxmax-dsx +(j-1)*dsx ; end ; 
end
else
xs  = xp * abs(Mx) ; 
end
%
%  geometrical curvature in the final plane : rxsg
%  1. no contribution for the case I-I
%  2. special cases of only one Fourier transforms I-O and O-I
%  3. purely geometrical case O-O with complete equivalence transform
%
if iprox == 1
    rxsg = 0 ; roxsg = 0 ;
elseif  iprox == 3 || iprox == 2
    if abs(abcdx(4)) >0 ; 
        rxsg = -abcdx(2)/abcdx(4) ;
        if abs(rxsg)>0 ; roxsg = 1/rxsg ; else ; roxsg = 0 ; end
    else
         rxsg = 0 ; roxsg = 0 ;
    end
else
    if abs( Mx*abcdx(4)-1 ) > 0 ; 
        rxsg = -( Mx*abcdx(2) ) / ( Mx*abcdx(4)-1 );   
        if abs(rxsg)>0 ; roxsg = 1/rxsg ; else ; roxsg = 0 ; end
    else
        rxsg = 0 ; roxsg = 0 ;
    end
end
%
%  effective propagation distance Beffx
%
Beffx = abcdx(2) / Mx  ;
%
%  Correction of the initial geometrical flattening curvature roxg as exact 
%  Fourier conjugated plane for the cases O-I and I-O with only one FFT.
%  No geometrical contribution in the case I-I
%
if iprox == 2 || iprox == 3
roxg = abcdx(1) / abcdx(2) ;
elseif iprox == 1
roxg = 0 ; 
else
roxg = rox ; 
end
%__________________________________________________________________________
%
%  case selection in y
%
if ry == 0 ; roy = 0 ; else ; roy = 1/ry ; end
%
if iproyi > 0 ;    
iproy = iproyi ;
else 
if Nfy > Nfc && Nfsy > Nfc ;   iproy = 4 ;   end   %  O - O
if Nfy < Nfc && Nfsy > Nfc ;   iproy = 3 ;   end   %  I - O
if Nfy > Nfc && Nfsy < Nfc  ;  iproy = 2 ;   end   %  O - I
if Nfy < Nfc && Nfsy < Nfc ;   iproy = 1 ;   end   %  I - I
%
%  special cases with one side collimated
%
if iproy == 2 && lawys < lawc ; iproy = 4 ; end
if iproy == 3 && lawy  < lawc ; iproy = 4 ; end
if iproy == 1 && lawys < lawc && lawy  > lawc ; iproy = 3 ; end
if iproy == 1 && lawy  < lawc && lawys > lawc ; iproy = 2 ; end
end
%
%  magnification in y
%
Mgeo = abcdy(1) - abcdy(2) * roy  ;
ydif = wl * abs(abcdy(2)) * symax ;
Mdif = ydif / ypmax ;
%
if iproy == 1 ;    My = abcdy(1);  end                       %  case 1 : I - I
if iproy == 2 ;    if abs(Mgeo)> Mdif ; My = Mgeo     ;      %  case 2 : O - I
else ;             My = Mdif ;     end     
end
if iproy == 3 ;    if abs(Mgeo)> Mdif ; My = Mgeo     ;      %  case 3 : I - O
else ;             My = Mdif ;end; end     
if iproy == 4 ;    My = Mgeo  ;                         end  %  case 4 : O - O
%
%  fixed My in the case of given ys
%  corrected flattening radius roy for O-O 
%  corrected scaling scalx for I-I and O-I 
%
if iysfix > 0 
My = max(ys)/ypmax;
if iproy == 4 || iproy == 3 ; roy = -(My-abcdy(1))/abcdy(2) ; end
if iproy == 1 || iproy == 2
ysmax = abs(ys(npy)) ; 
scaly = wl*abs(abcdy(2))*npy/(4*ysmax*ypmax);
if scaly < 1 ; ierr = 3 ; sterr = 'fixed ys causes sampling error'; end
dsy = 1 / ( npy * ddy * scaly );  symax = (npy/2-1)*dsy ;
for j=1:npy ;    sy(j) = -symax-dsy +(j-1)*dsy ; end ; 
end
else
ys  = yp * abs(My) ; 
end
%
%  curvature in the final plane : rysg
%  1. no contribution for the case I-I
%  2. special case of only one Fourier transforms I-O and O-I
%  3. purely geometrical case O-O with complete equivalence transform
%
if iproy ==1
    rysg = 0 ; roysg = 0 ;
elseif iproy == 3 || iproy == 2
    if abs(abcdy(4)) > 0 ; 
        rysg = -abcdy(2)/abcdy(4) ;
        if abs(rysg)>0 ; roysg = 1/rysg ; else ; roysg = 0 ; end
    else
        rysg = 0 ; roysg = 0 ;
    end
else
    if abs( My*abcdy(4)-1 ) > 0 ; 
        rysg = -( My*abcdy(2) ) / ( My*abcdy(4)-1 );   
        if abs(rysg)>0 ; roysg = 1/rysg ; else ; roysg = 0 ; end
    else
        rysg = 0 ; roysg = 0 ;
    end
end
%
%  effective propagation distance Beffy
%
Beffy = abcdy(2) / My  ;
%
%  Correction of the initial geometrical flattening curvature roxg as exact 
%  Fourier conjugated plane for the cases O-I and I-O with only one FFT.
%  No geometrical contribution in the case I-I
%
if iproy == 2 || iproy == 3
royg = abcdy(1) / abcdy(2) ;
elseif iproy == 1
royg = 0 ; 
else
royg = roy ; 
end
%__________________________________________________________________________
%
%  Computation :
%
%  matrices of final spatial coordinates and frequencies
%
[sxm,sym] = meshgrid( sx , sy );
[xsm,ysm] = meshgrid( xs , ys );
%
%  flattening of the input field if start outside the focal region 
%
if abs(roxg) > 0 ;  efd  = efd .* exp( -1i * pi / wl * roxg * xpm.^2 );  end
if abs(royg) > 0 ;  efd  = efd .* exp( -1i * pi / wl * royg * ypm.^2 );  end
%
%  Fourier or chirp-z-transform 
%  
if scalx == 1 && scaly == 1 
famp = fftshift(fft2(efd));
else
famp =  conj( czt_2d( efd , scaly , scalx , 0 ) );
end
%
%  optional damping the frequency spectrum
%
if idampx > 0
if idampx > 1 ; idampx = 0.5 ; end
dampx = zeros(npx,1); n2x = npx/2+1 ; ex = idampx ;
for j=1:npx ;  dampx(j) = 0.5 *( 1 + cos( (j-n2x)/n2x *pi ) );  end
dampx = abs( dampx ).^ex;
else
dampx = ones(npx,1);
end
if idampy > 0
dampy = zeros(npy,1); n2y = npy/2+1 ; ey = idampy ;
for j=1:npy ;  dampy(j) = 0.5 *( 1 + cos( (j-n2y)/n2y *pi ) );  end
dampy = abs( dampy ).^ey;
else
dampy = ones(npy,1);
end
if idampx > 0 || idampy > 0
[dampmx , dampmy ] = meshgrid( dampx , dampy );
famp = famp .* dampmx .* dampmy ; 
clear dampmx ; clear dampmy ;
end
%
%  optional truncation for finite aperture angle in selected cases
%  calculation of the decrease in beam power
%
if (   ( ( iprox == 4 || iprox == 3 || iprox == 1) && naxmax > 0 )...
|| ( ( iproy == 4 || iproy == 3 || iproy == 1) && naymax > 0 ) );
if naxmax > 0 ; sxtrunc = 2*naxmax/wl/br ; else ; sxtrunc = sxmax*1.1 ; end 
if naymax > 0 ; sytrunc = 2*naymax/wl/br ; else ; sytrunc = symax*1.1 ; end 
ind = find( abs(sxm)>sxtrunc | abs(sym)>sytrunc ); 
if numel(ind)>0 ; 
famp(ind) = 0 ; 
end
end
%
%  transport in frequency space, 2 different impulse response functions
%  iptyp = 0 : Fresnel approximation
%  iptyp = 1 : Plane wave propagation
%
if iptyp == 0                                              %  Fresnel
fakx = 1i*pi*wl*Beffx ;   faky = 1i*pi*wl*Beffy ;
famp = famp .* exp( fakx * sxm.^2 + faky * sym.^2  );
%
elseif iptyp == 1                                          %  plane waves
ilaq = (1/wl)^2 ;
famp = famp .* exp( 2*pi*1i* Beffx * sqrt( abs ( ilaq - sxm.^2 - sym.^2  )) );
%
end
%
%  inverse Fourier transform for O - O and I - I and return to space domain
%  reverse direction of the spatial x-coordinate, if Mx < 0
%  reverse direction of the spatial y-coordinate, if My < 0
%  1. both sections
%  2. only x-section
%  3. only y-section
%
if ( iprox == 1 || iprox == 4 ) && ( iproy == 1 || iproy == 4 ) 
if scalx == 1 && scaly == 1
efds = ifft2(ifftshift(famp));  % version Schuster
else
efds =  czt_2d( famp , scaly , scalx , 0 )  / ( npx*npy*scalx*scaly ); 
end
%
elseif ( iprox == 1 || iprox == 4 ) && ( iproy == 2 || iproy == 3 ) 
efds =  czt_2d( famp , scaly , scalx , 2 )  / (npx*scalx*sqrt(scaly*npy)); 
%
elseif ( iprox == 2 || iprox == 3 ) && ( iproy == 1 || iproy == 4 ) 
efds =  czt_2d( famp , scaly , scalx , 1 )  / (npy*scaly*sqrt(npx*scalx)); 
%
elseif ( iprox == 2 || iprox == 3 ) && ( iproy == 2 || iproy == 3 ) 
efds = famp / (sqrt(npy*scaly*npx*scalx)); 
end
if Mx < 0 ;     efds(:,2:npx) = efds(:,npx:-1:2) ;end
if My < 0 ;     efds(2:npy,:) = efds(npy:-1:2,:) ;end
if iprox == 3 || iprox == 2 ;  efds(:,2:npx) = efds(:,npx:-1:2) ;end
if iproy == 3 || iproy == 2  ; efds(2:npy,:) = efds(npy:-1:2,:) ;end
%__________________________________________________________________________
%
%  Scaling of the spectrum famp
%  correction of the field for the final geometrical curvature 
%
famp = abs( famp ); famp = famp / max(max(famp));
if abs(roxsg) > 0 ;  efds = efds .* exp(  1i*pi*roxsg/wl * xsm.^2   ); end
if abs(roysg) > 0 ;  efds = efds .* exp(  1i*pi*roysg/wl * ysm.^2   ); end
%
%  correction for sign-oscillation, if only one FFT is performed
%  and the original FFT is used
%
if ( iprox == 2 || iprox == 3 ) && scalx == 1 && scaly == 1
   revers = (-1).^[1:npx] ;
   for k=1:npy ;   efds(k,:) = efds(k,:) .* revers; end
end
if ( iproy == 2 || iproy == 3 ) && scalx == 1 && scaly == 1
   revers = (-1).^[1:npy]' ;
   for j=1:npx ;   efds(:,j) = efds(:,j) .* revers; end
end
%
















