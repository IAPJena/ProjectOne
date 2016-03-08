function [ initialRayBundle, pupilSamplingPoints,pupilMeshGrid,outsidePupilIndices  ] = ...
        getInitialRayBundle( optSystem, wavelengthIndices,...
        fieldIndices, nPupilPoints1,nPupilPoints2,pupilSamplingType)
    %getInitialRayBundle Computes the initial ray bundles given the optical sytem,
    % Inputs:
    % wavelengthIndices,fieldIndices: Vectors indicating the wavelength and
    %           field indices to be used
    % nPupilPoints1,nPupilPoints2: The number of sampling points of the
    %           interance pupil.
    % pupilSamplingType: An integer indicating the pupil sampling type
    % Output:
    %   initialRayBundle: The initial ray bundles at the object plane
    %   pupilSamplingPoints: 3 x nTotalPupilPoints matrix containg values of
    %                       pupil sampling coordinates.
    %   pupilMeshGrid: the pupil sampling points placed in the form of mesh grid
    %                  for plotting. Used in cartesian or polar coordinates
    %  outsidePupilIndices: indices of the mesh grid which are outside
    %                       the pupil aperture area area
    
    % Defualt values
    if nargin < 1
        disp('Error: The function atleast needs one argument optSystem.');
        initialRayBundle = NaN;
        pupilSamplingPoints = NaN;
        pupilMeshGrid = NaN;
        outsidePupilIndices = NaN;
        return;
    end
    
    if nargin < 2
        wavelengthIndices = 1;
    end
    if nargin < 3
        fieldIndices = 1;
    end
    if nargin < 4
        nPupilPoints1 = 3;
    end
    if nargin < 5
        nPupilPoints2 = 3;
    end
    if nargin < 6
        pupilSamplingType = 'Tangential';
    end
    
    pupilRadius = (getEntrancePupilDiameter(optSystem))/2;
    pupilZLocation = (getEntrancePupilLocation(optSystem));
    pupilSampling = pupilSamplingType;
    
    % Global reference is the 1st surface of the lens
    [ pupilSamplingPoints,pupilMeshGrid,outsidePupilIndices  ] = ...
        computePupilSamplingPoints(nPupilPoints1,nPupilPoints2,pupilSampling,...
        pupilZLocation,pupilRadius,pupilRadius,'Circular');
    
    [ initialRayBundle ] = getInitialRayBundleGivenPupilPoints(...
        optSystem, wavelengthIndices,fieldIndices, pupilSamplingPoints);
end

