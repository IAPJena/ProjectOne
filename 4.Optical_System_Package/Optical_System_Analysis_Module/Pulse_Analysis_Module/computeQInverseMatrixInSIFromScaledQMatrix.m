function [ QInverseMatrixInSI ] = computeQInverseMatrixInSIFromScaledQMatrix( scaledQMatrix )
%computeQInverseFromScaledQMatrix Since scaledQMatrix is scaled 
% (unit of distance to mm and time to fs)to make inversion process 
% non singular, Now it should be inverted and changed back to SI units
% (unit of distance to m and time to s). 

QinvScaled = inv(scaledQMatrix);
QInverseMatrixInSI = convertScaledQInverseMatrixToSI(QinvScaled);
% QinvScaled = scaleQInverseMatrix(QInverseMatrix);
% scaledQMatrix = inv(QinvScaled);
end

