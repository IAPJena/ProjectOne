function [ gratingVectorDirection,gratingLinesPerMicrometer ] = getLocalGratingParameter(...
        currentGrating, surfPoints,surfNormal )
    %GETGRATINGVECTOR returns the local grating vector direction and
    %grating peroid
    
    gratingRulingType = currentGrating.Type;
    gratingRulingDefinition = str2func(GetSupportedGratingTypes(gratingRulingType));
    gratingParameters = currentGrating.UniqueParameters;
    returnFlag = 2;
    inputDataStruct = struct();
    inputDataStruct.SurfacePoints = surfPoints;
    inputDataStruct.SurfaceNormal = surfNormal;

    returnDataStruct = gratingRulingDefinition(returnFlag,gratingParameters,inputDataStruct);
    gratingVectorDirection = returnDataStruct.LocalGratingVector; % 3 X N matrix
    gratingLinesPerMicrometer = returnDataStruct.LocalGratingLinesPerMicrometer; % 1 X N vector
end

