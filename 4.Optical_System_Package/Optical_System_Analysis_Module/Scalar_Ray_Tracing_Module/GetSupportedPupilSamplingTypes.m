function [ fullNames,displayNames ] = GetSupportedPupilSamplingTypes(index)
    % GetSupportedPupilSamplingTypes Returns the currntly supported pupil
    % sampliong types as cell array
    % Inputs:
    %   ( )
    % Outputs:
    %   [ fullNames,displayNames ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Sep 17,2015   Worku, Norman G.     Original Version
    if nargin < 1
        index = 0;
    end
    fullNames = {'Cartesian','Polar','Tangential','Sagittal','Cross','Random'};
    displayNames = {'Cartesian','Polar','Tangential','Sagittal','Cross','Random'};
    if index
        fullNames  = fullNames{index};
        displayNames  = displayNames{index};
    end
end

