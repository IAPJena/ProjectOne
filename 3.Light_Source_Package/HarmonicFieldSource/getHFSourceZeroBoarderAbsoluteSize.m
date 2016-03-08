function [ zeroBoarderSizeLeft,zeroBoarderSizeRight,zeroBoarderSizeTop,...
        zeroBoarderSizeBottom] = getHFSourceZeroBoarderAbsoluteSize( harmonicFieldSource )
    %GETZEROBOARDERSIZE Summary of this function goes here
    %   Detailed explanation goes here
    
    [ zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom] = ...
        getHFSourceZeroBoarderPixels( harmonicFieldSource );
    [dx,dy] = getHFSourceSamplingDistance(harmonicFieldSource);
    zeroBoarderSizeLeft = zeroPixelsLeft*dx;
    zeroBoarderSizeRight = zeroPixelsRight*dx;
    zeroBoarderSizeTop = zeroPixelsTop*dy;
    zeroBoarderSizeBottom = zeroPixelsBottom*dy;
end

