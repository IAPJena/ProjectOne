function [ finalPolarizationVector ] = computeFinalPolarizationVector(...
        rayTraceResultFinal,initialPolVector, wavLenInM)
    %COMPUTEFINALPOLARIZATIONVECTOR Computes the final polarization vector in
    % global coordinate given the initialPolVector in global xyz coordinate
    
    % normalize the given jones vector and convert to Polarization Vector
    % normalizedPolVector = normalizeJonesVector(initialPolVector);
    
    % Shall be changed or checked
    nRayTraceResult = length(rayTraceResultFinal);
    initialPolarizationVector = initialPolVector;
    
    [ totalPMatrixs ] = getAllSurfaceTotalPMatrix( rayTraceResultFinal,0);
    totalPMatrixs = squeeze(totalPMatrixs(:,:,1,:));
    
    % Compute the field including all effects
    % 1. Complex amplitude coefficients due to interface + coating
    nRay = rayTraceResultFinal(1).FixedParameters.TotalNumberOfPupilPoints;
    polarizationVector1 = squeeze(multiplySliced3DMatrices(totalPMatrixs,reshape(initialPolarizationVector,[3,1,nRay])));
    % 2. Effect of OPL
    k0 = 2*pi./wavLenInM;
    [ totalOpticalPathLength ] = getAllSurfaceTotalOpticalPathLength( rayTraceResultFinal,0);
    totalOpticalPathLength = squeeze(totalOpticalPathLength(:,1,:));
    OPL = totalOpticalPathLength';
    polarizationVector2 = polarizationVector1.*repmat(exp(1i*k0*OPL),[3,1]);
    % 3. Effect of Absorption
    finalPolarizationVector = polarizationVector2;
end

