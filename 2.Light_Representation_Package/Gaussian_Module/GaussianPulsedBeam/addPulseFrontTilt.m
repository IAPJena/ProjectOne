function [ modifiedPulsedBeam ] = addPulseFrontTilt( initialPulsedBeam,additionalPFT )
%ADDPULSEFRONTTILT Adds an additional PFT to the pulsed beam
% additionalPFT : Value should be in s/m

% change the off diagonal elements of the Q matrix with out affecting others 

G = additionalPFT;
F = initialPulsedBeam.CentralWavelength*G;
idealPFTKMatrix = [1,0,0,0;
                   0,1,0,F;
                   G,0,1,0;
                   0,0,0,1];              
modifiedPulsedBeam = initialPulsedBeam.propagateUsingKostenbauder(idealPFTKMatrix);

% Alternative method
% initialQInverse = initialPulsedBeam.QInverseMatrix;
% % initialQinv = inv(initialPulsedBeam.QMatrix);
% modifiedQInverse = initialQInverse;
% modifiedQInverse(1,2) = initialQInverse(1,2) + 1i*additionalPFT*imag(initialQInverse(2,2));
% modifiedQInverse(2,1) = -modifiedQInverse(1,2);
% % modifiedQMatrix = inv(modifiedQInverse);
% 
% modifiedPulsedBeam = GaussianPulsedBeam;
% modifiedPulsedBeam.QInverseMatrix = modifiedQInverse;
% modifiedPulsedBeam.CentralWavelength = initialPulsedBeam.CentralWavelength;
end

