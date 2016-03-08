function [efdxs,efdys,efdzs,xs,ys,ierr,sterr] = prop_farfield_vect(efdx,efdy,wl,xp,yp,rcurv,dz,...
                    scalx,scaly,varargin)
%_________________________________________________________________
%
% function call:
% [efdxs,efdys,efdzs,xs,ys,ierr,sterr] = prop_farfield_vect(efdx,efdy,wl,xp,yp,z,...
%                                              scalx,scaly,varargin)
% 
% Keywords:
% Debye Integral, Vectorial Diffraction, Focus, high NA
%
% Short description
% Vectorial Debye integral for a polarized pupil using Fourier Algorithm.
%
% Description
% 
% Calculation of the vectorial Debye integral for a polarized pupil by
% a fast Fourier algorithm. The starting polarizations are given as x- and
% y-component. Calculation is based on cylindrical coordinates, and the parallel 
% and perpendicular polarization of the field.
% 
% The coordinates of the image space are scaled by the focal length of the
% lens suited to Chirp-z-Transform as  
% dx' = Wl * z / ( 2 * scalx * xmax )
% The same relation applies to the y-coordinate.
% Thus the numerical aperture of the lens is implicitly specified by the maximum pupil
% plane vertex value.
%
% Alternatively the coordinates of the image space can be given as
% vectors.Then we can ignore the scale factor scalx and scaly.
% 
% Version:  26.07.2008  Herbert Gross  Matlab 7.4      first version
%           05.09.08    H. Gross,  NaN in field vectors efdx and efdy is
%                       allowed and replaced by 0.
%           15.07.13    Gashaw Fente English version and aplanatic
%                       correction
% OWner: Herbert Gross
%
% Input:      efdx(npy,npx)   : complex pupil function, x-component
%             efdy(npy,npx)   : complex pupil function, y-component
%             z               : focal length
%             wl              : Wavelength
%             xp(npx)         : Pupil coordinate x
%             yp(npx)         : Pupil coordinate y
%             scalx           : scale factor x
%             scaly           : scale factor y
% Varargin:
%             xs(npx)         : optional image-space coordinate xs(npx),
%                               scalx will be ignonerd.
%             ys(npy)         : optional image-space coordinate ys(npy), 
%                               scaly will be ignonerd.
%                               xs und ys must both be given.
% Output:     efdxs(npy,npx)  : x-component of the Electric field 
%             efdxy(npy,npx)  : y-component of the Electric field
%             efdzs(npy,npx)  : z-component of the Electric field
%             xs(npx)         : image cooridnate x
%             ys(npy)         : image coordinate y
%             ierr            : Error flag:
%                               ierr=0 : No error
%                               ierr=1 : scalx/scaly is small
%                               ierr=2 : False entry of xs/ys
%             sterr           : Error text
%
% Dependency file: 
% czt_2d
%
% Reference:  
% 1. Mansuripur, Distribution of light at and near the focus of 
%                high numerical aperture systems, JOSA A 3(1986)2086
% 2. Mansuripur, Certain computational aspects of vector diffraction problems,
%                JOSA A 6(1989)786
% 3. Mansuripur, Certain computational aspects of vector diffraction problems : erratum,
%                JOSA A10(1993)382
%
% Example: --
%
% Testfile: prop_farfield_vect_test
%
% ToDo: --
%_________________________________________________________________
%
z=rcurv;
ierr = 0 ; sterr = ' ';
npx = numel( xp );    npy = numel (yp );
dxp = xp(2) - xp(1) ; dyp = yp(2)-yp(1);
efdx(isnan(efdx)) = 0 ; efdy(isnan(efdy)) = 0 ;
%
% Target grid,input or calculation
%

if nargin == 9
   dxs = wl / ( 2 * scalx * xp(npx)/z ) ;  xs = zeros(npx,1);
   for j=1:npx ; xs(j) = (j-npx/2-1)*dxs ; end
   dys = wl / ( 2 * scaly * yp(npy)/z ) ;  ys = zeros(npy,1);
   for j=1:npy ; ys(j) = (j-npy/2-1)*dys ; end
elseif nargin > 9
   xs = varargin{1} ; 
   if numel(xs) == 1 && xs > 0 ;
      dxs = xs(1)/(npx-2);  xs = zeros(npx,1);
      for j=1:npx ; xs(j) = (j-npx/2-1)*dxs ; end
      scalx = wl / ( 2 * dxs * xp(npx)/z ) ;
   elseif numel(xs)==npx || sum(abs(xs))==0 ; 
      ierr = 2 ; sterr ='falsche Angabe xs/ys'; 
   else
      dxs = xs(2)-xs(1); scalx = wl / ( 2 * dxs * xp(npx)/z ) ;
   end
end
if nargin == 10
   ys = varargin{2} ;  
   if numel(ys) == 1 && ys > 0 ;
      dys = ys(1)/(npy-2);  ys = zeros(npy,1);
      for j=1:npy ; ys(j) = (j-npy/2-1)*dys ; end
      scaly = wl / ( 2 * dys * yp(npy)/z ) ;
   elseif numel(ys)==npy || sum(abs(ys))==0 ; 
      ierr = 2 ; sterr ='falsche Angabe xs/ys'; 
   else
      dys = ys(2)-ys(1); scaly = wl / ( 2 * dys * yp(npy)/z ) ;
   end
end
if scalx<1 || scaly<1 ; ierr = 1 ; sterr='scalx/scaly zu klein'; end
%
%  Input energy at the entrance pupil 
%
powi = dxp*dyp*( sum(sum(abs(efdx).^2)) + sum(sum(abs(efdy).^2)) );

%
% Unit vectors at the entrance pupil
%

NA=xp(end)/z;
[px,py] = meshgrid(1/z.*xp,1/z.*yp); 
pxyq = px.^2 + py.^2 ;   ind = find( sqrt(pxyq) <=NA );
pz = zeros(npy,npx,1);  
pz(ind) = sqrt( 1 - pxyq(ind) );
pxyq(npy/2+1,npx/2+1) =1.e-20 ;
%
% Apodization
%
apod = zeros(npy,npx,1);
apod(ind) = exp( 2*pi*1i*dz*pz(ind)/wl)./sqrt(abs(pz(ind)));%(1-pz(ind))/wl )  ;
efdx = efdx .* apod ; 
efdy = efdy .* apod ;
%
apodxx = ( pz.*px.^2 + py.^2 ) ./ pxyq ; 
apodxy = -px.*py.*(1-pz)./pxyq ;
apodyy = ( pz.*py.^2 + px.^2 ) ./ pxyq ; 
%
% Fourier Transform
%
efdxs = 1i*conj( czt_2d( ( efdx .* apodxx + efdy .* apodxy ) , scaly , scalx , 0 ) ) ; 
efdys = 1i*conj( czt_2d( ( efdx .* apodxy + efdy .* apodyy ) , scaly , scalx , 0 ) ) ; 
efdzs = 1i*conj( czt_2d( (-efdx .* px     - efdy .* py     ) , scaly , scalx , 0 ) ) ; 

% % Try with my own written code and it works
% deltaInSpatial = [1,1];
% dimension = [1,2];
% scaleInFrequency = [scalx, scaly];
% efdxs = 1i*conj( computeCZFFT( ( efdx .* apodxx + efdy .* apodxy ) , deltaInSpatial,dimension,scaleInFrequency ) ) ; 
% efdys = 1i*conj( computeCZFFT( ( efdx .* apodxy + efdy .* apodyy ) , deltaInSpatial,dimension,scaleInFrequency ) ) ; 
% efdzs = 1i*conj( computeCZFFT( (-efdx .* px     - efdy .* py     ) , deltaInSpatial,dimension,scaleInFrequency ) ) ; 

%
% Energy conservation
%
% powo = dxs*dys*( sum(sum(abs(efdxs).^2)) + sum(sum(abs(efdys).^2)) + sum(sum(abs(efdzs).^2)) );
% nor = sqrt(powi/powo );
% efdxs = nor * efdxs ;
% efdys = nor * efdys ;
% efdzs = nor * efdzs ;
%

























