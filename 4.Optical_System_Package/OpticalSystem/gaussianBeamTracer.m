function [ outputGaussianBeamSet ] = gaussianBeamTracer( optSystem,initialGaussianBeamSet,startSurface,endsurface)
    %GAUSSIANBEAMTRACER Traces gaussian beam from startSurface to endsurface
    % and returns the output gaussian beam array at endSurface (which is genrally astigmatic).
    % initialGaussianBeamArray = array of ScalarGaussianBeam objects
    % Intermediate surface results are not neccessary and hence are not recorded
    % The code is also vectorized. Multiple inputs and outputs are possible.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    % Aug 24,2014   Worku, Norman G.     Original Version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    lensUnitFactor = getLensUnitFactor(optSystem);
    
    if nargin < 1
        disp('Error: The function gaussianBeamTracer needs atleast the optical system object.');
        outputGaussianBeamSet = NaN;
        return
    end
    if nargin < 2
        % defaults gaussian: waist size of 1 lens units and
        % surface 1 to waist distance of zero; Field index = 1; wavlength index
        % = 1;
        
        % Take the central ray as chief ray from 1st field point and primary
        % wavelength
        fieldIndex = 1;
        primaryWavelengthIndex = optSystem.PrimaryWavelengthIndex;
        centralRay =  getChiefRay(optSystem,fieldIndex,primaryWavelengthIndex);
        
        centralRayPosition = centralRay.Position;
        centralRayDirection = centralRay.Direction;
        centralRayWavelength = centralRay.Wavelength;
        waistRadiusInX = 1*lensUnitFactor;
        waistRadiusInY = 0.5*lensUnitFactor;
        distanceFromWaistInX = 0*lensUnitFactor;
        distanceFromWaistInY = 0*lensUnitFactor;
        
        initialGaussianBeamSet = GaussianBeamSet(centralRayPosition,...
            centralRayDirection,centralRayWavelength,waistRadiusInX,...
            waistRadiusInY,distanceFromWaistInX,distanceFromWaistInY);
    end
    
    [ NonDummySurfaceArray,nNonDummySurface,NonDummySurfaceIndices,...
        surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem );
    % For Now just trace gaussians from Object to image surface
    startSurface = 1;
    endSurface = nSurface;
    
    
    surfIndicesAfterStartSurface = find(NonDummySurfaceIndices>=startSurface);
    startNonDummyIndex = surfIndicesAfterStartSurface(1);
    surfIndicesBeforeEndSurface = find(NonDummySurfaceIndices<=endSurface);
    endNonDummyIndex = surfIndicesBeforeEndSurface(end);
    lensUnitFactor = getLensUnitFactor(optSystem);
    
    if abs(NonDummySurfaceArray(1).Thickness) > 10^10
        objectThickness = 0;
    else
        objectThickness = NonDummySurfaceArray(1).Thickness*lensUnitFactor;
    end
    
    % Get all rays representing the gaussian beams
    [ gaussianBeamRayBundle ] = getGaussianBeamRayBundle( initialGaussianBeamSet );
    
    % Trace all rays through the optical system
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.RecordRayTraceResults = 0;
    rayTracerResult = rayTracer(optSystem, gaussianBeamRayBundle,rayTraceOptionStruct);
    
    % Get the final ray bundle in SI unit
    finalGaussianBeamRayBundle = getAllSurfaceRayBundles(rayTracerResult(2));
    % The units
    
    % Reconstruct the generally astigmatic gaussian beams from the rayBundles
    [ outputGaussianBeamSet ] = convertRayBundlesToGenerallyAstigmaticGaussianBeamSet( finalGaussianBeamRayBundle);
end

