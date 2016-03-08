function [ groupPathLength,groupPathLength2 ] = getAllSurfaceGroupPathLength( allSurfaceRayTraceResult,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices)
    %getAllSurfaceGroupPathLength: Returns the Group Path Length of a specific
    % ray specified by (rayPupilIndex,rayFieldIndex,rayWavIndex) for all surfaces
    % Input:
    %   allSurfaceRayTraceResult: vector of raytrace result (size = nSurf)
    %   (rayPupilIndex,rayFieldIndex,rayWavIndex) : Indices specifying a given
    %   ray
    % Output:
    %   exitRayDirections: is (1 X nSurf X nPupilPointsRequested X nFieldRequested X nWavRequested)
    
    if nargin == 0
        disp(['Error: The function  getAllSurfaceGroupPathLength requires ',...
            'atleast the surface trace result struct as argument.']);
        groupPathLength = NaN;
        return;
    elseif nargin == 1
        rayPupilIndices = 0; % All
        rayFieldIndices = 0; % All
        rayWavelengthIndices = 0; % All
    elseif nargin == 2
        rayFieldIndices = 0; % All
        rayWavelengthIndices = 0; % All
    elseif nargin == 3
        rayWavelengthIndices = 0; % All
    else
        
    end
        
    % Compute the GeometricalPathLength,indexBefore and additionalPath
    requestedResultFieldName1 = 'GeometricalPathLength';
    requestedFieldFirstDim1 = 1;
    geometricalPathLength = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName1,requestedFieldFirstDim1,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    requestedResultFieldName2 = 'RefractiveIndexFirstDerivative';
    requestedFieldFirstDim2 = 1;
    refractiveIndexFirstDerivative = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName2,requestedFieldFirstDim2,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    % compute the indexBefore each surface matrice
    nSurf = size(refractiveIndexFirstDerivative,2);
    nPupilIndice = size(refractiveIndexFirstDerivative,3);
    nFieldIndice = size(refractiveIndexFirstDerivative,4);
    nWavelengthIndice = size(refractiveIndexFirstDerivative,5);
    if nWavelengthIndice == 1 && nFieldIndice == 1
        indexBeforeFirstDerivative(1,:,:) = 0*refractiveIndexFirstDerivative+1;
        indexBeforeFirstDerivative(1,2:end,:) = refractiveIndexFirstDerivative(1,1:end-1,:);
    elseif nWavelengthIndice == 1
        indexBeforeFirstDerivative(1,:,:,:) = 0*refractiveIndexFirstDerivative+1;
        indexBeforeFirstDerivative(1,2:end,:,:) = refractiveIndexFirstDerivative(1,1:end-1,:,:);
    else
        indexBeforeFirstDerivative(1,1,:,:,:) = 0*refractiveIndexFirstDerivative+1;
        indexBeforeFirstDerivative(1,2:end,:,:,:) = refractiveIndexFirstDerivative(1,1:end-1,:,:,:);
    end
    requestedResultFieldName2 = 'AdditionalPathLength';
    requestedFieldFirstDim2 = 1;
    additionalPathLength = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName2,requestedFieldFirstDim2,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
    
    % now compute the OpticalPathLength
    groupPathLength = indexBeforeFirstDerivative.*(geometricalPathLength + additionalPathLength);
    
    
    %% for checking
    requestedResultFieldName = 'GroupPathLength';
    requestedFieldFirstDim = 1;
    groupPathLength2 = getRayTraceResultFieldForAllSurfaces( ...
        allSurfaceRayTraceResult,requestedResultFieldName,requestedFieldFirstDim,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices);
end

