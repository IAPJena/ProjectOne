function [ complexAmplitudeAtExitPupilMulti,wrappedPhaseMulti,unwrappedPhaseMulti xp,yp ] = ...
    computeComplexSpectralAmplitudeAtExitPupil(optSystem, inputPulsedBeam,useApodization)
%computeComplexSpectralAmplitudeAtExitPupil Computes the spectral amplitude and
% phase of the pulse at exit pupil and returns as single complex amplitude
% term.

if nargin < 2
    disp(['Error: The computeSpectralComplexAmplitudeAtExitPupil function needs atleast',...
        'opticalSystem and inputPulsedBeam as arguments.']);
    XMeshGridMulti = [];
    YMeshGridMulti = [];
    complexAmplitudeAtExitPupilMulti = [];
    return
elseif nargin == 2
    useApodization = 0;
else
    
end

NonDummySurfaceArray =  optSystem.getNonDummySurfaceArray ;
if abs(NonDummySurfaceArray(1).Thickness) > 10^10 % object at infinity
    objThick = 0;
else
    objThick  = NonDummySurfaceArray(1).Thickness;
end
initialZ = -objThick;

planeWaveArray = inputPulsedBeam.PlaneWaveArray;
pulseDirection = inputPulsedBeam.Direction;

nSpectralComponents = size(planeWaveArray,2);
for ss = 1:nSpectralComponents
    % set direction to the common pulse direction
    currentPlaneWave = planeWaveArray(ss);
    wavelength = currentPlaneWave.Wavelength;
    currentPlaneWave.Direction = pulseDirection;
    [initialRayArray,chiefRayIndex] = getInitialRayArray( currentPlaneWave,initialZ );
    rayTraceResult = rayTracer(optSystem,initialRayArray);
    
    rayTraceResultAtImagePlane = rayTraceResult(2,:);
    
    objectToImageOPLSum = [(rayTraceResultAtImagePlane.TotalOpticalPathLength)]';
    
    %% Trace all rays back to the exit pupil sphere
    nRay = length(rayTraceResultAtImagePlane);
    initialPosition = [(rayTraceResultAtImagePlane.RayIntersectionPoint)];
    initialDirection = -1*[(rayTraceResultAtImagePlane.IncidentRayDirection)];
    
    % Define exit pupil sphere
    exitPupilCenter = initialPosition(:,chiefRayIndex);
    exitPupilRadius = - getExitPupilLocation(optSystem);
    % Line(Ray):  initialPosition + t*initialDirection  = P
    % Sphere: (P-exitPupilCenter)^2 - exitPupilRadius^2 = 0
    % To get intersection point
    % at^2+bt+c=0 where
    % a = 1,
    % b = 2*initialDirection(initialPosition-exitPupilCenter),
    % c = |initialPosition-exitPupilCenter|^2-exitPupilRadius^2
    
    a = 1;
    b = 2*compute3dDot(initialDirection,(initialPosition-repmat(exitPupilCenter,[1,nRay])));
    c = sum((initialPosition-repmat(exitPupilCenter,[1,nRay])).^2,1)-exitPupilRadius^2;
    
    discr = b.^2 - 4*a.*c;
    if sum(discr<0,2)
        disp('Error Some rays fail to intersect the exit pupil.');
    end
    % Parameters
    root1 = (-b+sqrt(discr))./(2*a);
    root2 = (-b-sqrt(discr))./(2*a);
    % the intersection point shall be compute using the line eqation.
    intersectionPoint1 = initialPosition + repmat(root1,[3,1]).*initialDirection;
    intersectionPoint2 = initialPosition + repmat(root2,[3,1]).*initialDirection;
    % The real intersection point depends on the exit pupil location,
    % if it is to the left of image plane then the intersection point
    % with smaller z value is taken. Otherwise the other is taken.
    if exitPupilRadius > 0 % exit pupil to the left
        if intersectionPoint1(3,1) < intersectionPoint2(3,1)
            rayExitPupilIntersection = intersectionPoint1;
        else
            rayExitPupilIntersection = intersectionPoint2;
        end
    else
        if intersectionPoint1(3,1) < intersectionPoint2(3,1)
            rayExitPupilIntersection = intersectionPoint2;
        else
            rayExitPupilIntersection = intersectionPoint1;
        end
    end
    
    %             %% If plane exit pupil is assumed
    %             % Determine parameterr for Z of exit pupil from the global axis.
    %             % NB. Exit pupil location is measured from the image plane
    %             ExitPupilZ = optSystem.getTotalTrack + optSystem.getExitPupilLocation;
    %             % Line(Ray):  (x0,y0,z0) + t*(dx,dy,dz)  = (X,Y,Z)
    %             t = (ExitPupilZ - initialPosition(3,:))./initialDirection(3,:);
    %             intersectionPoint1 = initialPosition + repmat(t,[3,1]).*initialDirection;
    %             rayExitPupilIntersection = intersectionPoint1;
    
    additionalOpticalPath = sqrt(sum((initialPosition-rayExitPupilIntersection).^2,1))';
    totalOPLAtExitPupil = objectToImageOPLSum - additionalOpticalPath;
    totalOPLAtExitPupilCheifRay = totalOPLAtExitPupil(chiefRayIndex);
    OPD = totalOPLAtExitPupilCheifRay-totalOPLAtExitPupil;
    
    initialComplexAmplitudeEx = currentPlaneWave.ComplexAmplitude(:,:,1);
    Nx = size(initialComplexAmplitudeEx,1);
    Ny = size(initialComplexAmplitudeEx,2);
    %         initialComplexAmplitudeEy = currentPlaneWave.ComplexAmplitude(:,:,2);
    
    finalComplexAmplitudeEx = initialComplexAmplitudeEx.*reshape(exp(1i*OPD*2*pi/wavelength),Nx,Ny);
    
    complexAmplitudeAtExitPupilMulti(:,:,ss) = finalComplexAmplitudeEx;
    unwrappedPhaseMulti(:,:,ss) = (reshape(OPD*2*pi/wavelength,Nx,Ny));
    wrappedPhaseMulti(:,:,ss) = (angle(finalComplexAmplitudeEx));
    
    xyzMeshGrid = reshape(permute(rayExitPupilIntersection,[3,2,1]),Nx,Ny,3);
    XMeshGridMulti(:,:,ss) = xyzMeshGrid(:,:,1);
    YMeshGridMulti(:,:,ss) = xyzMeshGrid(:,:,2);

    xp(ss,:) = linspace(-max(max(XMeshGridMulti(:,:,ss))),max(max(XMeshGridMulti(:,:,ss))),Nx)*getLensUnitFactor(optSystem);
    yp(ss,:) = linspace(-max(max(YMeshGridMulti(:,:,ss))),max(max(YMeshGridMulti(:,:,ss))),Ny)*getLensUnitFactor(optSystem);
end

% % For now just take the average values of mesh grids as common grid
% XMeshGrid = (sum(XMeshGridMulti,3))/3;
% YMeshGrid = (sum(YMeshGridMulti,3))/3;

% Just take the size of exit pupil intersection with central wavelength
centralWavelengthIndex = floor(nSpectralComponents/2);
XMeshGridCentral = XMeshGridMulti(:,:,centralWavelengthIndex);
YMeshGridCentral = YMeshGridMulti(:,:,centralWavelengthIndex);

% xp = linspace(-max(max(XMeshGridCentral)),max(max(XMeshGridCentral)),Nx)*getLensUnitFactor(optSystem);
% yp = linspace(-max(max(YMeshGridCentral)),max(max(YMeshGridCentral)),Ny)*getLensUnitFactor(optSystem);

% Make new mesh grid and interpolate all the spectral field in to the new
% grid
% for ss2 = 1:nSpectralComponents   
% end

end

