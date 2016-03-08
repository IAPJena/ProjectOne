function [ normMatrix ] = computeNormOfMatrix( inMatrix, dim )
% COMPUTENORMOFMATRIX Computes the norm of matrix in a given dimension and
% gives the result in the form of matrix (vector) with one less dimenstion
% than the given matrix.

if nargin < 0
    disp('Error: The function computeNormOfMatrix requires arguement');
    normMatrix = 0;
    return;
elseif nargin == 1
    % default dimension for computing norm
    dim = 1;
else
end
normMatrix = sqrt(sum(inMatrix.^2,dim));

end

