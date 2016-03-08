function [ dy,du,dt,df ] = computeRayPulseVector(optSystem,dy0,du0,dt0,df0,centralRay,endSurfIndex, endSurfInclusive)
%COMPUTERAYPULSEVECTOR Determines the ray pulse vector at refernce plane 
% which is before/after a given surface for given  initial raypulse vector
% @ reference plane just after the Object surface
% endSurf, endSurfInclusive: Indices of the surface array where the
% the final ray pulse vector is required (index including the dummy
% surfaces)
% Inclusive => Use reference before start surface and that after the end
% surface. and vice versa
c =  299792458;

if nargin < 5
    disp('Error: The function computeRayPulseVector requires atleast the optical system object and initial ray pulse vector.');
    dy = NaN;
    du = NaN;
    dt = NaN;
    df = NaN;
    return;    
elseif nargin == 5
    % Take the chief ray as central ray
    cheifRays = getChiefRay(optSystem);
    centralRay = cheifRays(1);
    % Use default values    
    endSurfIndex = optSystem.NumberOfSurfaces;
    endSurfInclusive = 0;    
elseif nargin == 6
    % Use default values    
    endSurfIndex = optSystem.NumberOfSurfaces;
    endSurfInclusive = 0;
elseif nargin == 7
    endSurfInclusive = 0;
else
    
end
 
startSurface = 1;
endSurface = optSystem.NumberOfSurfaces;
nSurface = optSystem.NumberOfSurfaces;
nNonDummySurface = optSystem.NumberOfNonDummySurfaces;
NonDummySurfaceArray = optSystem.NonDummySurfaceArray;
NonDummySurfaceIndices = optSystem.NonDummySurfaceIndices;

surfIndicesAfterStartSurface = find(NonDummySurfaceIndices>=startSurface);
startNonDummyIndex = surfIndicesAfterStartSurface(1);
surfIndicesBeforeEndSurface = find(NonDummySurfaceIndices<=endSurface);
endNonDummyIndex = surfIndicesBeforeEndSurface(end);
lensUnitFactor = getLensUnitFactor(optSystem);
lastGroupIndex = optSystem.getSurfaceArray(endNonDummyIndex-1).Glass.getGroupRefractiveIndex(centralRay.Wavelength);
% Compute the current ray parameter from the ray pulse vector and central ray
% Assume the ray is on the yz plane
% Check the ray is in yz plane
if centralRay.Direction(1)~= 0
    disp('Error: Centeral ray shall be in the yz plane.');
    dy = NaN;
    du = NaN;
    dt = NaN;
    df = NaN;    
    return;
end
% objThickness = optSystem.NonDummySurfaceArray(1).Thickness;
% if objThickness > 10^10
%     objThickness = 0;
% end


u0Central = sign(centralRay.Direction(2))*acos(centralRay.Direction(3));
t0Central = 0;
f0Central = c/centralRay.Wavelength;
y0Central = centralRay.Position(2);
z0Central = centralRay.Position(3);

u0Current = u0Central + du0;
t0Current = t0Central + dt0;
f0Current = f0Central + df0;
y0Current = y0Central+dy0*cos(u0Central);
z0Current = z0Central-(dy0*sin(u0Central));

pos = [0,y0Current,z0Current]';
dir = [0,sin(u0Current),cos(u0Current)]';
wav = c/f0Current;

currentRay = ScalarRay(pos,dir,wav); 

% Additional path due to initial delay time
% initial group index
groupIndex =  1; % Assume air medium
initialPath = t0Current*c/groupIndex;

% trace the current and centeral ray
considerSurfAperture = 1;
recordIntermediateResults = 0;
currentRayTraceResult = rayTracer(optSystem,currentRay, considerSurfAperture,recordIntermediateResults);
centeralRayTraceResult = rayTracer(optSystem,centralRay, considerSurfAperture,recordIntermediateResults);

% Determine the intersection points in the final refernce plane
planePoint = centeralRayTraceResult(:,end).RayIntersectionPoint;
planeNormalVector = centeralRayTraceResult(:,end).ExitRayDirection;

centerRayPoint = centeralRayTraceResult(:,end).RayIntersectionPoint;
centerRayDirection = centeralRayTraceResult(:,end).ExitRayDirection;

currentRayPoint = currentRayTraceResult(:,end).RayIntersectionPoint;
currentRayDirection = currentRayTraceResult(:,end).ExitRayDirection;

centerRayIntersection = computeLinePlaneIntersection(centerRayPoint,centerRayDirection,planePoint,planeNormalVector);
currentRayIntersection = computeLinePlaneIntersection(currentRayPoint,currentRayDirection,planePoint,planeNormalVector);

% Compute the final ray pulse vector parameters
u1Central = sign(centerRayDirection(2)) *acos(centerRayDirection(3));
t1Central = (centeralRayTraceResult(:,end).TotalGroupPathLength)*lensUnitFactor/c;
f1Central = c/centralRay.Wavelength;
y1Central = centerRayIntersection(2)*lensUnitFactor;
z1Central = centerRayIntersection(3)*lensUnitFactor;

% Extra path from the refernce palne to the image plane that should be
% considered in the last path length 
y1Current = currentRayIntersection(2)*lensUnitFactor;
z1Current = currentRayIntersection(3)*lensUnitFactor;
extraPathLength = sign(z1Current-z1Central)*(sqrt((y1Current-currentRayPoint(2)*lensUnitFactor)^2+(z1Current-currentRayPoint(3)*lensUnitFactor)^2));
u1Current = sign(currentRayDirection(2)) *acos(currentRayDirection(3));
t1Current = (currentRayTraceResult(:,end).TotalGroupPathLength*lensUnitFactor + extraPathLength*lastGroupIndex)/c;
f1Current = c/currentRay.Wavelength;


% Compute the final ray pulse parameters
dy = sign(y1Current-y1Central)*sqrt((y1Current-y1Central)^2+(z1Current-z1Central)^2);
du = u1Current-u1Central;
dt = t1Current-t1Central;
df = f1Current-f1Central;


% % Determine the final reference plane
% [ refCoordinateBeforeSurf,  refCoordinateAfterSurf] = computeRayPulseReferenceCoordinates( optSystem,centralRay );
% 
% if endSurfInclusive
%    finalRefernceCoordinate =  refCoordinateAfterSurf(:,:,endNonDummyIndex); 
%    % get two points of intersection for nonDummyEndSurfIndex and
%    % nonDummyEndSurfIndex+1
%    point1 = currentRayTraceResult(endNonDummyIndex,:).RayIntersectionPoint;
%    point2 = currentRayTraceResult(endNonDummyIndex+1,:).RayIntersectionPoint;
% else
%    finalRefernceCoordinate =  refCoordinateBeforeSurf(:,:,endNonDummyIndex);
%    % get two points of intersection for nonDummyEndSurfIndex-1 and nonDummyEndSurfIndex
%    point1 = currentRayTraceResult(endNonDummyIndex-1,:).RayIntersectionPoint;
%    point2 = currentRayTraceResult(endNonDummyIndex,:).RayIntersectionPoint;   
% end
% 
% % Compute intersection of the current ray with the final referce plane (the
% % xy plane from the reference coordinate) localPosition,surfaceCoordinateTM
% linePoint1 = point1;
% linePoint2 = point2;
% planePoint1 = localToGlobalPosition([0;0;0],finalRefernceCoordinate);
% planePoint2 = localToGlobalPosition([1;0;0],finalRefernceCoordinate);
% planePoint3 = localToGlobalPosition([0;1;0],finalRefernceCoordinate);
% linePlaneIntersection = computeLinePlaneIntersection(linePoint1,linePoint2,planePoint1,planePoint2,planePoint3);

% % Compute the final ray pulse vector parameters
% Y1Centeral = finalRefernceCoordinate(2,4);
% U1Central = centralRay.Direction(3);
% T1Central = 0;
% F1Central = c/centralRay.Wavelength;
% 
% Y1Current = Y0Centeral + dy0;
% U1Current = U0Central + du0;
% T1Current = T0Central + dt0;
% F1Current = F0Central + df0;


end

