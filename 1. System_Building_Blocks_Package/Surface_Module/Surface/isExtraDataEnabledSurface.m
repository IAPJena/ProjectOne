function [ isExtraDataEnabled ] = isExtraDataEnabledSurface( surf )
    %ISGRATINGENABLED Summary of this function goes here
    %   Detailed explanation goes here
    
    % Connect the surface definition function
    surfaceDefinitionHandle = str2func(GetSupportedSurfaceTypes(surf.Type));
    returnFlag = 1;% about surface
    [returnDataStruct] = surfaceDefinitionHandle(returnFlag);
    isExtraDataEnabled = returnDataStruct.IsExtraDataEnabled; 
end

