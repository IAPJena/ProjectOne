function [xlin,ylin] = generateSamplingGridVectors(samplingPoints,samplingDistance,centerXY)
    %GENERATESAMPLINGGRIDVECTORS return vectors for sampling points of x
    %and y diretion which will later be used to compute mesh grid points
    % The function can also be used with multiple inputs and give multiple
    % outputs, in that case
    % samplingPoints : 2 x 1 constant number of sampling points for all
    % inputs
    % samplingDistance,centerXY : 2 x N matrix
    % xlin,ylin : 1 x nPoints x N
    if nargin < 1
        samplingPoints = [65;65];
    end
    if nargin < 2
        samplingDistance = [1;1];
    end
    if nargin < 3
        centerXY = [0;0];
    end
    
    nSamplingPoints = size(samplingPoints,2);
    if nSamplingPoints  > 1
        % Just take the maximum sampling points given for both X and Y
        samplingPoints = [max(samplingPoints(1,:)),max(samplingPoints(2,:))]';
    end
    
    nSamplingDistance = size(samplingDistance,2);
    nCenterXY = size(centerXY,2);
    
    nMax = max([nSamplingDistance,nCenterXY]);
    if nSamplingDistance < nMax
        samplingDistance = cat(2,samplingDistance,repmat(samplingDistance(:,end),[1,nMax-nSamplingDistance]));
    end
    if nCenterXY < nMax
        centerXY = cat(2,centerXY,repmat(centerXY(:,end),[1,nMax-nCenterXY]));
    end
    xlin = uniformSampling1D(samplingPoints(1),centerXY(1,:),samplingDistance(1,:));
    ylin = uniformSampling1D(samplingPoints(2),centerXY(2,:),samplingDistance(2,:));
end

