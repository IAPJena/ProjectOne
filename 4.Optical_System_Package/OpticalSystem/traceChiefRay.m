function [ chiefRayTraceResult,chiefRay ] = traceChiefRay( optSystem,fieldIndices,wavelengthIndices,rayTraceOptionStruct )
    %TRACECHIIFRAY Computes the chief ray and traces it theough the
    % given system
    % fieldPointXYInSI,wavLenInM are measured in SI unit (meter and degree for angles)
    % Deafault inputs
    if nargin < 1
        disp('Error: The function traceChiefRay needs atleast optical system');
        chiefRayTraceResult = NaN;
        chiefRay = NaN;
        return;
    end
    if nargin < 2
        % Take all field points and primary wavelength
        fieldIndices = [1:size(optSystem.FieldPointMatrix,1)];
    end
    if nargin < 3
        % Primary wavelength
        wavelengthIndices = optSystem.PrimaryWavelengthIndex;
    end
    if nargin < 4
        rayTraceOptionStruct = RayTraceOptionStruct();
    end
    
    chiefRay = getChiefRay(optSystem,fieldIndices,wavelengthIndices);
    endSurface = getNumberOfSurfaces(optSystem);
    
    chiefRayTraceResult = rayTracer(optSystem,chiefRay,rayTraceOptionStruct,...
        endSurface);
end

