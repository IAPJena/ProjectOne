function [ options ] = RayTraceOptionStruct(...
        considerPolarization,considerSurfaceAperture,recordIntermediateResults,...
        computeGeometricalPathLength,computeOpticalPathLength,computeGroupPathLength,...
        computeRefractiveIndex,computeRefractiveIndexFirstDerivative,...
        computeRefractiveIndexSecondDerivative,computeGroupIndex)
    % Structure containng options for ray tracing function which are
    % logical values indicating what to compute and consider
    
    % Default inputs
    if nargin < 1
        considerPolarization = 0;
    end
    if nargin < 2
        considerSurfaceAperture = 1;
    end
    if nargin < 3
        recordIntermediateResults = 0;
    end
    if nargin < 4
        computeGeometricalPathLength = 1;
    end
    if nargin < 5
        computeOpticalPathLength = 0;
    end
    if nargin < 6
        computeGroupPathLength = 0;
    end
    if nargin < 7
        computeRefractiveIndex = 1;
    end
    if nargin < 8
        computeRefractiveIndexFirstDerivative = 0;
    end
    if nargin < 9
        computeRefractiveIndexSecondDerivative = 0;
    end
    if nargin < 10
        computeGroupIndex = 0;
    end
    
    options.ConsiderPolarization = considerPolarization;
    options.ConsiderSurfaceAperture = considerSurfaceAperture;
    options.RecordIntermediateResults = recordIntermediateResults;
    
    options.ComputeGeometricalPathLength = computeGeometricalPathLength;
    options.ComputeOpticalPathLength = computeOpticalPathLength;
    options.ComputeGroupPathLength = computeGroupPathLength;
    
    options.ComputeRefractiveIndex = computeRefractiveIndex;
    options.ComputeRefractiveIndexFirstDerivative = computeRefractiveIndexFirstDerivative;
    options.ComputeRefractiveIndexSecondDerivative = computeRefractiveIndexSecondDerivative;
    options.ComputeGroupIndex = computeGroupIndex;
end

