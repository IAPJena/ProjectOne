function [ mariginalRayTraceResult,mariginalRay ] = traceMariginalRay( ...
        optSystem,fieldIndices,wavelengthIndices,angleFromYinRad,...
        rayTraceOptionStruct, nPupilRays )
    %TRACEMARIGINALRAY Computes the mariginal ray and traces it theough the
    % given system
    %   wavelengthIndices,fieldIndices: Vectors indicating the wavelength and
    %               field indices to be used
    if nargin < 1
        disp('Error: The function getMariginalRay needs atleast optical system');
        mariginalRayTraceResult = NaN;
        mariginalRay = NaN;
        return;
    end
    if nargin < 2
        % Take all field points and primary wavelength
        fieldIndices = [0,0]';
    end
    if nargin < 3
        % Primary wavelength
        wavelengthIndices = optSystem.PrimaryWavelengthIndex;
    end
    if nargin < 4
        angleFromYinRad = 0;
    end
    if nargin < 5
        rayTraceOptionStruct = RayTraceOptionStruct();
        rayTraceOptionStruct.ConsiderSurfaceAperture = 1;
        rayTraceOptionStruct.RecordIntermediateResult = 1;
    end
    if nargin < 6
        nPupilRays = 1;
    end
    
    mariginalRay = getMariginalRay(optSystem,fieldIndices,wavelengthIndices,angleFromYinRad,nPupilRays);
    mariginalRayTraceResult = rayTracer(optSystem,mariginalRay,rayTraceOptionStruct);
end

