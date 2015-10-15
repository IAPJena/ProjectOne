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
    
    % Repeat wavLenInM and the scaled values of fieldPointXYInSI, nPupilRay times to
    % enable multiple mariginal rays in the range from zero to max field
    % point.
    nField = length(fieldIndices);
    nWav  = length(wavelengthIndices);
    
    fieldPointXYInSI = getSystemFieldPoints(optSystem,fieldIndices);
    wavLenInM = getSystemWavelengths(optSystem,wavelengthIndices);
    
    
    firstSurf = getSurfaceArray(optSystem,1);
    if abs(firstSurf.Thickness) > 10^10 % object at infinity
        objectIsAtInfinity = 1;
        objThick = 0;
    else
        objectIsAtInfinity = 0;
        objThick  = firstSurf.Thickness;
    end
    
    pupilSamplingPoint = [pupilRadius*sin(angleFromYinRad);pupilRadius*cos(angleFromYinRad);pupilZLocation];
    
    % Repeat for nPupilRays
    pupilSamplingPoint = (pupilSamplingPoint*repmat(linspace(1,1/nPupilRays,nPupilRays),[1,nField]));
    objThick = objThick*ones(1,nPupilRays*nField);
    
    fieldPointXYInSI = repmat(fieldPointXYInSI,[1,nPupilRays]);
    
    switch (optSystem.FieldType)
        case 1 %('ObjectHeight')
            fieldPointXYInLensUnit = fieldPointXYInSI/getLensUnitFactor(optSystem);
            % Global reference is the 1st surface of the lens
            fieldPoint = [fieldPointXYInLensUnit; -objThick];
            if abs(firstSurf.Thickness) > 10^10
                % Invalid specification
                disp('Error: Object Height can not be used for objects at infinity');
                return;
            else
                initialDirection = pupilSamplingPoint - fieldPoint;
                initialDirection = initialDirection./repmat(sqrt(sum(initialDirection.^2)),[3,1]);
                initialPosition = fieldPoint;
            end
        case 2 %('Angle')
            fieldPoint = fieldPointXYInSI;
            % The angle given indicates the direction of the cheif ray
            % Feild points are given by angles
            angX = fieldPoint(1,:)*pi/180;
            angY = fieldPoint(2,:)*pi/180;
            
            %convert field angle to ray direction as in Zemax
            dz = sqrt(1./((tan (angX)).^2+(tan (angY)).^2+1));
            dx = dz.*tan (angX);
            dy = dz.*tan (angY);
            cheifRayDirection = [dx;dy;dz];
            % Field point to the center of entrance pupil
            radFieldToEnP = (objThick + pupilZLocation)./cheifRayDirection(3,:);
            % Initial position of cheif ray
            cheifRayPosition = ...
                [-radFieldToEnP.*cheifRayDirection(1,:);...
                -radFieldToEnP.*cheifRayDirection(2,:);...
                -objThick];
            
            if objectIsAtInfinity
                % collimated ray
                initialDirection = cheifRayDirection;
                % mariginal ray is just shifted ray of the cheif ray.
                initialPosition(1:2,:) = cheifRayPosition(1:2,:) + pupilSamplingPoint(1:2,:);
                initialPosition(3,:) = -objThick;
            else
                % Initial position of cheif ray = that of mariginal ray
                initialPosition = cheifRayPosition;
                % Now compute the direction of the mariginal rays
                initialDirection = pupilSamplingPoint - initialPosition;
                initialDirection = initialDirection./repmat(sqrt(sum(initialDirection.^2)),[3,1]);
            end
    end
    initialPositionInM = initialPosition*getLensUnitFactor(optSystem);
    % The mariginalRay parameters will be parameters for outer most rays,
    % --> inner most rays in case of multiple pupil rays
    mariginalRay = ScalarRayBundle(initialPositionInM,initialDirection,wavLenInM);
end

