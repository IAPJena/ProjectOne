function [ fullNames,displayNames ] = GetSupportedSurfaceApertureOuterShapes(index)
    % GetSupportedApertureOuterShapes Returns the currntly supported aperture outer shapes as cell array
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
    if nargin < 1
        index = 0;
    end
    displayNames = {'Circular','Elliptical','Rectangular'};
    fullNames = {'Circular','Elliptical','Rectangular'};
    if index
        displayNames = displayNames{index};
        fullNames = fullNames{index};
    end
end

