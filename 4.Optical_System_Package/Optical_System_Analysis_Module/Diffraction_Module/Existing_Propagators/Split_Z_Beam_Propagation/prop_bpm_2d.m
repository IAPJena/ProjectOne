function [eout,zs,ener] = prop_bpm_2d_new(efd,wl,xp,yp,z,nz,nza,varargin)
%_________________________________________________________________
%
% Aufruf:
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza)
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar)
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar,ibro,bro,brv)
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar,ibro,bro,brv,ibdc)
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar,ibro,bro,brv,ibdc,param)
% [eout,zs,ener] = prop_bpm_2d(efd,wl,xp,yp,z,nz,nza,ibar,ibro,bro,brv,ibdc,param,iwa)
% 
% Schlagworte: 
% Beam Propagation, Fourier method, inhomogeneous media, split step method  
%
% Kurzbeschreibung:  
% Calculation of beam propagation with the Fourier method in 3 dimensions.
%
% Beschreibung:  
% Calculation of beam propagation with Fourier method in 3 dimensions.
% One z-step is divided into two steps, one takes the changes due to diffraction
% into account, the other half-step calculated the effect of a changing refractive index.
% An inhomogeneous refractive index is possible an must be imported as a three-
% dimensional distribution n(y,x,z). It is interpolated in the z-direction, the lateral
% grid must coincide with the computationsl grid.
% There are several possible options concerning the boundary conditions. One possibility 
% is to define no special condition. In this case, a finite field size at the boundarys 
% of the computational grid will cause errors. The other possibility is to define 
% transparent boundary conditions. Here no reflections take place, the field at the rim
% is outgoing, the energy of the beam decreases.
% In the last option, with the help of the switch parameter iwa, the wide-angle-
% propagator can be selcted.
% There are three different z-grids in the routine, which must be distinguished:
% 1. the computational grid, which determines the accuracy, nz steps
% 2. the grid of the transverse sections, which is exported from the routine and
%    can be used to plot the result. The nza steps must be smaller or even equal to nz.
% 3. the grid with nzb z-points of the given index profile. 
% If the number of the transverse points is chosen very high, a problem with the memory
% can occur with the 3D-matrices of the outcoming field matrix and the matrix of the 
% refractive index. 
% 
% Version:  27.07.08  Herbert Gross  Matlab 7.4      first version
%           05.09.08  H. Gross,  NaN im Feld efd sind erlaubt und werden durch 0 ersetzt
%           22.02.09  H. Gross, extending option with wide angle propagator
%
% Owner: Herbert Gross
%
% Input: 
%
%  efd(npy,npx)      : input field, the numbers of points must be a power of 2
%  wl                : wavelength
%  xp(npx)           : x-coordinate
%  yp(npy)           : y-coordinate
%  z                 : distance of propagation
%  nz                : number of computational z-steps
%                      If (nz-1) is not an integer multiple of (nza-1),
%                      nz is corrected internally
%  nza               : number of z-steps of output field
%
% Varargin:
%
%  ibar              : option 0/1 : waitbar shown [0]
%  ibro              : Switch : 
%                      0 = homogeneous refractive index, faster computation [0]
%                      1= inhomogeneous refractive index, linear interpolation
%  bro               : basic value of the refractive index [1]
%  brv(npy,npx,nzb)  : distribution of the refractive index n(y,x,z),
%                      The transverse domain must be equal to the xp-yp-grid.
%                      The domain must be equal to z, the axial grid can be different
%                      and is interpolated inside the routine.
%  ibdc              : option boundary condition [1]
%                      ibdc = 0 : no special boundary condition 
%                      ibdc = 1 : transparent boundary condition, this option seems
%                                 to be not working until now
%                      ibdc = 2 : absorbing boundary condition, a cos-shaped filter
%                                 is introduced on several grid points at the boundaries
%  param             : controlling the width of the absorbing boundary for ibdc=2. 
%                      Default: param = 40, param > 40: smaller absorbing range
%  iwa               : switch for wide-angle propagator 0/1 [0]
%
% Output:
%
%  eout(npy,npx,nza) : output field as a function of x,y,z
%  zs(nza)           : z-steps of the output field
%  ener(nza)         : energy of the output field inside the  computations domain
%
% Abhängigkeiten in 1. Ordnung: --
%
% Referenzen:  field propagation.doc
%
% Beispiel:  --
%
% Testfile: prop_bpm_2d_test.m
%
% ToDo:  -
%_________________________________________________________________
%  
npx = length(xp);  npy = length(yp);
dx = abs(xp(2) - xp(1)); dy = abs(yp(2)-yp(1));
efd(isnan(efd)) = 0 ;
%
if nargin < 8  ; ibar = 0 ; else ibar = varargin{1} ; end
if nargin < 9  ; ibro = 0 ; else ibro = varargin{2} ; end
if nargin < 10 ; bro = 1 ; else  bro = varargin{3} ; end
if nargin < 11 ; brv  = [1,1] ; else brv = varargin{4} ; end
if nargin < 12 ; ibdc = 1 ; else ibdc = varargin{5} ; end
if nargin < 13 ; param = 40 ; else param = varargin{6} ; end
if nargin < 14 ; iwa = 0 ; else iwa = varargin{7} ; end
%
eout = zeros(npy,npx,nza,1);
eout(:,:,1) = efd  ;
ener = zeros(nza,1);
ener(1) = sum(sum( abs(efd(1:npy,1:npx)).^2) ) ;
%
k = 2 * pi / wl ;
fak = pi / (2*wl) ;
%
if ibar > 0 ; h =   waitbar( 0 ,'progress of calculation')  ; end
%__________________________________________________________________________
%
%  z-grid  :  zs, dzs  output planes
%             nstep steps between output planes 
%
if nz < nza ; nz = nza ; end
dzs  = z / ( nza-1 ); zs = zeros(nza,1);
for j=1:nza ; zs(j) = (j-1) * dzs ; end ;
nstep = round ( ( nz-1) / ( nza - 1 ) ) ;
nz = nstep*(nza-1) + 1 ; dz = z / (nz-1) ;
%
%  frequency grid
%
dux = 1 / ( 2 * dx * npx ) * 4 ; duy = 1 / ( 2 * dy * npy ) * 4 ;
ulix = zeros(npx,1);  uliy = zeros(npy,1);
for j=1:npx ; ulix(j) = -npx/2*dux +(j-1)*dux ; end
for j=1:npy ; uliy(j) = -npy/2*duy +(j-1)*duy ; end
[ u2x , u2y ] = meshgrid( ulix , uliy );
%
%  precalculation of the z-interpolated refractive index
%
gam  = zeros(npy,npx,1);
if ibro == 1
   [ny1 nx1 nzb] = size(brv);
   jmi = zeros(nz,1); fra = zeros(nz,1) ; za = zeros(nz,1);
   for j=1:nz ; za(j) = (j-1)*dz ; end
   dzb = z / (nzb-1) ; zb = zeros(nzb,1);
   jmi(1) = 1 ; fra(1) = 0 ;
   jmi(nz) = nzb-1 ; fra(nz) = 1 ;
   for j=2:nz-1
      jmi(j) = 1+fix( za(j) / dzb) ;     
      fra(j) = ( za(j) - (jmi(j)-1) * dzb ) / dzb ;
   end
end
%
%  constant transfer function of free space   : difop
%  optional, a wide-angle propagator can be selected
%
if iwa == 0
difop = fftshift( exp( 1i*pi/4*dz*wl/bro*( u2x.^2 + u2y.^2 ) ) );
else
difop = fftshift( exp( 1i*pi/2*dz*wl./(bro+sqrt(bro^2+wl*wl/2/pi.*( u2x.^2 + u2y.^2 ))).*( u2x.^2 + u2y.^2 ) ) );
end
%___________________________________________________________________________________________
%
%  loop over the output-z-planes
%
for is = 1:nza-1
%
    if ibar > 0 ; waitbar( is/nza ); end
%
%  loop over all the computational z-steps
%
    for jz = 1 : nstep
%
       efd   = ifft2( fft2( efd ) .* difop );
%
%  optional inhomogeneous medium
%
      if ibro == 1
         gam(:,:) = brv(:,:,jmi(jz)).^2 + fra(jz)*( brv(:,:,jmi(jz)).^2 - brv(:,:,jmi(jz)+1).^2 )- bro^2 ;
         gam = exp( 1i*pi*dz/wl/bro .* gam );
         efd = efd .* gam ;
      end   
%
%  boundary condition
%
      efd = boundary_condition_2d(efd,ibdc,param); 
      efd(:,1) = efd(:,2) ;     efd(1,:) = efd(2,:) ;
%
    end
%
%  final calculation and filling the output field
%
    eout(1:npy,1:npx,is+1) = efd(1:npy,1:npx) ;
    ener(is+1) = sum(sum( (abs(eout(1:npy,1:npx,is+1)).^2)) ) ;
%
end
%
if ibar > 0 ; close(h); end
enerref = ener(1);
ener = ener / enerref   ;
%
