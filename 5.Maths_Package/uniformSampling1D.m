function sampled1DPoints = uniformSampling1D(numberOfSamplePoints,centerPoint,samplingInterval)
   % numberOfSamplePoints: Is just a single number indicating the number of
   % sampling points
   % The function accepts multiple center and sampling interval value and
   % return 1 x numberOfSamplePoints x N matrix of sampled1DPoints
    N = size(centerPoint,2);
    Np = numberOfSamplePoints;
    sampled1DPoints = zeros(1,Np,N);
    for kk = 1:N
        if mod(numberOfSamplePoints,2)
            % odd
            sampled1DPoints(1,:,kk) = [-floor(Np/2):1:(floor(Np/2))]*samplingInterval(:,kk) + centerPoint(:,kk);
        elseif ~mod(numberOfSamplePoints,2)
            % even
            sampled1DPoints(1,:,kk) = [-(Np/2):1:((Np/2)-1)]*samplingInterval(:,kk) + centerPoint(:,kk);
        else
        end
    end
end