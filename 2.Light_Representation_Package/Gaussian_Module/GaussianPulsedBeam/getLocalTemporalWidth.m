function [ localTemporalWidth ] = getLocalTemporalWidth( gaussianPulsedBeam )
%getLocalTemporalWidth Returns the local full width of the pulsed beam in
%temporal domain.

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
    Qinv = gaussianPulsedBeam.QInverseMatrix;
    centralWavelength = gaussianPulsedBeam.CentralWavelength;
    Qinv22_Imag = imag(Qinv(2,2));
    localTemporalWidth = sqrt((centralWavelength/pi)*(1/Qinv22_Imag));
end