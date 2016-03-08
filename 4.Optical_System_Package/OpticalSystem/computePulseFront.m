function [ meshGridX,meshGridY,pulseFront] =...
        computePulseFront( optSystem,wavelengthIndices,fieldIndices,refSurfaceIndex,...
        offsetInTime, nSamplingPoints1,nSamplingPoints2,gridType)
    % locationOfPhaseFrontAlongChiefRay: In lens unit
    % gridType: Polar or Cartesian used as pupil sampling type
    %  perform scalar ray trace depending
    wavLenInWavUnit = getSystemWavelength(optSystem,wavelengthIndices);
    c = 299792458;
    PupSamplingType = gridType;
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.RecordIntermediateResults = 1;
    
    [rayTracerResult,pupilMeshGrid,outsidePupilIndices] = ...
        multipleRayTracer(optSystem,wavelengthIndices,fieldIndices,nSamplingPoints1,...
        nSamplingPoints2,PupSamplingType,rayTraceOptionStruct);
    X = pupilMeshGrid(:,:,1);
    Y = pupilMeshGrid(:,:,2);
    if isempty(outsidePupilIndices)
        % Find cheif ray index
        cheifRayIndex = find((X).^2+(Y).^2==0);
    else
        % Find cheif ray index
        cheifRayIndex = find((X(~outsidePupilIndices)).^2+(Y(~outsidePupilIndices)).^2==0);
    end
    
    % take first value in case of multiple ocuurances
    cheifRayIndex = cheifRayIndex(1);
    
    % % Determine the surface just after the requested distance
    % totalPathLengthVector = [rayTracerResult(:,cheifRayIndex).TotalPathLength];
    % surfacesAfterCurrentPoint = find(totalPathLengthVector >= locationOfPhaseFrontAlongChiefRay);
    % nextSurfaceIndex = surfacesAfterCurrentPoint(1);
    
    % Determine the surface just before the requested distance
    % totalPathLengthVector = [rayTracerResult(:,cheifRayIndex).TotalPathLength];
    totalPathLengthVector = getAllSurfaceTotalGeometricalPathLength(rayTracerResult,cheifRayIndex,1,1);
    
    %surfacesBeforeCurrentPoint = find(totalPathLengthVector <= locationOfPhaseFrontAlongChiefRay);
    %prevSurfaceIndex = surfacesBeforeCurrentPoint(end);
    %refractiveIndexOfLastMedium = optSystem.getSurfaceArray(prevSurfaceIndex).Glass.getRefractiveIndex(wavLenInSI);
    %groupRefractiveIndexOfLastMedium = optSystem.getSurfaceArray(prevSurfaceIndex).Glass.getGroupRefractiveIndex(wavLenInSI);
    
    %
    if offsetInTime == 0
        prevSurfaceIndex = refSurfaceIndex;
    elseif offsetInTime > 0 %
        prevSurfaceIndex = refSurfaceIndex;
    else
        prevSurfaceIndex = refSurfaceIndex-1;
    end
    wavLenInSI = wavLenInWavUnit * getWavelengthUnitFactor(optSystem);
    prevSurface = getSurfaceArray(optSystem,prevSurfaceIndex);
    currentRefractiveIndex = getRefractiveIndex(prevSurface.Glass,wavLenInSI);
    currentGroupRefractiveIndex = getGroupRefractiveIndex(prevSurface.Glass,wavLenInSI);
    locationOfPhaseFrontAlongChiefRay = totalPathLengthVector(refSurfaceIndex)+...
        (c*offsetInTime)/(getLensUnitFactor(optSystem));
    
    % Compute the points on each ray with equal group pathlength
    totalOPLToPrevSurf = getAllSurfaceTotalOpticalPathLength(rayTracerResult(prevSurfaceIndex),0,0,0);
    totalGeoPLToPrevSurf = getAllSurfaceTotalGeometricalPathLength(rayTracerResult(prevSurfaceIndex),0,0,0);
    totalGroupPLToPrevSurf = getAllSurfaceTotalGroupPathLength(rayTracerResult(prevSurfaceIndex),0,0,0);
    
    rayIntersectionPointWithPrevSurf = getAllSurfaceRayIntersectionPoint(rayTracerResult(prevSurfaceIndex),0,0,0);
    rayExitDirectionFromPrevSurf = getAllSurfaceExitRayDirection(rayTracerResult(prevSurfaceIndex),0,0,0);
    
    
    totalOpticalPathLengthToPhaseFront = totalOPLToPrevSurf(cheifRayIndex) + ...
        (locationOfPhaseFrontAlongChiefRay-totalGeoPLToPrevSurf(cheifRayIndex))*currentRefractiveIndex;
    % In the same time the pulse group can travel a group path length = the
    % optical path length traveled by the light
    totalGroupPathLengthToPulseFront = totalOpticalPathLengthToPhaseFront;
    
    distanceFromLastSurfaceToPulseFront = (totalGroupPathLengthToPulseFront-...
        totalGroupPLToPrevSurf)/currentGroupRefractiveIndex;
    pointsOfThePulseFront =  rayIntersectionPointWithPrevSurf + ...
        repmat(distanceFromLastSurfaceToPulseFront,[3,1]).*rayExitDirectionFromPrevSurf;
    
    
    %% Plot the pulse front
    % Interpolate points to the mesh grid for surf plot
    x2 = pointsOfThePulseFront(1,:);
    y2 = pointsOfThePulseFront(2,:);
    z2 = pointsOfThePulseFront(3,:);
    
    
    switch lower(gridType)
        case lower({'Tangential','Sagittal'})
            Xq2 = x2;
            Yq2 = y2;
            Zq2 = z2;
        case lower({'Cartesian','Rectangular'})
            nPointsX2 = nSamplingPoints1;
            nPointsY2 = nSamplingPoints2;
            if nPointsX2 == 1
                xgv2 = zeros([1,nPointsY2]);
            else
                xgv2 = linspace(min(x2),max(x2),nPointsX2);
            end
            if nPointsY2 == 1
                ygv2 = zeros([1,nPointsX2]);
            else
                ygv2 = linspace(min(y2),max(y2),nPointsY2);
            end
            [Xq2,Yq2] = meshgrid(xgv2,ygv2);
            
        case lower('Polar')
            nPointsRadial2 = nSamplingPoints1;
            nPointsAngular2 = nSamplingPoints2;
            % Radius of the largest circle circumscribing the aperture
            maxR2 = max(sqrt(((x2).^2+(y2).^2)));
            % Draw a circle with radiaus maxR and then cut out the part required
            % using the given X and Y ranges
            if nPointsRadial2 == 1
                r2 = 0;
            else
                r2 = (linspace(-maxR2,maxR2,nPointsRadial2*2+1))';
            end
            if nPointsAngular2 == 1
                phi2 = 0;
            else
                phi2 = linspace(0,2*pi,nPointsAngular2);
            end
            Xq2 = r2*cos(phi2);
            Yq2 = r2*sin(phi2);
    end
    
    Zq2 = griddata(x2,y2,z2,Xq2,Yq2);
    if isempty(Zq2)
        % The underlying triangulation is empty - the points may be collinear.
        meshGridX = x2;
        meshGridY = y2;
        pulseFront = z2;
    else
        % Return the phase front surface in an interpolated grid mesh
        meshGridX = Xq2;
        meshGridY = Yq2;
        pulseFront = Zq2;
    end
    
end

