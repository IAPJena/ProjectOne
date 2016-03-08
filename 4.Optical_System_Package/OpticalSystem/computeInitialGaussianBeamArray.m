function [ initialGaussianBeamArray ] = computeInitialGaussianBeamArray(optSystem, fieldIndex,wavIndex,pupilDiameter,gridSpacingInX,gridSpacingInY,overlapFactor )
%COMPUTEINITIALGAUSSIANBEAMARRAY computes the initial gaussian beam array
% gridSpacingInX = WidthInX/NumberOfGridPointsInX, WidthInX = WidthInY =
% SystemEntrancePupilDiameter They are all in Si units
% pupilDiameter: Size of the beam at entrance pupil in Lens unit

% pupilDiameter = optSystem.getEntrancePupilDiameter;
% Compute the sampling points in X and Y
nRay1 = floor(pupilDiameter/gridSpacingInX);
nRay2 = floor(pupilDiameter/gridSpacingInY);
PupSamplingType = 'Rectangular';
polarized = 0;
JonesVec = NaN;
                
% Extract the wavelength and field point
wavLenInWavUnit =  [(optSystem.WavelengthMatrix(wavIndex,1))'];
fieldPointXYInLensUnit =  [(optSystem.FieldPointMatrix(fieldIndex,1:2))'];

% Compute array of initial central rays
[ initialRayArray, pupilSamplingPoints,pupilMeshGrid,...
     outsidePupilIndices  ] = ...
    computeInitialRayArray( optSystem, wavLenInWavUnit,...
    fieldPointXYInLensUnit, nRay1,nRay2,PupSamplingType,polarized,JonesVec);

% Compute the initial gaussian beams from the central rays and other
% gaussian parameters
waistRadiusInX = gridSpacingInX*overlapFactor/sqrt(pi);
waistRadiusInY = gridSpacingInY*overlapFactor/sqrt(pi);
distanceFromWaist = 0;
peakAmplitude = 1;
localXDirection = [1;0;0];
localYDirection = [0;1;0];
initialGaussianBeamArray = ScalarGaussianBeam(initialRayArray,waistRadiusInX,...
    waistRadiusInY,distanceFromWaist,peakAmplitude,localXDirection,localYDirection);

% Plot the central and parabasal rays initially
centralRays = [initialGaussianBeamArray.CentralRay];
[waistRaysInX,waistRaysInY] = getWaistRays(initialGaussianBeamArray);
[divergenceRaysInX,divergenceRaysInY] = getDivergenceRays(initialGaussianBeamArray);

centralPos = [centralRays.Position];
waistXPos = [waistRaysInX.Position];
waistYPos = [waistRaysInY.Position];

a = 100;
figure;
axes;
scatter(centralPos(1,:),centralPos(2,:),a,'*','MarkerFaceColor','r')
hold on;
scatter(waistXPos(1,:),waistXPos(2,:),a,'+','MarkerFaceColor','g')
hold on;
scatter(waistYPos(1,:),waistYPos(2,:),a,'+','MarkerFaceColor','k')
axis equal
end

