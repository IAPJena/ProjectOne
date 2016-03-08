function newHarmonicFieldSource = HarmonicFieldSource(...
        lateralPosition,principalDirectionSpecification,...
        principalDirectionValue,distanceToInputPlane,...
        fieldSizeSpecification,fieldSizeValue,fieldBoarderShape,...
        smoothEdgeSizeSpecification,smoothEdgeSizeValue,...
        zeroBoarderSizeSpecification,zeroBoarderSizeValue,...
        samplingParameterType,samplingParameterValues,...
        spatialProfileType,spatialProfileParameter,...
        spectralProfileType,spectralProfileParameter,...
        polarizationProfileType,polarizationProfileParameter,mediumName)
    
    if nargin < 1
        lateralPosition = [0,0]';% [X;Y] position
    end
    if nargin < 2
        principalDirectionSpecification = 1; % Direction cosine XY
    end
    if nargin < 3
        principalDirectionValue = [0,0]';% direction cosine in the direction. The field will be
        % defined in the plane perpendicular to this direction
    end
    if nargin < 4
        distanceToInputPlane = 10*10^-3;
    end
    if nargin < 5
        fieldSizeSpecification = 1; % 'Relative 
    end
    if nargin < 6
        fieldSizeValue = [1,1]'; % for relative dimenssioning
    end 
    if nargin < 7
        fieldBoarderShape = 1; % 'Elliptical'
    end
    if nargin < 8
        smoothEdgeSizeSpecification = [1]'; % 'Relative'
    end
    if nargin < 9
        %smoothEdgeSizeValue = [0.1,0.1]'; % for relative dimenssioning
        smoothEdgeSizeValue = [0.1]; % for relative dimenssioning
    end
    if nargin < 10
        zeroBoarderSizeSpecification = 1; % Relative to the actual field size 
    end
    if nargin < 11
        zeroBoarderSizeValue = [0.1,0.1]';
    end
    if nargin < 12
        samplingParameterType = 1; % No. of samples
    end
    if nargin < 13
        samplingParameterValues = [64,64]'; % Sampling of the actual field not including the zero boarder
    end
    if nargin < 14
        spatialProfileType = 1; % 'PlaneWaveProfile'
    end
    if nargin < 15
        spatialProfileTypeString = getSupportedSpatialProfiles(spatialProfileType);
        [~,~,spatialProfileParameter] = getHFSourceSpatialProfileParameters(spatialProfileTypeString);
    end
    if nargin < 16
        spectralProfileType = 1; %'GaussianPowerSpectrum'
    end
    if nargin < 17
        spectralProfileTypeString = getSupportedSpectralProfiles(spectralProfileType);
        [~,~,spectralProfileParameter] = getHFSourceSpectralProfileParameters(spectralProfileTypeString);
    end
    if nargin < 18
        polarizationProfileType = 1; %'LinearPolarization'
    end
    if nargin < 19
        polarizationProfileTypeString = getSupportedPolarizationProfiles(polarizationProfileType);
        [~,~,polarizationProfileParameter] = getHFSourcePolarizationProfileParameters(polarizationProfileTypeString);
    end
   if nargin < 20
        mediumName = 'Vaccum';
   end
    newHarmonicFieldSource.LateralPosition = lateralPosition;
    newHarmonicFieldSource.PrincipalDirectionSpecification = principalDirectionSpecification;
    newHarmonicFieldSource.PrincipalDirectionValue = principalDirectionValue;
    
    newHarmonicFieldSource.DistanceToInputPlane = distanceToInputPlane;
    newHarmonicFieldSource.FieldSizeSpecification = fieldSizeSpecification;
    
    % For 'Relative' to the lateral profil, the boarder shape is taken
    % directly and the size is scaled with size factor
    newHarmonicFieldSource.FieldSizeValue = fieldSizeValue;
    % for absolute dimensioning
    newHarmonicFieldSource.FieldBoarderShape = fieldBoarderShape;
    
    % additional edge width
    newHarmonicFieldSource.SmoothEdgeSizeSpecification = smoothEdgeSizeSpecification;
    newHarmonicFieldSource.SmoothEdgeSizeValue = smoothEdgeSizeValue;

    newHarmonicFieldSource.ZeroBoarderSizeSpecification = zeroBoarderSizeSpecification;
    newHarmonicFieldSource.ZeroBoarderSizeValue = zeroBoarderSizeValue;
    
    % Source sampling
    newHarmonicFieldSource.SamplingParameterType = samplingParameterType;
    newHarmonicFieldSource.SamplingParameterValues = samplingParameterValues;
    
    % Spatial parameters
    newHarmonicFieldSource.SpatialProfileType = spatialProfileType;
    newHarmonicFieldSource.SpatialProfileParameter = spatialProfileParameter;
    
    % Spectral parameter
    newHarmonicFieldSource.SpectralProfileType = spectralProfileType;
    newHarmonicFieldSource.SpectralProfileParameter = spectralProfileParameter;
    
    % Polarization
    newHarmonicFieldSource.PolarizationProfileType = polarizationProfileType;
    newHarmonicFieldSource.PolarizationProfileParameter = polarizationProfileParameter;
    
    newHarmonicFieldSource.MediumName = mediumName; 
    newHarmonicFieldSource.ClassName = 'HarmonicFieldSource';
end


