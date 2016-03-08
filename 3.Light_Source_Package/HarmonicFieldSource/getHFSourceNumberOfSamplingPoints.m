function [ Nx,Ny ] = getHFSourceNumberOfSamplingPoints(...
        harmonicFieldSource,boarderLevelIndex,samplingDistanceX,samplingDistanceY )
    %GETNUMBEROFSAMPLINGPOINTS Returns the number of sampling points of the
    %actual field with smooth edge but with out the zero boarder pixels.

    if nargin < 1
        disp('Error: The function getHarmonicFieldSourceNumberOfSamplingPoints requires atleast an input sargument of harmonicFieldSource.');
        Nx = NaN;
        Ny = NaN;
        return;
    end
    if nargin < 2
        boarderLevelIndex = 1; % Actual field + smooth edge
    end
    if nargin < 4
        % Use the default sampling parameters of the source
        if harmonicFieldSource.SamplingParameterType == 1
            % Sample number is specifed (actual field + smooth edge)
            Nx = (harmonicFieldSource.SamplingParameterValues(1));
            Ny = (harmonicFieldSource.SamplingParameterValues(2));
            if boarderLevelIndex == 2
                % Add zero boarder pixels
                [  zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom] = getHFSourceZeroBoarderPixels( harmonicFieldSource );
                Nx = Nx + zeroPixelsLeft + zeroPixelsRight;
                Ny = Ny + zeroPixelsTop + zeroPixelsBottom;
            end
            return;
        else
            % Sampling distance specified directly
            samplingDistanceX = harmonicFieldSource.SamplingParameterValues(1);
            samplingDistanceY = harmonicFieldSource.SamplingParameterValues(2);
        end
    end
        % If dx and dy are given then calculate the sampling numbers
        % direclty
        % get field size for given boarderLevelIndex 
        [diameterX,diameterY] = getHFSourceSpatialShapeAndSize( harmonicFieldSource,boarderLevelIndex );
        Nx = round(diameterX/samplingDistanceX);
        Ny = round(diameterY/samplingDistanceY);       
end

