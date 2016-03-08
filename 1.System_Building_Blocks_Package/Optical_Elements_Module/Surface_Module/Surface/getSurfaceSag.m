function [ surfaceSagMain,surfaceSagAlternative ] = getSurfaceSag( surface,xyCoordinateMeshgrid,actualSurfacePointIndices )
    %GETSURFACESAG returns the surface sag in local coordinate for the given
    %local xy coordinates
    % Inputs:
    %   (surface,xyCoordinateMeshgrid,actualSurfacePointIndices )
    % Outputs:
    %   [surfaceSag1,surfaceSag2]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    % Jul 10,2015   Worku, Norman G.     input and output are made struct    

    surfaceType = surface.Type;
    surfaceParameters = surface.UniqueParameters;
    returnFlag = 4; % Sag
    inputDataStruct = struct();
    inputDataStruct.X = xyCoordinateMeshgrid(:,:,1);
    inputDataStruct.Y = xyCoordinateMeshgrid(:,:,2);
    inputDataStruct.ExtraData = surface.ExtraData;
    inputDataStruct.Radius = surface.Radius;
    inputDataStruct.Conic = surface.Conic;
    % Connect the surface definition function
    surfaceDefinitionHandle = str2func(GetSupportedSurfaceTypes(surfaceType));
    [returnDataStruct] = surfaceDefinitionHandle(returnFlag,surfaceParameters,inputDataStruct);
    mainSag = returnDataStruct.MainSag;
    alternativeSag = returnDataStruct.AlternativeSag;
    
    % Sag values will be complex for points outside the actual surface.
    % So replace the complex z values with the neighboring values
    realSag = real(mainSag);
    
    realSag1 = realSag(actualSurfacePointIndices);
    if ~isempty(realSag1)
        extremeZ = realSag1(1);
        realSag(~actualSurfacePointIndices) = extremeZ;
    end
    surfaceSagMain = realSag;
    surfaceSagAlternative = realSag;
end

