function [ groupIndex,refractiveIndex, refractiveIndex_FirstDerivative ] = getGroupRefractiveIndex( glass,wavLen )
    % GETGROUPREFRACTIVEINDEX Computes the group refractive index of the glass
    % for the pulse with central wavelength given. In addition to the group
    % index the function also returns the refractive index and its first
    % derivative as they are part of the computation. 
    % Formula used: Group_Index = n(wavLen) + wavLen*dn/dwavLen
    
    % Inputs:
    %   (glass,wavLenInM,derivativeOrder)
    % Outputs:
    %   [refractiveIndex]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    refractiveIndex = getRefractiveIndex(glass,wavLen,0);
    refractiveIndex_FirstDerivative = getRefractiveIndex(glass,wavLen,1);
    groupIndex = refractiveIndex - (wavLen).*refractiveIndex_FirstDerivative;
end

