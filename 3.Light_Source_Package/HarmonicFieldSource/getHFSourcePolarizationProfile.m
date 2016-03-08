function [ matrixOfJonesVector ] = getHFSourcePolarizationProfile( harmonicFieldSource )
    %GETPOLARIZATIONPROFILE returns matrix of the Jones vector

    [ dx,dy ] = getHFSourceSamplingDistance( harmonicFieldSource);
    samplingDistance = [ dx,dy ]';
    [NxTotal,NyTotal] = getHFSourceNumberOfSamplingPoints(...
        harmonicFieldSource,2);
    totalSamplingPoints = [NxTotal,NyTotal]';
    
    [xlinTot,ylinTot] = generateSamplingGridVectors(totalSamplingPoints,samplingDistance);
    
    [xMesh,yMesh] = meshgrid(xlinTot,ylinTot);
    
    polarizationType = harmonicFieldSource.PolarizationProfileType;
    polarizationParameters = harmonicFieldSource.PolarizationProfileParameter;
    
    % get the spatial distribution of polarization (jones vector)
    % profile function
    
    % Connect the polarization definition function
    polarizationDefinitionHandle = str2func(getSupportedPolarizationProfiles(polarizationType));
    returnFlag = 2; %
    inputDataStruct = struct;
    inputDataStruct.xMesh = xMesh;
    inputDataStruct.yMesh = yMesh;
    inputDataStruct.BeamCenter = harmonicFieldSource.LateralPosition;
    [ returnDataStruct ] = polarizationDefinitionHandle(returnFlag,polarizationParameters,inputDataStruct);
    jonesVector = returnDataStruct.JonesVector;
    polDistributionType = returnDataStruct.PolarizationDistributionType;
    switch lower(polDistributionType)
        case ('global')
            matrixOfJonesVector = repmat(reshape(jonesVector,1,1,2),totalSamplingPoints(2),totalSamplingPoints(1));
        case ('local')
            matrixOfJonesVector = jonesVector;
    end
    
end

