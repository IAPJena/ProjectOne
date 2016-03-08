function [ U_xyTot,xlinTot,ylinTot] = getHFSourceSpatialProfile( harmonicFieldSource,xlinTot,ylinTot)
    %GETSPATIALPROFILE Returns the spatial profile of the harmonic field
    %source which is computed from The spatial profile + Edge smoothening +
    %Embeding in to border frame.
    
    if nargin < 1
        disp('Error: The function getSpatialProfile requires atleast an input sargument of harmonicFieldSource.');
        U_xyTot = NaN;
        xlinTot = NaN;
        ylinTot = NaN;
        return;
    end
    if nargin < 3
        [ zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom] = ...
            getHFSourceZeroBoarderPixels( harmonicFieldSource );
        [Nx,Ny] = getHFSourceNumberOfSamplingPoints(harmonicFieldSource);
        [dx,dy] = getHFSourceSamplingDistance(harmonicFieldSource,Nx,Ny);
        samplingPoints = [Nx,Ny]';
        samplingDistance = [dx,dy]';
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints,samplingDistance);
        
        [xlinTot,ylinTot] = generateSamplingGridVectors...
            (samplingPoints+[ zeroPixelsLeft + zeroPixelsRight; zeroPixelsTop + zeroPixelsBottom],samplingDistance);
    else
        % Get the field size without the zero border
        [diameterX2,diameterY2] = getSpatialShapeAndSize( harmonicFieldSource,2 );
        Cx = harmonicFieldSource.LateralPosition(1);
        Cy = harmonicFieldSource.LateralPosition(2);
        
        
        xlin = xlinTot(abs(xlinTot-Cx) <= diameterX2/2);
        ylin = ylinTot(abs(ylinTot-Cy) <= diameterY2/2);
    end
    spatialProfileType = harmonicFieldSource.SpatialProfileType;
    spatialProfileParameters = harmonicFieldSource.SpatialProfileParameter;
    
    
    % get the spatial profile from the corresponding spatial profile function
    % Connect the spatial profile definition function
    spatialProfileDefinitionHandle = str2func(getSupportedSpatialProfiles(spatialProfileType));
    returnFlag = 3; %
    inputDataStruct = struct();
    [xMesh,yMesh] = meshgrid(xlin,ylin);
    inputDataStruct.xMesh = xMesh;
    inputDataStruct.yMesh = yMesh;
    [ returnDataStruct ] = spatialProfileDefinitionHandle(returnFlag,spatialProfileParameters,inputDataStruct);
    U_xy = returnDataStruct.SpatialProfileMatrix; % Could be 3D matrix for partial coherent light
    [fieldDiameterX1,fieldDiameterY1,boarderShape] = getHFSourceSpatialShapeAndSize( harmonicFieldSource);
    fieldDiameter = [fieldDiameterX1,fieldDiameterY1]';
    % % This field diameter takes the lateral offset into consideraion, so
    % % compute the actual field size without lateral offset
    % actualFieldDiameter = fieldDiameter - abs(lateralPosition);
    
    actualFieldDiameter = fieldDiameter;
    % compute edge smoothening function
    smootheningEdgeType = harmonicFieldSource.SmoothEdgeSizeSpecification;
    smootheningEdgeValue = harmonicFieldSource.SmoothEdgeSizeValue;
    switch (smootheningEdgeType)
        case 1 %('Relative')
            absoluteEdgeValue = (smootheningEdgeValue).*max(actualFieldDiameter);
        case 2 % ('Absolute')
            absoluteEdgeValue = [smootheningEdgeValue];
    end
    [edgeSmootheningFunction] = getEdgeSmootheningFunction(...
        xlin,ylin,boarderShape,absoluteEdgeValue,actualFieldDiameter);
    nSpatialMode = size(U_xy,3);
    for mm = 1:nSpatialMode
    U_xy_SmoothEdge = U_xy(:,:,mm).*edgeSmootheningFunction;
    % Add the field into the embedding frame
    [U_xyTot(:,:,mm)] = EmbedInToFrame(U_xy_SmoothEdge,zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom);
    end
end

