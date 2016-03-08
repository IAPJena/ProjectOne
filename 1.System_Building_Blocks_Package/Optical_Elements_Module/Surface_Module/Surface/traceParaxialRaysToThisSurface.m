function [yf,uf ] = traceParaxialRaysToThisSurface(currentSurface,yi,ui,...
        indexBefore,indexAfter,reverseTracing,reflection,wavlenInM,referenceWavlenInM)
    %traceParaxialRaysToThisSurface Traces paraxial rays to the current surface and returns
    %all neccessary results
    
    returnFlag = 5; % Paraxial ray tracing
    surfaceType = currentSurface.Type;
    surfaceUniqueParameters = currentSurface.UniqueParameters;
    
    inputDataStruct = struct();
    inputDataStruct.InputParaxialRayParameters = [yi,ui]';
    inputDataStruct.ReverseTracingFlag = reverseTracing;
    inputDataStruct.ReflectionFlag = reflection;
    inputDataStruct.IndexBefore = indexBefore;
    inputDataStruct.IndexAfter = indexAfter;
    inputDataStruct.Wavelength = wavlenInM;
    inputDataStruct.ReferenceWavelength = referenceWavlenInM;
    inputDataStruct.Radius = currentSurface.Radius;
    inputDataStruct.Conic = currentSurface.Conic;
    
    % Connect the surface definition function
    surfaceDefinitionHandle = str2func(GetSupportedSurfaceTypes(surfaceType));
    [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
        surfaceUniqueParameters,inputDataStruct);
    
    yf = returnDataStruct.OutputParaxialRayParameters(1,:);
    uf = returnDataStruct.OutputParaxialRayParameters(2,:);
end

