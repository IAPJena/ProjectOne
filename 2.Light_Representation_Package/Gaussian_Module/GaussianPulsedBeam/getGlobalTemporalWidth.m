function [ globalTemporalWidth ] = getGlobalTemporalWidth( gaussianPulsedBeam )
%getGlobalTemporalWidth Returns the global full width of the pulsed beam in
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
    Qinv11_Imag = imag(Qinv(1,1));
    Qinv12_Imag = imag(Qinv(1,2));
    Qinv22_Imag = imag(Qinv(2,2));
    
     globalTemporalWidth= sqrt((centralWavelength/pi)*(Qinv11_Imag/(Qinv11_Imag*Qinv22_Imag + Qinv12_Imag^2)));
end