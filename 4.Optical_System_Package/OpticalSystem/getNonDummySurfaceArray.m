function [ nonDummySurfaceArray,nNonDummySurface,nonDummySurfaceIndices,...
        surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem,index )
    if nargin < 2
        index = 0; % All
    end
    %GETNONDUMMYSURFACEARRAY Returns the surface array which are not dummy
    [nonDummySurfaceIndices,surfaceArray,nSurface ] = (getNonDummySurfaceIndices(optSystem));
    nonDummySurfaceArray = surfaceArray(nonDummySurfaceIndices);
    nNonDummySurface = length(nonDummySurfaceIndices);
    
    if index ~= 0
        nonDummySurfaceArray = nonDummySurfaceArray(index);
    end
end

