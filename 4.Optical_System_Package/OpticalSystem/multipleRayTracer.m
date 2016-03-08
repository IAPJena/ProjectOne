function [multipleRayTracerResult,pupilMeshGrid,outsidePupilIndices ] = ...
        multipleRayTracer(optSystem,wavelengthIndices,fieldIndices,...
        nPupilPoints1,nPupilPoints2,pupSamplingType,rayTraceOptionStruct,endSurface) %
    % Trace bundle of rays through an optical system based on the pupil
    % sampling specified. Multiple rays can be defined with wavelengthIndices (1XnWav),
    % fieldIndices (1XnField) and the total number of ray will be nRay*nWav*nField
    % That is all rays from each field point with each of wavelegths will be
    % traced. And the result will be 4 dimensional matrix (nNonDummySurface X nRay X nField X nWav).
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Deafault inputs
    if nargin < 1
        disp('Error: The function multipleRayTracer needs atleast optical system');
        return;
    end
    if nargin < 2
        wavelengthIndices =  optSystem.PrimaryWavelengthIndex;
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
        pupSamplingType ='Cartesian';
    end
    if nargin < 7
        rayTraceOptionStruct = RayTraceOptionStruct();
    end
    [NonDummySurfaceIndices,updatedSurfaceArray,nSurface] = getNonDummySurfaceIndices(optSystem);    
    if nargin < 8
        endSurface = nSurface;
    end

    tic
    % Determine the number of non dummy surfaces used for ray tracing
    % That can be used for final reshaping of the ray trace result matrix.
    startNonDummyIndex = 1; % Ray trace start from object surface
    indicesBeforeEndSurf = find(NonDummySurfaceIndices<=endSurface);
    endNonDummyIndex = indicesBeforeEndSurf(end);
    
    nNonDummySurfaceConsidered = endNonDummyIndex - startNonDummyIndex + 1;
    
    %% Compute initial ray bundle parameters
    pupilShape = 'Circular';
    nField = length(fieldIndices);
    nWav  = length(wavelengthIndices);
    
    
    [ initialRayBundle, pupilSamplingPoints,pupilMeshGrid,...
        outsidePupilIndices   ] = ...
        getInitialRayBundle( optSystem, wavelengthIndices,...
        fieldIndices, nPupilPoints1,nPupilPoints2,pupSamplingType);
    nRayPupil = size(pupilSamplingPoints,2);
    
    %===============RAYTRACE For Bundle of Ray========================
    rayTraceResult = rayTracer(optSystem,initialRayBundle,rayTraceOptionStruct,...
        endSurface);
    multipleRayTracerResult = rayTraceResult;
    pupilCoordinates = pupilSamplingPoints;
    timeElapsed =  toc;
    considerPolarization = rayTraceOptionStruct.ConsiderPolarization;
    disp(['Ray Bundle Trace Completed. Polarized  = ',num2str(considerPolarization), ...
        ', Total Number  = ', num2str(nRayPupil*nField*nWav), ', Time Elapsed = ', ...
        num2str(timeElapsed),' Sec.']);
end