function [ fullNames,shortNames ] = GetSupportedCoatingTypes()
    % GetSupportedCoatingTypes Returns the currntly supported coatings as cell array
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
    
    shortNames = {'BARE','JMAT','MULT','NULL'};
    fullNames = {'BareGlass','JonesMatrix','MultilayerCoating','NullCoating'};
end

