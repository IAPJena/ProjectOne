function [ px, py, pz] = changeCoordinate( ps,pp,pk,dirS,dirP,dirK )
    % changeCoordinate: Returns the point (ps,pp,pk) in spk in the new
    % orthonormal coordinate xyz. The function is vectorized so if the
    % inputs are vectors then the output will also be vector of the same size.
    % Inputs
    %   ps,pp,pk: point in the old coordinate spk
    %   dirS,dirP,dirK = [Sx,Sy,Sz]',... vectors describing axes of orthonormal 
    %                   coordinate spk in terms of xyz coordinate    
    %  NB. For vector inputs the dirS,dirP and dirK = 3XN matrices where N is number of
    %  inputs and the ps,pp and pk = 1XN vector
    % Outputs
    %   px py pz: the point in new coordinate system.

    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % normalize the new coordinate system vectors
    % check for orthogonality
    nRay = size(dirS,2);
    dirS = dirS./(repmat(sqrt(sum(dirS.^2,1)),[3,1]));
    dirP = dirP./(repmat(sqrt(sum(dirP.^2,1)),[3,1]));
    dirK = dirK./(repmat(sqrt(sum(dirK.^2,1)),[3,1]));

    px = dirS(1,:).* (ps) + dirP(1,:).* (pp) + dirK(1,:).* (pk);
    py = dirS(2,:).* (ps) + dirP(2,:).* (pp) + dirK(2,:).* (pk);
    pz = dirS(3,:).* (ps) + dirP(3,:).* (pp) + dirK(3,:).* (pk);
end

