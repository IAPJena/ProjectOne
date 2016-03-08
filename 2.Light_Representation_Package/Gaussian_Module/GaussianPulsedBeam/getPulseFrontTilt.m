function [ PFT ] = getPulseFrontTilt( gaussianPulsedBeam )
%getPulseFrontTilt Returns the pulse front tilt parameter for a given
%gaussian pulsed beam.

Qinv = gaussianPulsedBeam.QInverseMatrix;
% Pulse front tilt vs z
PFT = imag(Qinv(1,2))/imag(Qinv(2,2));
end

