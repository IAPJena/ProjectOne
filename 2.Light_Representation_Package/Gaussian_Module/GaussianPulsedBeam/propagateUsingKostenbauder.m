function [ gaussianPulsedBeamOut] = propagateUsingKostenbauder( gaussianPulsedBeamIn, KostenbauderMatrix)
%propagateUsingKostenbauder Propagate gaussian pulsed beam with kostenbuder matrices

% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
%   Written By: Worku, Norman Girma
%   Advisor: Prof. Herbert Gross
%   Part of the RAYTRACE_TOOLBOX
%	Optical System Design and Simulation Research Group
%   Institute of Applied Physics
%   Friedrich-Schiller-University of Jena

% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
% Date----------Modified By ---------Modification Detail--------Remark
% Nov 17,2014   Worku, Norman G.     Original Version


% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
QinvInSI = gaussianPulsedBeamIn.QInverseMatrix;

% Compute the inverse of Qinv using special function which rescales
% the time unit to fs and distance to mm
scaledQMatrix = computeScaledQMatrixFromQInverseMatrixInSI(QinvInSI);
% Scale the Kostenbuader matrix
scaledKostenbauderMatrix = scaleKostenbuaderMatrix(KostenbauderMatrix);
% scale the wavelength
centralWavelength = gaussianPulsedBeamIn.CentralWavelength;
scaledCentralWavelength = centralWavelength*10^3;

Qin = scaledQMatrix;
wavLen = scaledCentralWavelength;
K = scaledKostenbauderMatrix;
scaledQout = (([K(1,1),0;K(3,1),1]*Qin + [K(1,2),K(1,4)/wavLen;K(3,2),K(3,4)/wavLen])...
    *inv(([K(2,1),0;0,0]*Qin + [K(2,2),K(2,4)/wavLen;0,1])));

scaledQInverseOut = inv(scaledQout);
QInvOutInSI = convertScaledQInverseMatrixToSI( scaledQInverseOut );

gaussianPulsedBeamOut = gaussianPulsedBeamIn;
gaussianPulsedBeamOut.QInverseMatrix = QInvOutInSI;
end