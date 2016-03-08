function [ chiefRay ] = getChiefRay( optSystem,fieldIndices,wavelengthIndices )
    % getChiefRay returns the chief ray (as Ray object) of the optical system
    % starting from a field point and passing through origin of the entrance pupil.
    % wavelengthIndices,fieldIndices: Vectors indicating the wavelength and
    % field indices to be used
    % The fieldIndices and wavelengthIndices are just optional parameters to
    % allow computation for field points and wavelengths which are not
    % specified in the system configuration. By default, all available field
    % for field point and primary wavelength are used.
    
    % Default inputs
    if nargin < 1
        disp('Error: The function getChiefRay needs atleast the optical system object.');
        chiefRay = NaN;
    end
    if nargin < 2
        % Take all field points and primary wavelength
        fieldIndices = [1:size(optSystem.FieldPointMatrix,1)];
    end
    
    if nargin < 3
        % Primary wavelength
        wavelengthIndices = optSystem.PrimaryWavelengthIndex;
    end
    pupilZLocation = (getEntrancePupilLocation(optSystem)); 
    pupilSamplingPoint = [0;0;pupilZLocation];
    [ initialRayBundle ] = getInitialRayBundleGivenPupilPoints( optSystem, wavelengthIndices,...
        fieldIndices, pupilSamplingPoint);
    chiefRay = initialRayBundle;
 end

