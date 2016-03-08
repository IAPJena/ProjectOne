function [ samplingDistanceX,samplingDistanceY ] = getHFSourceSamplingDistance(...
        harmonicFieldSource,boarderLevelIndex,Nx,Ny )
    %GETSAMPLINGDISTANCE Summary of this function goes here
    %   Detailed explanation goes here
    
    if nargin < 1
        disp('Error: The function getSamplingDistance requires atleast an input sargument of harmonicFieldSource.');
        samplingDistanceX = NaN;
        samplingDistanceY = NaN;
        return;
    end
    if nargin < 2
        boarderLevelIndex = 1; % Actual field + smooth edge
    end
    if nargin < 4
        % Use the default sampling parameters of the source
        if harmonicFieldSource.SamplingParameterType == 1
            % Sample number is specifed (actual field + smooth edge)
            Nx = harmonicFieldSource.SamplingParameterValues(1);
            Ny = harmonicFieldSource.SamplingParameterValues(2);
            % Make sure that the numbewr of sampling points are odd
            Nx = floor(Nx/2)*2 + 1;
            Ny = floor(Ny/2)*2 + 1;
            
            % get field size (actual field + smooth edge) BoarderLevelIndex = 1
            myBoarderLevelIndex = 1;
            [diameterX2,diameterY2] = getHFSourceSpatialShapeAndSize( harmonicFieldSource,myBoarderLevelIndex );
            samplingDistanceX = diameterX2/(Nx-1);
            samplingDistanceY = diameterY2/(Ny-1);
        else
            % Sampling distance specified directly
            samplingDistanceX = harmonicFieldSource.SamplingParameterValues(1);
            samplingDistanceY = harmonicFieldSource.SamplingParameterValues(2);
        end
    else
        % If Nx and Ny are given then calculate the sampling distance
        % direclty
        % get field size for given  boarderLevelIndex
%         boarderLevelIndex = 1;
        [diameterX,diameterY] = getSpatialShapeAndSize( harmonicFieldSource,boarderLevelIndex );
        samplingDistanceX = diameterX/(Nx-1);
        samplingDistanceY = diameterY/(Ny-1);
    end 
end

