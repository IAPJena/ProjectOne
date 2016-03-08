function [ normalizedMatrix,magnitudeVector ] = normalize2DMatrix( inMatrix, dim )
    % NORMALIZE2DMATRIX Normalizes the input 2D matrix in a given dimension
    if nargin == 0
        disp('Error: The function normalize2DMatrix requires atleast the matrix argument.');
        normalizedMatrix = NaN;
        return;
    elseif nargin == 1
        dim = 1;
    else
    end
    magnitudeVector = sqrt(sum(inMatrix.^2,dim));
    switch dim
        case 1
            normalizedMatrix = inMatrix./repmat(magnitudeVector,[size(inMatrix,dim),1]);
        case 2
            normalizedMatrix = inMatrix./repmat(magnitudeVector,[1,size(inMatrix,dim)]);
    end
end

