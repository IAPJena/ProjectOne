function [ rms ] = computeWavefrontRMS( OPDAtExitPupil,pupilWeightMatrix )
    % computeRootMeanSquare: computes the root mean square of a given wavefront. 
    % The function is vectorized so it can work on multiple inputs once at 
    % the same time.
    % Input:
    %    inMatrix: 3D matrix (l x m x N)
    % Output:
    %    rms : 1 X N rms corresponding to each slice of 2D matrix

    % pupilWeightMatrix = used to indicate weighting factor for each pupil
    % location and if == 0 => Vignated rays and are not even considered for
    % computation of the mean.
    
    % Replace any NAN with zeros
    OPDAtExitPupil(find(isnan(OPDAtExitPupil))) = 0;
    
    % The RMS is calculated as the mean of the squares of the numbers, square-rooted:
    l = size(OPDAtExitPupil,1);
    m = size(OPDAtExitPupil,2);
    N = size(OPDAtExitPupil,3);
    rms = zeros(1,N);
    for kk = 1:N
        nonVignatedOPD = OPDAtExitPupil(find(pupilWeightMatrix));
        nonVignatedWeight = pupilWeightMatrix(find(pupilWeightMatrix));         
        rms(kk) = sqrt(mean((nonVignatedOPD.^2).*(nonVignatedWeight))-...
            (mean((nonVignatedOPD).*(nonVignatedWeight))).^2);
%          	rms(kk) = sqrt(squeeze((mean(mean(OPDAtExitPupil.^2))))-(squeeze((mean(mean(OPDAtExitPupil))))).^2);
    end
end

