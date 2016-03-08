function [ delta_x,delta_y, delta_dx,delta_dy,delta_t,delta_f ] = ...
    compute3DRayPulseVector(optSystem,delta_x0,delta_y0,delta_dx0,delta_dy0,...
    delta_t0,delta_f0,centralRay,endSurfIndex, endSurfInclusive)
%compute3DRayPulseVector Determines the ray pulse vector at refernce plane
%in 3D space
% which is before/after a given surface for given  initial raypulse vector
% @ reference plane just after the Object surface
% endSurf, endSurfInclusive: Indices of the surface array where the
% the final ray pulse vector is required (index including the dummy
% surfaces)
% Inclusive => Use reference before start surface and that after the end
% surface. and vice versa

% all inputs and outputs are in SI units
c =  299792458;

if nargin == 0
    disp('Error: The function computeRayPulseVector requires atleast the optical system object and initial ray pulse vector.');
    delta_x= NaN;
    delta_y= NaN; 
    delta_dx= NaN;
    delta_dy= NaN;
    delta_t= NaN;
    delta_f= NaN;
    return;    
elseif nargin == 1    
    delta_x0 = 0;
    delta_y0 = 0;
    delta_dx0 = 0;
    delta_dy0 = 0;
    delta_t0 = 0;
    delta_f0 = 0;
    % Take the chief ray as central ray
    cheifRays = getChiefRay(optSystem);
    centralRay = cheifRays(1);
    % Use default values    
    endSurfIndex = optSystem.getNumberOfSurfaces;
    endSurfInclusive = 0;
elseif (nargin > 1 && nargin < 7)
    % Incomplete intitla ray pulse vector
    disp('Error: Incomplete intitla ray pulse vector.');
    delta_x= NaN;
    delta_y= NaN; 
    delta_dx= NaN;
    delta_dy= NaN;
    delta_t= NaN;
    delta_f= NaN;
    return;     
elseif (nargin == 7)
    % Take the chief ray as central ray
    cheifRays = getChiefRay(optSystem);
    centralRay = cheifRays(1);
    % Use default values    
    endSurfIndex = optSystem.getNumberOfSurfaces;
    endSurfInclusive = 0;    
elseif nargin == 8
    % Use default values    
    endSurfIndex = optSystem.getNumberOfSurfaces;
    endSurfInclusive = 0;
elseif nargin == 9
    endSurfInclusive = 0;
else
    
end
 
startSurface = 1;
endSurface = optSystem.getNumberOfSurfaces;
nSurface = optSystem.getNumberOfSurfaces;
nNonDummySurface = optSystem.getNumberOfNonDummySurfaces;
NonDummySurfaceArray = optSystem.getNonDummySurfaceArray;
NonDummySurfaceIndices = optSystem.getNonDummySurfaceIndices;

surfIndicesAfterStartSurface = find(NonDummySurfaceIndices>=startSurface);
startNonDummyIndex = surfIndicesAfterStartSurface(1);
surfIndicesBeforeEndSurface = find(NonDummySurfaceIndices<=endSurface);
endNonDummyIndex = surfIndicesBeforeEndSurface(end);
lensUnitFactor = getLensUnitFactor(optSystem);
lastGroupIndex = optSystem.getSurfaceArray(endNonDummyIndex-1).Glass.getGroupRefractiveIndex(centralRay.Wavelength);
% Compute the current ray parameter from the ray pulse vector and central ray
% Assume the ray is on the yz plane
% Check the ray is in yz plane
% if centralRay.Direction(1)~= 0
%     disp('Error: Centeral ray shall be in the yz plane.');
%     delta_x= NaN;
%     delta_y= NaN; 
%     delta_dx= NaN;
%     delta_dy= NaN;
%     delta_t= NaN;
%     delta_f= NaN;  
%     return;
% end

% central ray parameters
x0Central = centralRay.Position(1);
y0Central = centralRay.Position(2);
z0Central = centralRay.Position(3);
dx0Central = centralRay.Direction(1);
dy0Central = centralRay.Direction(2);
dz0Central = centralRay.Direction(3);
t0Central = 0;
f0Central = c/centralRay.Wavelength;

% current ray parameters
% All delat calues are defined in local reference axis of central ray
x0Current = x0Central + delta_x0;
y0Current = y0Central + delta_y0;
z0Current = z0Central;
dx0Current = dx0Central + delta_dx0;
dy0Current = dy0Central + delta_dy0;
dz0Current = sqrt(1 - (dx0Current^2 + dy0Current^2));
t0Current = t0Central + delta_t0;
f0Current = f0Central + delta_f0;

pos = [x0Current,y0Current,z0Current]';
dir = [dx0Current,dy0Current,dz0Current]';
wav = c/f0Current;

currentRay = ScalarRay(pos,dir,wav); 

% Additional path due to initial delay time
% initial group index
groupIndex =  1; % Assume air medium
initialPath = t0Current*c/groupIndex;

% trace the current and centeral ray
considerPolarization = 0;
recordIntermediateResults = 0;
considerSurfAperture = 1;
currentRayTraceResult = rayTracer(optSystem,currentRay, considerPolarization,...
    considerSurfAperture,recordIntermediateResults);
centeralRayTraceResult = rayTracer(optSystem,centralRay, considerPolarization,...
    considerSurfAperture,recordIntermediateResults);

% position and GPL in SI unit
centerRayPoint = centeralRayTraceResult(end,:).RayIntersectionPoint*lensUnitFactor;
centerRayDirection = centeralRayTraceResult(end,:).ExitRayDirection;
centerRayGroupPathLength = centeralRayTraceResult(end,:).TotalGroupPathLength*lensUnitFactor;

currentRayPoint = currentRayTraceResult(end,:).RayIntersectionPoint*lensUnitFactor;
currentRayDirection = currentRayTraceResult(end,:).ExitRayDirection;
currentRayGroupPathLength = currentRayTraceResult(end,:).TotalGroupPathLength*lensUnitFactor;

% central ray parameters
x1Central = centerRayPoint(1);
y1Central = centerRayPoint(2);
z1Central = centerRayPoint(3);
dx1Central = centerRayDirection(1);
dy1Central = centerRayDirection(2);
dz1Central = centerRayDirection(3);
t1Central = centerRayGroupPathLength/c;
f1Central = c/centralRay.Wavelength;

% current ray parameters
% All delat calues are defined in local reference axis of central ray

% Take the position in the plane perpendicular to the central ray and
% passing through centerRayPoint

linePoint = currentRayPoint;
lineVector = currentRayDirection;
planePoint = centerRayPoint;
planeNormalVector = centerRayDirection;       
[currentRayPositionShifted,distance] = computeLinePlaneIntersection(linePoint,lineVector,planePoint,planeNormalVector);  
        
x1Current = currentRayPositionShifted(1);
y1Current = currentRayPositionShifted(2);
z1Current = currentRayPositionShifted(3);
dx1Current = currentRayDirection(1);
dy1Current = currentRayDirection(2);
dz1Current = currentRayDirection(3);
t1Current = (initialPath + currentRayGroupPathLength + distance*lastGroupIndex)/c;
f1Current = c/currentRay.Wavelength;

% Compute the final ray pulse vector parameters
delta_x = x1Current - x1Central;
delta_y = y1Current - y1Central; 
delta_dx = dx1Current - dx1Central;
delta_dy = dy1Current - dy1Central;
delta_t = t1Current - t1Central;
delta_f = f1Current - f1Central;  
end

