function [ geometricalPathLength,additionalPathLength,localRayIntersectionPoint,...
        localSurfaceNormal,localExitRayPosition,localExitRayDirection,...
        totalInternalReflectionFlag,noIntersectionPointFlag] = ...
        traceRealRaysToThisSurface(currentSurface,rayPosition,rayDirection,...
        indexBefore,indexAfter,wavlenInM,referenceWavlenInM,mirroredCoordinate )
    %TRACERAYSTOTHISSURFACE Traces real rays to the current surface and returns
    %all neccessary results
    
    surfaceType = currentSurface.Type;
    surfaceUniqueParameters = currentSurface.UniqueParameters;
    surfaceDefinitionHandle = str2func(GetSupportedSurfaceTypes(surfaceType));
    
    % Compute the path length to the plane tangent to the surface vertex
    nRay = size(rayPosition,2);
    initialPoint = rayPosition; % define the start point
    k = rayDirection(1,:);
    l = rayDirection(2,:);
    m = rayDirection(3,:);
    
    distanceToXY = -initialPoint(3,:)./m;
    intersectionPointXY  = ...
        [initialPoint(1,:) +  distanceToXY.*k;...
        initialPoint(2,:) +  distanceToXY.*l;...
        zeros([1,nRay])];
    
    X = intersectionPointXY(1,:);
    Y = intersectionPointXY(2,:);
    Z = intersectionPointXY(3,:);
    
    % Compute the additional path from the current Z plane to the real
    % surface point using Numerical iterative method
    sj = 0*X;
    s_final = sj;
    intersectionTolerance = 10^-6;
    maxIter= 50;
    iter = 0;
    tobeComputedIndices = [1:length(X)];
    noIntersectionPointFlag = zeros(1,length(X));
    iterationCounter = zeros(1,length(X));
    localSurfaceNormal = zeros(3,length(X));
    remainingIndices = tobeComputedIndices(tobeComputedIndices~=0);
    while ~isempty(remainingIndices) && iter < maxIter
        % On each iteration the errors shall be computed for each rays and
        % then those satisfying the condition shall be marked as
        % AlreadyComputed
        
        k_rem = k(remainingIndices);
        l_rem = l(remainingIndices);
        m_rem = m(remainingIndices);
        sj_rem = s_final(remainingIndices);
        X_rem = X(remainingIndices);
        Y_rem = Y(remainingIndices);
        
        Xj_rem = X_rem + k_rem.*sj_rem;
        Yj_rem = Y_rem + l_rem.*sj_rem;
        Zj_rem = m_rem.*sj_rem;
        iter = iter + 1;
        
        % Get (compute) function value F(X,Y,Z)
        inputDataStruct = struct();
        % Positions
        inputDataStruct.RayIntersectionPoint = [Xj_rem; Yj_rem; Zj_rem];
        % Directions
        inputDataStruct.RayDirection = [k_rem;l_rem; m_rem];
        % ExtraData
        inputDataStruct.ExtraData = currentSurface.ExtraData;
        
        returnFlag = 7; % return the function value F(X,Y,Z)
        inputDataStruct.Radius = currentSurface.Radius;
        inputDataStruct.Conic = currentSurface.Conic;
        [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
            surfaceUniqueParameters,inputDataStruct);
        F_rem = returnDataStruct.Fxyz;
        
        % Get (compute) its derivative F'(X,Y,Z)
        returnFlag = 8; % return the derivative of function value F(X,Y,Z)
        [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
            surfaceUniqueParameters,inputDataStruct);
        Fderivative_rem = returnDataStruct.FxyzDerivative;
        SurfaceNormal_rem = returnDataStruct.SurfaceNormal;
        
        % Compute new additional path
        s_prev = sj_rem;
        s_curr = sj_rem - F_rem./Fderivative_rem;
        
        % Add to the full  s_final vector
        s_final(remainingIndices) = s_curr;
        
        % Compute mean error
        error = abs(s_prev - s_curr);
        meanError = sum(error)/length(error);
        foundInThisIteration = error < intersectionTolerance;
        if sum(double(foundInThisIteration))
            iterationCounter(remainingIndices(foundInThisIteration)) = iter;
            localSurfaceNormal(:,remainingIndices(foundInThisIteration)) = ...
                SurfaceNormal_rem(:,foundInThisIteration);
        end
        remainingIndices(foundInThisIteration) = [];
    end
    
    additionalPath2 = s_final;
    noIntersectionPointFlag(isnan(additionalPath2)|abs(additionalPath2)==Inf) = 1;
    additionalPath = additionalPath2;
    geometricalPathLength = distanceToXY + additionalPath;
    % Compute the intersection point
    localRayIntersectionPoint = computeIntersectionPoint(rayPosition,rayDirection,geometricalPathLength);
    
    %% Exit ray position
    returnFlag = 9; % return the exit ray direction
    inputDataStruct = struct();
    inputDataStruct.RayIntersectionPoint = localRayIntersectionPoint;
    inputDataStruct.RayDirection = rayDirection;
    inputDataStruct.WavelengthInM = wavlenInM;
    inputDataStruct.ReferenceWavelengthInM = referenceWavlenInM;
    inputDataStruct.IndexBefore = indexBefore;
    inputDataStruct.IndexAfter = indexAfter;       
    [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
        surfaceUniqueParameters,inputDataStruct);
    localExitRayPosition = returnDataStruct.LocalExitRayPosition;
    % If the current coordinate is mirrored coordinate
    % => Mirrored Z axis => the normal vector shall be in -ve direction
    if mirroredCoordinate
        localSurfaceNormal = -localSurfaceNormal;
    end
    
    %% Exit ray direction
    wavelengthInUm = wavlenInM*10^6;
    if isGratingEnabledSurface(currentSurface)
        currentGrating = currentSurface.Grating;
        [ gratingVectorDirection,gratingLinesPerMicrometer ] = getLocalGratingParameter(...
            currentGrating, localRayIntersectionPoint,localSurfaceNormal );
        diffractionOrder = currentGrating.DiffractionOrder;
    else
        gratingVectorDirection = 0; % Not used
        gratingLinesPerMicrometer = 0; % Not used
        diffractionOrder = 0; % Used as flag to ignore diffraction
    end
    
    
    returnFlag = 6; % new direction
    inputDataStruct = struct();
    inputDataStruct.RayIntersectionPoint = localRayIntersectionPoint;
    inputDataStruct.RayDirection = rayDirection;
    inputDataStruct.LocalSurfaceNormal = localSurfaceNormal;
    inputDataStruct.IndexBefore = indexBefore;
    inputDataStruct.IndexAfter = indexAfter;
    inputDataStruct.WavelengthInUm = wavelengthInUm;
    inputDataStruct.DiffractionOrder = diffractionOrder;
    inputDataStruct.GratingVectorDirection = gratingVectorDirection;
    inputDataStruct.GratingLinesPerMicrometer = gratingLinesPerMicrometer;
    
    [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
        surfaceUniqueParameters,inputDataStruct);
    
    localExitRayDirection = returnDataStruct.NewLocalRayDirection;
    totalInternalReflectionFlag = returnDataStruct.TIR;
    
    % Additional pathlength (phase)
    returnFlag = 10; %
    inputDataStruct = struct();
    inputDataStruct.RayIntersectionPoint = localRayIntersectionPoint;
    [ returnDataStruct] = surfaceDefinitionHandle(returnFlag,...
        surfaceUniqueParameters,inputDataStruct);
    additionalPathLength = returnDataStruct.AdditionalPathLength;
end

function intersectionPoint = computeIntersectionPoint(rayInitialPosition,rayDirection,...
        geometricalPathLength)
    % COMPUTEINTERSECTIONPOINT to calculate the intersection point of a ray on one surface
    %   Ref: G.H.Spencer and M.V.R.K.Murty, GENERAL RAY-TRACING PROCEDURE
    %   We are calculating the intersection point for the j surface
    % The function is vectorized so it can work on multiple sets of
    % inputs once at the same time.
    
    % Inputs (For N ray)
    %   incidentRayArray: Array of ray object incident to the surface p
    %   geometricalPathLength: the pathlength of the ray from the start point (j-1) to ...
    %                          the intersection point of the j surface
    %   The output will be 3-by-N matrix, which is the position of the intersection point
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    nRay = size(rayInitialPosition,2);
    %compute the intersection point
    intersectionPoint = ...
        [rayInitialPosition(1,:) + rayDirection(1,:).*geometricalPathLength;...
        rayInitialPosition(2,:) + rayDirection(2,:).*geometricalPathLength;...
        rayInitialPosition(3,:) + rayDirection(3,:).*geometricalPathLength];
end


