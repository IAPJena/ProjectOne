function [ mariginalRay ] = getMariginalRay(optSystem,fieldIndices,...
        wavelengthIndices,angleFromYinRad,nPupilRays)
    % getMariginalRay Returns the Mariginal ray (as Ray object)  which starts
    % from a field point  and passes throgh the edge of the entrance pupil at
    % point which makes the given angle from the y axis.
    % Inputs:
    %   wavelengthIndices,fieldIndices: Vectors indicating the wavelength and
    %               field indices to be used
    %   angleFromY: determines the angle of the point in the rim of the pupul
    %               from the y axis so that it will be possible to compute
    %               Mariginal rays in any planet(tangential or sagital)
    %               Default value is 0 degree.
    %   nPupilRays: Number of rays in the tangential plane of the pupil(enable
    %               tracing multiple mariginal rays in the tangential plane)
    %               Default value is 1.
    
    pupilRadius = (getEntrancePupilDiameter(optSystem))/2;
    pupilZLocation = (getEntrancePupilLocation(optSystem));
    if nargin < 1
        disp('Error: The function getMariginalRay needs atleast the optical system object.');
        mariginalRay = NaN;
        return;
    end
    if nargin < 2
        % Use the on axis point for field point
        fieldIndices = [0;0];
    end
    if nargin < 3
        % Primary wavelength
        wavelengthIndices = optSystem.PrimaryWavelengthIndex;
    end
    if nargin < 4
        angleFromYinRad = 0;
    end
    if nargin < 5
        nPupilRays = 1;
    end
    
    pupilSamplingPoint = [pupilRadius*sin(angleFromYinRad);pupilRadius*cos(angleFromYinRad);pupilZLocation];
    % Repeat for nPupilRays
    pupilSamplingPoints = pupilSamplingPoint*(linspace(1,1/nPupilRays,nPupilRays));
    
    [ initialRayBundle ] = getInitialRayBundleGivenPupilPoints( optSystem, wavelengthIndices,...
        fieldIndices, pupilSamplingPoints);
    mariginalRay = initialRayBundle;
end

