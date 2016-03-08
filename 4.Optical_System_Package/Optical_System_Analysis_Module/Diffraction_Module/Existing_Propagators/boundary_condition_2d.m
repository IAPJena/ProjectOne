function efd = boundary_condition_2d(efd,ibdc,varargin)
%__________________________________________________________________________
%
% Aufruf:  efd = boundary_condition_2d(efd,ibdc)
%          efd = boundary_condition_2d(efd,ibdc,para)
% 
% Schlagworte: 
% Beam Propagation, split step method, finite differences, boundary condition  
%
% Kurzbeschreibung:  
% Calculation of the field boundary condition for split step propagators.
%
% Beschreibung:  
% Calculation of the field boundary condition for split step propagators.
% There are two options for the choice of the boundary condition:
% In the transparent boundary condition, the field leaves the computational domain 
% without reflection. The energy is not constant.
% In the absorbing boundary condition, the field is damped near the boundary to avoid 
% reflections. The energy remains constant, but the field ne3ar the boundary is wrong.
% 
% Version:  23.02.09  Herbert Gross  Matlab 7.4      first version
%           22.04.10  Tuning, nur 10% möglich
%
% Owner: Herbert Gross
%
% Input: 
%
%  efd(npy,npx)      : input field, the numbers of points must be a power of 2
%  ibdc              : switch for the choice of the boundary condition:
%                      ibdc = 0 : no special treatment of the field at the boundary
%                      ibdc = 1 : transparent boundary condition
%                      ibdc = 2 : absorbing boundary condition
%
% Varargin:
%
%  para              : parameter to control the extension of the width of the 
%                      absorbing boundary. Default : 40
%                      para > 40 : smaler range, para < 40 : broader range
%
% Output:
%
%  efd(npy,npx)      : output field as a function of x,y
%
% Abhängigkeiten in 1. Ordnung: --
% Referenzen: --
% Beispiel:  --
% Testfile: --
% ToDo : --
%_________________________________________________________________
% 
if nargin > 2 ; para = varargin{1} ; else ; para = 40 ; end
[npy,npx] = size(efd);
%
%  first case : transparent boundary condition
%
if ibdc == 1
%
    gamL = zeros(1,npx) ; gamR = zeros(1,npx);
    gamU = zeros(npy,1) ; gamO = zeros(npy,1) ;
    %
    efdcheck = max(abs(efd(2,:))) + max(abs(efd(npy,:))) + max(abs(efd(:,2))) + max(abs(efd(:,npx))) ;
    efdmax = max(max(abs(efd)));
    eps  = efdmax * 1.e-8 ;
    efdm = efdmax * 1.e-6 ;
%
    if efdcheck > efdm ;
          gamL = 0.5*( efd(4,1:npx)./( efd(5,1:npx) + eps ) ...
                    + efd(5,1:npx)./( efd(6,1:npx) + eps ) );
          gamR = 0.5*( efd(npy-2,1:npx)./( efd(npy-3,1:npx) + eps )...
                    + efd(npy-3,1:npx)./( efd(npy-4,1:npx) + eps )) ;
          gamU = 0.5*( efd(1:npy,4)./( efd(1:npy,5) + eps )...
                    + efd(1:npy,5)./( efd(1:npy,6) + eps ) );
          gamO = 0.5*( efd(1:npy,npx-2)./( efd(1:npy,npx-3) + eps )...
                    + efd(1:npy,npx-3)./( efd(1:npy,npx-4) + eps ) ) ;
%
          efd(3,1:npx) = efd(4,1:npx) .* gamL ;
          efd(2,1:npx) = efd(3,1:npx) .* gamL ;
          efd(npy-1,1:npx) = efd(npy-2,1:npx) .* gamR ;
          efd(npy  ,1:npx) = efd(npy-1,1:npx) .* gamR ;
%
          efd(1:npy,3) = efd(1:npy,4) .* gamU ;
          efd(1:npy,2) = efd(1:npy,3) .* gamU ;
          efd(1:npy,npx-1) = efd(1:npy,npx-2) .* gamO ;
          efd(1:npy,npx  ) = efd(1:npy,npx-1) .* gamO ;
          efd(:,1) = efd(:,2) ;     efd(1,:) = efd(2,:) ;
    end
end
%
%  second case: absorbing boundary condition
%
if ibdc == 2
    mex = para ;
    dax = 1 - (abs(cos(pi/(npx-1)*(npx-[1:npx])))).^mex ;
    day = 1 - (abs(cos(pi/(npy-1)*(npy-[1:npy])))).^mex ;
    [ dampx , dampy ] = meshgrid( dax , day );
    efd = efd .* dampx .* dampy ; 
end
%
%
