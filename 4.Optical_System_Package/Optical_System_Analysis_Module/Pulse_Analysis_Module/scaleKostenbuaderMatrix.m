function [ scaledKMatrix ] = scaleKostenbuaderMatrix( KMatrix )
%SCALEKOSTENBUADERMATRIX scales the K matrix so that the distance is in mm
%and time is in fs (NB: Freq from 1/s to 1/fs)

tempKMatrix = KMatrix;
tempKMatrix(1,:) = tempKMatrix(1,:)*10^3;
tempKMatrix(3,:) = tempKMatrix(3,:)*10^15;
tempKMatrix(4,:) = tempKMatrix(4,:)*10^-15;

tempKMatrix(:,1) = tempKMatrix(:,1)*10^-3;
tempKMatrix(:,3) = tempKMatrix(:,3)*10^-15;
tempKMatrix(:,4) = tempKMatrix(:,4)*10^15;

scaledKMatrix = tempKMatrix;
end

