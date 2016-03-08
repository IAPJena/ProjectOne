function [ NxTot,NyTot ] = getHFSourceTotalNumberOfSamplingPoints( harmonicFieldSource)
    %GETNUMBEROFSAMPLINGPOINTS Summary of this function goes here
    %   Detailed explanation goes here
    
    if nargin < 1
        disp('Error: The function getTotalNumberOfSamplingPoints requires atleast an input sargument of harmonicFieldSource.');
        NxTot = NaN;
        NyTot = NaN;
        return;
    end
    [ Nx,Ny ] = getNumberOfSamplingPoints( harmonicFieldSource );
    [ zeroBoarderSamplePoints1, zeroBoarderSamplePoints2] = getZeroBoarderSamplePoints( harmonicFieldSource );
    NxTot = 2*zeroBoarderSamplePoints1+Nx;
    NyTot = 2*zeroBoarderSamplePoints2+Ny;
end

