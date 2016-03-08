function [diameterXNew,diameterYNew, boarderShape] = getHFSourceSpatialShapeAndSize( harmonicFieldSource,boarderLevelIndex )
    %GETSPATIALSHAPEANDSIZE Summary of this function goes here
    %   Detailed explanation goes here
    
    % We have three field boarderLevelIndices
    % 0. Actual field size,
    % 1. + With smooth edge
    % 2. + With additional zero boarder due to given zero pixels and decenter
    % The boarderShape is that of the actual field and that with smooth edge.
    % The outer most shape is usually rectangulr.
    if nargin < 1
        disp('Error: The function getSpatialShapeAndSize requires atleast one input argument.');
        diameterXNew = NaN;
        diameterYNew = NaN;
        boarderShape = NaN;
    end
    if nargin < 2
        % Get just the actual field size returned by the user defined spatial
        % profile function
        boarderLevelIndex = 0;
    end
    switch boarderLevelIndex
        case 0
            % 0. Actual field size with out smooth edge
            spatialProfileType = harmonicFieldSource.SpatialProfileType;
            spatialProfileParameter = harmonicFieldSource.SpatialProfileParameter;
            
            % Connect the surface definition function
            spatialDefinitionHandle = str2func(getSupportedSpatialProfiles(spatialProfileType));
            returnFlag = 2;
            [returnDataStruct] = spatialDefinitionHandle(returnFlag,spatialProfileParameter);
            actualFieldShape = returnDataStruct.BoarderShape;
            actualFieldSize = returnDataStruct.BoarderDiameter;
            
            fieldSizeSpecification = harmonicFieldSource.FieldSizeSpecification;
            if fieldSizeSpecification == 1 % relative
                relativeFieldSizeFactor = harmonicFieldSource.FieldSizeValue;
                diameterX = relativeFieldSizeFactor(1)*actualFieldSize(1);
                diameterY = relativeFieldSizeFactor(2)*actualFieldSize(2);
                boarderShape = actualFieldShape;
            elseif fieldSizeSpecification == 2 % absolute
                absoluteBoarderShape = harmonicFieldSource.FieldBoarderShape;
                absoluteFieldSize = harmonicFieldSource.FieldSizeValue;
                diameterX = absoluteFieldSize(1);
                diameterY = absoluteFieldSize(2);
                boarderShape = absoluteBoarderShape;
            end
            diameterXNew = diameterX; 
            diameterYNew = diameterY; 

        case 1
            [diameterX0,diameterY0, boarderShape] = getHFSourceSpatialShapeAndSize( harmonicFieldSource);
            % 1. Actual field with smooth edge
            edgeSizeSpecification = harmonicFieldSource.SmoothEdgeSizeSpecification;
            if edgeSizeSpecification == 1 % Relative
                relativeEdgeSizeFactor = harmonicFieldSource.SmoothEdgeSizeValue;
                maxDiam = max([diameterX0,diameterY0]);
                diameterX = diameterX0 + 2*maxDiam*relativeEdgeSizeFactor;
                diameterY = diameterY0 + 2*maxDiam*relativeEdgeSizeFactor;
            else
                absoluteEdgeSize = harmonicFieldSource.SmoothEdgeSizeValue;
                diameterX = diameterX0 + 2*absoluteEdgeSize;
                diameterY = diameterY0 + 2*absoluteEdgeSize;
            end
            diameterXNew = diameterX;
            diameterYNew = diameterY;
        case 2
            % 2. With additional zero boarder cause of zero pixels and
            % decenter
            [diameterX2,diameterY2] = getHFSourceSpatialShapeAndSize( harmonicFieldSource,1 );
            [ zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom] = ...
                getHFSourceZeroBoarderPixels( harmonicFieldSource );
            [ dx,dy ] = getHFSourceSamplingDistance( harmonicFieldSource );
            %             [ zeroBoarderAbsoluteSize1, zeroBoarderAbsoluteSize2] = getZeroBoarderAbsoluteSize( harmonicFieldSource );
            % The zero boarder should be increased to fit to the next pixel
            % edge
            diameterX = diameterX2 + (zeroPixelsLeft+zeroPixelsRight)*dx;
            diameterY = diameterY2 + (zeroPixelsTop+zeroPixelsBottom)*dy;
            boarderShape = 2; % rectangle
            diameterXNew = diameterX;
            diameterYNew = diameterY;
        otherwise
    end
    
    
end

