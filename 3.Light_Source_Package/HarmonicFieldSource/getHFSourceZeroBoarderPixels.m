function [ zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom] = ...
        getHFSourceZeroBoarderPixels( harmonicFieldSource )
    %GETZEROBOARDERSIZE Summary of this function goes here
    %   Detailed explanation goes here
    if harmonicFieldSource.ZeroBoarderSizeSpecification == 1 % Relative
        % Get the aabsolute field size first
        zeroBoarderSizeValue = harmonicFieldSource.ZeroBoarderSizeValue;
        [fieldSize1,fieldSize2] = getHFSourceSpatialShapeAndSize( harmonicFieldSource,1);
        zeroBoarderAbsoluteSizeX = zeroBoarderSizeValue(1)*fieldSize1;
        zeroBoarderAbsoluteSizeY = zeroBoarderSizeValue(2)*fieldSize2;
    else % Absolute
        zeroBoarderSizeValue = harmonicFieldSource.ZeroBoarderSizeValue;
        zeroBoarderAbsoluteSizeX = zeroBoarderSizeValue(1);
        zeroBoarderAbsoluteSizeY = zeroBoarderSizeValue(2);
    end
    
    decenterX = harmonicFieldSource.LateralPosition(1);
    decenterY = harmonicFieldSource.LateralPosition(2);
    
    [ dx,dy ] = getHFSourceSamplingDistance( harmonicFieldSource );
    if decenterX <= 0
        zeroPixelsLeft = ceil(zeroBoarderAbsoluteSizeX/dx);
        zeroPixelsRight = ceil((zeroBoarderAbsoluteSizeX + 2*abs(decenterX))/dx);
    else
        zeroPixelsLeft = ceil((zeroBoarderAbsoluteSizeX+ 2*abs(decenterX))/dx);
        zeroPixelsRight = ceil((zeroBoarderAbsoluteSizeX)/dx);
    end
    if decenterY <= 0
        zeroPixelsBottom  = ceil(zeroBoarderAbsoluteSizeY/dy);
        zeroPixelsTop  = ceil((zeroBoarderAbsoluteSizeY + 2*abs(decenterY))/dy);
    else
        zeroPixelsBottom = ceil((zeroBoarderAbsoluteSizeY+ 2*abs(decenterY))/dy);
        zeroPixelsTop = ceil((zeroBoarderAbsoluteSizeY)/dy);
    end
end

