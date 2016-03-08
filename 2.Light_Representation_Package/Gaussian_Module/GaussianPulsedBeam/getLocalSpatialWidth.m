function [ localSpatitalWidth ] = getLocalSpatialWidth( gaussianPulsedBeam )
%getLocalSpatialWidth Returns the local full width of the pulsed beam in
%spatial domain.

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
    
    localSpatitalWidth = sqrt((centralWavelength/pi)*(-1/Qinv11_Imag));    
end

