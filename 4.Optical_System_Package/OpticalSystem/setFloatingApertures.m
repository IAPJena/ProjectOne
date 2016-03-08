function updatedOpticalSystem = setFloatingApertures( currentOpticalSystem )
    % setFloatingApertures: Computes and sets the apertures values of
    % floating apertures of each surface by tracing cheif ray + top and bottom
    % mariginal rays of each field and each wavelength and taking the maximum
    % radial interesection of the rays with the surfaces.
    
    updatedOpticalSystem = currentOpticalSystem;
    
    if (isfield(currentOpticalSystem,'IsUpdatedSurfaceArray') && ...
            currentOpticalSystem.IsUpdatedSurfaceArray)
        return;
    end
    
    lensUnitFactor = getLensUnitFactor(updatedOpticalSystem);
    nField = getNumberOfFieldPoints(updatedOpticalSystem);
    [ nonDummySurfaceIndices] = getNonDummySurfaceIndices( updatedOpticalSystem );
    nNonDummySurf = length(nonDummySurfaceIndices);
    nWav = getNumberOfWavelengths(updatedOpticalSystem);
    
    fieldPointMatrix = updatedOpticalSystem.FieldPointMatrix;
    fieldPointIndices = [1:size(fieldPointMatrix,1)];
    
    wavelengthMatrix = updatedOpticalSystem.WavelengthMatrix;
    wavLenIndices = [1:size(wavelengthMatrix,1)];
    
    % For top and bottom rays
    angleFromYinRad1 = 0;
    angleFromYinRad2 = pi;
    
    % For right and left rays
    angleFromYinRad3 = pi/2;
    angleFromYinRad4 = 3*pi/2;
    
    % Ignore current apertures in the computation of flaoting
    rayTraceOptionStruct = RayTraceOptionStruct( );
    rayTraceOptionStruct.ConsiderSurfaceAperture = 0;
    rayTraceOptionStruct.RecordIntermediateResults = 1;
    
    topMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
        fieldPointIndices,wavLenIndices,angleFromYinRad1,rayTraceOptionStruct);
    bottomMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
        fieldPointIndices,wavLenIndices,angleFromYinRad2,rayTraceOptionStruct);
    
    rightMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
        fieldPointIndices,wavLenIndices,angleFromYinRad3,rayTraceOptionStruct);
    leftMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
        fieldPointIndices,wavLenIndices,angleFromYinRad4,rayTraceOptionStruct);
    cheifRayTraceResult = traceChiefRay(updatedOpticalSystem,...
        fieldPointIndices,wavLenIndices,rayTraceOptionStruct);
    nMarginalRayUsed = 1;
    
    
    for kk = 1:nNonDummySurf
        surfIndex = nonDummySurfaceIndices(kk);
        currentSurface = updatedOpticalSystem.SurfaceArray(surfIndex);
        if currentSurface.Aperture.Type == 1 %'FloatingCircularAperture'
            topMariginalIntersection = [topMariginalRayTraceResult(kk).RayIntersectionPoint];
            bottomMariginalIntersection = [bottomMariginalRayTraceResult(kk).RayIntersectionPoint];
            rightMariginalIntersection = [rightMariginalRayTraceResult(kk).RayIntersectionPoint];
            leftMariginalIntersection = [leftMariginalRayTraceResult(kk).RayIntersectionPoint];
            cheifRayIntersection = [cheifRayTraceResult(kk).RayIntersectionPoint];
            
            % If the mariginal rays fail to intersect, then trace N other
            % rays in the tangential plane and take the farthest one
            % intersecting the surface
            if (isnan(topMariginalIntersection)|isnan(bottomMariginalIntersection)|...
                    isnan(rightMariginalIntersection)|isnan(leftMariginalIntersection)) & ...
                    (nMarginalRayUsed == 1)
                N = 100;
                topMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
                    fieldPointIndices,wavLenIndices,angleFromYinRad1,rayTraceOptionStruct,N);
                bottomMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
                    fieldPointIndices,wavLenIndices,angleFromYinRad2,rayTraceOptionStruct,N);
                
                rightMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
                    fieldPointIndices,wavLenIndices,angleFromYinRad3,rayTraceOptionStruct,N);
                leftMariginalRayTraceResult = traceMariginalRay(updatedOpticalSystem,...
                    fieldPointIndices,wavLenIndices,angleFromYinRad4,rayTraceOptionStruct,N);
                nMarginalRayUsed = N;
                
                topMariginalIntersection = [topMariginalRayTraceResult(kk).RayIntersectionPoint];
                bottomMariginalIntersection = [bottomMariginalRayTraceResult(kk).RayIntersectionPoint];
                rightMariginalIntersection = [rightMariginalRayTraceResult(kk).RayIntersectionPoint];
                leftMariginalIntersection = [leftMariginalRayTraceResult(kk).RayIntersectionPoint];
            end
            
            surfaceVertexInLensUnit = updatedOpticalSystem.SurfaceArray(surfIndex).SurfaceCoordinateTM(1:3,4);
            
            vertexToTopMariginal = (topMariginalIntersection(1:2,:) - repmat(repmat(surfaceVertexInLensUnit(1:2,:),[1,nField*nWav]),[1,nMarginalRayUsed]));
            vertexToTopMariginalDist = computeNormOfMatrix(vertexToTopMariginal,1);
            vertexToBottomMariginal = (bottomMariginalIntersection(1:2,:) - repmat(repmat(surfaceVertexInLensUnit(1:2,:),[1,nField*nWav]),[1,nMarginalRayUsed]));
            vertexToBottomMariginalDist = computeNormOfMatrix(vertexToBottomMariginal,1);
            vertexToRightMariginal = (rightMariginalIntersection(1:2,:) - repmat(repmat(surfaceVertexInLensUnit(1:2,:),[1,nField*nWav]),[1,nMarginalRayUsed]));
            vertexToRightMariginalDist = computeNormOfMatrix(vertexToRightMariginal,1);
            vertexToLeftMariginal = (leftMariginalIntersection(1:2,:) - repmat(repmat(surfaceVertexInLensUnit(1:2,:),[1,nField*nWav]),[1,nMarginalRayUsed]));
            vertexToLeftMariginalDist = computeNormOfMatrix(vertexToLeftMariginal,1);
            
            % If multiple rays are traced then failing rays will have
            % complex distance so remove those values
            vertexToTopMariginalDist(imag(vertexToTopMariginalDist)~=0) = [];
            vertexToBottomMariginalDist(imag(vertexToBottomMariginalDist)~=0) = [];
            vertexToRightMariginalDist(imag(vertexToRightMariginalDist)~=0) = [];
            vertexToLeftMariginalDist(imag(vertexToLeftMariginalDist)~=0) = [];
            
            vertexTocheifRay = (cheifRayIntersection - repmat(surfaceVertexInLensUnit,[1,nField*nWav]));
            vertexTocheifRayDist = computeNormOfMatrix(vertexTocheifRay,1);
            
            maxRadToTopMariginalRay = max(vertexToTopMariginalDist);
            maxRadToBottomMariginalRay = max(vertexToBottomMariginalDist);
            maxRadToRightMariginalRay = max(vertexToRightMariginalDist);
            maxRadToLeftMariginalRay = max(vertexToLeftMariginalDist);
            
            maxRadTocheifRay = max(vertexTocheifRayDist);
            
            maxRadToMariginal_CheifRayInM = max([maxRadToTopMariginalRay,...
                maxRadToBottomMariginalRay,maxRadToRightMariginalRay,...
                maxRadToLeftMariginalRay,maxRadTocheifRay]);
            
            maxRadToMariginal_CheifRay = maxRadToMariginal_CheifRayInM;
            
            if isnan(maxRadToMariginal_CheifRay)
                % Do nothing if the floatingApertureDiameter is not
                % computed correctly
            else
                floatingApertureDiameter = 2*maxRadToMariginal_CheifRay;
                if floatingApertureDiameter == 0
                    floatingApertureDiameter = 10^-15;
                end
                updatedOpticalSystem.SurfaceArray(surfIndex).Aperture.UniqueParameters.Diameter = ...
                    floatingApertureDiameter;
                if isSurface(currentSurface)
                    updatedOpticalSystem.OpticalElementArray{updatedOpticalSystem.SurfaceToElementMap{surfIndex}}.Aperture.UniqueParameters.Diameter = ...
                        floatingApertureDiameter;
                end
            end
            
        end
    end
end

