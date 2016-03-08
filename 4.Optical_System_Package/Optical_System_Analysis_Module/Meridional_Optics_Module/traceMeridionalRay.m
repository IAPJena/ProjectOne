function [ Zpoints,Ypoints ] = traceMeridionalRay( y0,U0,refIndex,thick,curv)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
surfVertexZ = 0;
P0 = [0,y0,0];
D0 = [0,sin(U0),cos(U0)];
[Q,U] = convertPDToQUParameter(P0,D0,surfVertexZ);
Z = 0;
Y = y0;
for kk=2:1:length(curv)
    surfVertexZ = surfVertexZ+thick(kk-1);
    surfRadius = 1/curv(kk);
    [Q, U] = QUTrace(Q,U,kk-1,kk, refIndex,thick,curv);
    [P,D] = convertQUToPDParameter(Q,U,surfVertexZ,surfRadius);
    Z = [Z P(3)];
    Y = [Y P(2)];
end
Zpoints = Z;
Ypoints = Y;
end

