function [ scaledQMatrix ] = computeScaledQMatrixFromQInverseMatrixInSI( QInverseMatrixInSI )
%computeScaledQMatrixFromQInverse Since the scaling of QInv matrix is bad it is
%not safe to invert it direclt,so it should be rescaled (unit of distance
%to mm and time to fs). The resulting scaledQMatrix is scaled and shall be
% used with scaled kostenbauder matrices

QinvScaled = scaleQInverseMatrix(QInverseMatrixInSI);
scaledQMatrix = inv(QinvScaled);
end

