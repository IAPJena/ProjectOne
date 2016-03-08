function [ fullNames,displayNames ] = GetSupportedSurfaceApertureTypes(index)
    % GetSupportedApertureTypes Returns the currntly supported aperture as cell array
    % Inputs:
    %   ( )
    % Outputs:
    %   [ fullNames,shortNames ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    %     shortNames = {'FCAP','CRAP','ELAP','RCAP','CROB'};
    if nargin < 1
        index = 0;
    end
    fullNames = {'FloatingCircularAperture','CircularAperture','EllipticalAperture','RectangularAperture','CircularObstruction'};
    displayNames = {'Floating Circular Aperture','Circular Aperture','Elliptical Aperture','Rectangular Aperture','Circular Obstruction'};
    if index
        fullNames = fullNames{index};
        displayNames = displayNames{index};
    end
end

