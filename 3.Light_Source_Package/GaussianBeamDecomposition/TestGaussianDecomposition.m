% Define harmonic field source with rectangular beam
newHarmonicFieldSource = HarmonicFieldSource();

newHarmonicFieldSource.DistanceToInputPlane = 0;
newHarmonicFieldSource.FieldSizeSpecification = 2; % Absolute

% for absolute dimensioning
newHarmonicFieldSource.AbsoluteBoarderShape = 2; % Rectangle
newHarmonicFieldSource.AbsoluteFieldSize = [1,1]';

% additional edge width
newHarmonicFieldSource.EdgeSizeSpecification = 1; % relative
newHarmonicFieldSource.RelativeEdgeSizeFactor = 0;

% Source sampling
newHarmonicFieldSource.SamplingParameterValues = [45,45]';
newHarmonicFieldSource.SamplingParameterType = 1; % sampling points
newHarmonicFieldSource.AdditionalBoarderSamplePoints = [10,10]';

% Plot the input field amplitude profile
[ U_xyTot,xlinTot,ylinTot] = getSpatialProfile( newHarmonicFieldSource );
figure;surf(xlinTot,ylinTot,U_xyTot)
shading interp

% Decompose the source in to gaussians
Nx = 11;
Ny = 11;
OF = 1.5;
wavelength = 0.55*10^-6;
[ gaussianBeamSet ] = decomposeHarmonicFieldSourceToGaussianBeams( ...
    newHarmonicFieldSource,Nx,Ny,OF,wavelength );
[ totalAmp,individualAmp,X,Y ] = computeTotalGaussianAmplitude( gaussianBeamSet,xlinTot,ylinTot );
% Plot the results
figure;surf(X,Y,totalAmp)
shading interp
% Compare the resulting beam with original
figure;surf(X,Y,totalAmp-U_xyTot)
shading interp

