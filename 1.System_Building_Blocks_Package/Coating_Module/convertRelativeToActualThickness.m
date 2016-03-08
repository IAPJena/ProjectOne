function [ absoluteThickness ] = convertRelativeToActualThickness( opticalThickness,n0,wavLen0 )
    % convertRelativeToActualThickness: 
    %   Compute the actual thickness for relative definition
    %   Change the thickness from relative value to absloute
    %   The actual thickness of the coating is determined by:
    %   d = (wavLen0/n0)*T
    %   where wavLen0 is the primary wavelength in meters ,
    %   n0 is the real part of the index of refraction of the coating at the
    %   primary wavelength, and T is the "optical thickness" of the coating
    %   specified in the coating definition.
    % Inputs:
    %   ( opticalThickness,n0,wavLen0 )
    % Outputs:
    %   [ absoluteThickness ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version

    absoluteThickness = (wavLen0./n0).*opticalThickness;
end

