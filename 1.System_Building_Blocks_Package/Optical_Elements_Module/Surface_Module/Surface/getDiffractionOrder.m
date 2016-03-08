function [ diffractionOrder ] = getDiffractionOrder( currentSurface )
    %getDiffractionOrder  Returns the diffraction order for standard surfaces
    %and 0 for others.
    % Inputs:
    %   (currentSurface)
    % Outputs:
    %   [diffractionOrder]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    if isfield(currentSurface.UniqueParameters,'DiffractionOrder')
        diffractionOrder = currentSurface.UniqueParameters.DiffractionOrder;
    else
        diffractionOrder = 0;
    end
end

