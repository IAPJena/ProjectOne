function [ arrayOfRayBundles ] = getAllSurfaceRayBundles( allSurfaceRayTraceResult,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices)
    %getAllSurfaceRayBundles: Returns the ray bundles composed of set of rays
    % specified by (rayPupilIndex,rayFieldIndex,rayWavIndex) for each surfaces
    % Input:
    %   allSurfaceRayTraceResult: vector of raytrace result (size = nSurf)
    %   (rayPupilIndex,rayFieldIndex,rayWavIndex) : Indices specifying a given
    %   ray bundle
    % Output:
    %   arrayOfRayBundles: is (1 X nSurface) array of RayBundles. All the
    %   ray parameters are in meter (SI unit)
    
    if nargin < 1
        disp(['Error: The function  getAllSurfaceExitAngle requires ',...
            'atleast the surface trace result struct as argument.']);
        arrayOfRayBundles = NaN;
        return;
    end
    if nargin < 2
        rayPupilIndices = 0; % All
    end
    if nargin < 3
        rayFieldIndices = 0; % All
    end
    if nargin < 4
        rayWavelengthIndices = 0; % All
    end
    
    % Compute the surface intersection points,exit ray direction and
    % wavelengths
    % Results will be FirstDim X nSurf X nPupilPoints X nField X nWav
    requestedResultFieldName1 = 'RayIntersectionPoint';
    requestedFieldFirstDim1 = 3;
    surfaceIntersection = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName1,requestedFieldFirstDim1,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    requestedResultFieldName2 = 'ExitRayDirection';
    requestedFieldFirstDim2 = 3;
    exitRayDirection = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName2,requestedFieldFirstDim2,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);

    requestedResultFieldName1 = 'Wavelength';
    requestedFieldFirstDim1 = 1;
    wavelength = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName1,requestedFieldFirstDim1,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    nSurf = length(allSurfaceRayTraceResult);
    arrayOfRayBundles(nSurf) = ScalarRayBundle;
    
    surfaceIntersection = reshape((surfaceIntersection),3,nSurf,[]);
    exitRayDirection = reshape((exitRayDirection),3,nSurf,[]);
    wavelength = reshape((wavelength),1,nSurf,[]);
    
    lensUnitfactor = allSurfaceRayTraceResult(1).FixedParameters.LensUnitFactor;
    wavelengthUnitfactor = allSurfaceRayTraceResult(1).FixedParameters.WavelengthUnitFactor;
    for kk = 1:nSurf
        arrayOfRayBundles(kk).Position = squeeze(surfaceIntersection(:,kk,:))*lensUnitfactor;
        arrayOfRayBundles(kk).Direction = squeeze(exitRayDirection(:,kk,:));
        arrayOfRayBundles(kk).Wavelength = (squeeze(wavelength(:,kk,:)))'*wavelengthUnitfactor;
    end
end

