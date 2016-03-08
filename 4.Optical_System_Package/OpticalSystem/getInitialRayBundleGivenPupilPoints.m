function [ initialRayBundle ] = getInitialRayBundleGivenPupilPoints( ...
        optSystem, wavelengthIndices,fieldIndices, pupilSamplingPoints)
    %getInitialRayBundleGivenPupilPoints Computes the initial ray bundles given the optical sytem,
    % Inputs:
    % wavelengthIndices,fieldIndices: Vectors indicating the wavelength and
    %           field indices to be used
    % pupilSamplingPoints: A 2XN matrix indicating the pupil points for the ray bundle.
    % Output:
    %   initialRayBundle: The initial ray bundles at the object plane
    
    
    % Defualt values
    if nargin < 1
        disp('Error: The function atleast needs one argument optSystem.');
        initialRayBundle = NaN;
        return;
    end
    
    if nargin < 2
        wavelengthIndices = 1;
    end
    if nargin < 3
        fieldIndices = 1;
    end
    if nargin < 4
        pupilSamplingPoints = [0,0]';
    end
    
    
    wavLen = getSystemWavelengths( optSystem,wavelengthIndices,0);
    fieldPointXY = getSystemFieldPoints( optSystem,fieldIndices,0);
    
    if abs(optSystem.SurfaceArray(1).Thickness) > 10^10 % object at infinity
        objectIsAtInfinity = 1;
        objThick = 0;
    else
        objectIsAtInfinity = 0;
        objThick  = optSystem.SurfaceArray(1).Thickness ;
    end
    
    pupilZLocation = (getEntrancePupilLocation(optSystem));
    fieldType = optSystem.FieldType;
    nField = size(fieldPointXY,2);
    nWav  = size(wavLen,2);
    % Effective number of rays to be traced through
    nRayTotal = size(pupilSamplingPoints,2);
    
    % Determine the direction of Cheif ray - for object height field and
    % position of Cheif ray - for field angle input
    % Compute initial ray bundle directions or positions (for afocal) for
    % each field points. The result will be 3 X (nRay*nField) matrices
    switch (fieldType)
        case 1 %('ObjectHeight')
            if objectIsAtInfinity
                % Invalid specification
                disp('Error: Object Height can not be used for objects at infinity');
                return;
            else
                fieldPoint = [fieldPointXY; repmat(-objThick,[1,nField])];
                [ initialRayBundleDirections ] = computeInitialRayBundleDirections...
                    (fieldPoint,pupilSamplingPoints);
                % repeat each row in fieldPoint nRay times
                allFieldPositions = cellfun(@(x) x*ones(1,nRayTotal),...
                    num2cell(fieldPoint,[1]),'UniformOutput',false);
                initialRayBundlePositions = cell2mat(allFieldPositions);
            end
        case 2 %('Angle')
            % The angle given indicates the direction of the cheif ray
            % the field point is angle in degree
            % Feild points are given by angles
            fieldPoint = fieldPointXY;
            angX = fieldPoint(1,:)*pi/180;
            angY = fieldPoint(2,:)*pi/180;
            
            %convert field angle to ray direction as in Zemax
            dz = sqrt(1./((tan (angX)).^2+(tan (angY)).^2+1));
            dx = dz.*tan (angX);
            dy = dz.*tan (angY);
            
            cheifRayDirection = [dx;dy;dz];
            if objectIsAtInfinity
                % object at infinity and
                % The rays are collimated and the Cheif ray direction
                % becomes the common ray direction
                commonRayDirectionCosine = cheifRayDirection;
                [ initialRayBundlePositions ] = computeInitialRayBundlePositions(...
                    commonRayDirectionCosine,pupilSamplingPoints,pupilZLocation,objThick);
                
                % repeat each row in commonRayDirectionCosine nRay times
                allFieldDirectionCosine = cellfun(@(x) x*ones(1,nRayTotal),...
                    num2cell(commonRayDirectionCosine,[1]),'UniformOutput',false);
                initialRayBundleDirections = [allFieldDirectionCosine{:}];
            else
                % Rays are not collimated
                % The field position can be computed from the cheif ray
                % direction.
                
                % Field point to the center of entrance pupil
                radFieldToEnP = (objThick + pupilZLocation)./cheifRayDirection(3,:);
                
                cheifRayFieldPoint = ...
                    [-radFieldToEnP.*cheifRayDirection(1,:);...
                    -radFieldToEnP.*cheifRayDirection(2,:);...
                    repmat(-objThick,[1,nField])];
                
                [ initialRayBundleDirections ] = computeInitialRayBundleDirections...
                    (cheifRayFieldPoint,pupilSamplingPoints);
                % repeat each row in fieldPoint nRay times
                allFieldPositions = cellfun(@(x) x*ones(1,nRayTotal),...
                    num2cell(cheifRayFieldPoint,[1]),'UniformOutput',false);
                initialRayBundlePositions = cell2mat(allFieldPositions);
            end
    end
    
    % Now replicate the initial ray bundle position (direction) matrices
    % in the 2nd dimension for all wavelengths.
    initialRayBundlePositions = repmat(initialRayBundlePositions,[1,nWav]);
    initialRayBundleDirections = repmat(initialRayBundleDirections,[1,nWav]);
    
    % Initialize initial ray bundle using constructor.
    pos = initialRayBundlePositions;
    dir = initialRayBundleDirections;
    wav = arrayfun(@(x) repmat(x,[1,nRayTotal*nField]),wavLen*getWavelengthUnitFactor(optSystem),'UniformOutput',false);
    wav = [wav{:}];
    
    % Convert the position and wavelength from lens unit/wave unit to meter for ray object
    wavLenInM = wavLen*getWavelengthUnitFactor(optSystem);
    posInM = pos*getLensUnitFactor(optSystem);
    
    % construct array of Ray objects
    scalarRayBundle = ScalarRayBundle(posInM,dir,wavLenInM,nRayTotal,nField,nWav);
    
    initialRayBundle = scalarRayBundle;
end

