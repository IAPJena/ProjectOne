function [finalKostenbauderMatrix] = ...
    computeKostenbauderMatrixNumerically( optSystem,startSurf,startSurfInclusive,...
    endSurf, endSurfInclusive,pilotRay )
%computeKostenbauderMatrixNumerically: Computes the ray pulse matrix of an optical system
%or part of the optical system tracing rays with out using analytical
%formula

% First trace pilot ray with central wavelength and then compute the matrix
% for each surface and multiply.
c =  299792458;
format longE
format compact

% Default inputs
if nargin == 0
    disp('Error: The function computeSystemKostenbauderMatrix requires atleast the optical system object.');
    finalKostenbauderMatrix = NaN;
    interfaceKostenbauderMatrices = NaN;
    mediumKostenbauderMatrices = NaN;
    return;
elseif nargin == 1
    startSurf = 1;
    startSurfInclusive = 0;
    
    endSurf = optSystem.NumberOfSurfaces;
    endSurfInclusive = 0;
    % Take the chief ray as pilot ray
    pilotRay = getChiefRay(optSystem);
    centralRay = pilotRay(1);
elseif nargin == 2
    startSurfInclusive = 0;
    endSurf = optSystem.NumberOfSurfaces;
    endSurfInclusive = 0;
    % Take the chief ray as pilot ray
    pilotRay = getChiefRay(optSystem);
    centralRay = pilotRay(1);
elseif nargin == 3
    endSurf = optSystem.NumberOfSurfaces;
    endSurfInclusive = 0;
    % Take the chief ray as pilot ray
    pilotRay = getChiefRay(optSystem);
    centralRay = pilotRay(1);
elseif nargin == 4
    endSurfInclusive = 0;
    % Take the chief ray as pilot ray
    pilotRay = getChiefRay(optSystem);
    centralRay = pilotRay(1);
elseif nargin == 5
    % Take the chief ray as pilot ray
    pilotRay = getChiefRay(optSystem);
    centralRay = pilotRay(1);
else
   centralRay = pilotRay; 
end

delta_x0 = 0;
delta_y0 = 10^-9;
delta_dx0 = 0;
delta_dy0 = 10^-10;
delta_t0  = 10^-20;
delta_f0  = -2.825831444999529*10^12; % NB. For freqency (2um :=> 10^12 hz) b/c (3*10^8)/(600*10^-9)-(3*10^8)/(602*10^-9) = 1.6611e+12
delta_f0  = -3*10^12; % NB. For freqency (2um :=> 10^12 hz) b/c (3*10^8)/(600*10^-9)-(3*10^8)/(602*10^-9) = 1.6611e+12

% compute the resulting raypulse matrix in 3d and then determine the matrix
% elements
%[ delta_x,delta_y, delta_dx,delta_dy,delta_t,delta_f ] = 
% compute3DRayPulseVector(optSystem,delta_x0,delta_y0, delta_dx0,delta_dy0,
% delta_t0,delta_f0,centralRay,endSurfIndex, endSurfInclusive)

% for 1st column A, C and G
[ delta_x1,delta_y1, delta_dx1,delta_dy1,delta_t1,delta_f1 ] = ...
    compute3DRayPulseVector(optSystem,0,delta_y0, 0,0,0,0,centralRay,endSurf, endSurfInclusive);
A = delta_y1/delta_y0;
C = delta_dy1/delta_y0;
G = delta_t1/delta_y0;

% for 2nd column B, D and H
[ delta_x2,delta_y2, delta_dx2,delta_dy2,delta_t2,delta_f2 ] = ...
    compute3DRayPulseVector(optSystem,0,0, 0,delta_dy0,0,0,centralRay,endSurf, endSurfInclusive);
B = delta_y2/delta_dy0;
D = delta_dy2/delta_dy0;
H = delta_t2/delta_dy0;

% for 4th column E, F and I
[ delta_x4,delta_y4, delta_dx4,delta_dy4,delta_t4,delta_f4 ] = ...
    compute3DRayPulseVector(optSystem,0,0, 0,0,0,delta_f0,centralRay,endSurf, endSurfInclusive);
E = delta_y4/delta_f0;
F = delta_dy4/delta_f0;
I = delta_t4/delta_f0;

% compute G and F from relations in Kostenbauder
wav0 = centralRay.Wavelength;
% F = (wav0*H+E*D)/B;
% G = (E/wav0+A*H)/B;

% new relations derived 
G = (wav0*A*C*H+E*C)/(wav0*(A*D-1));
F = wav0*(D*G-E*C);

% % new relation derived 2
% H = (B*F-wav0*D*B*G)/(wav0*(1-D*A));
% E = wav0*(B*G-A*H);


finalKostenbauderMatrix = [A,B,0,E;
                            C,D,0,F;
                            G,H,1,I;
                            0,0,0,1];

end

