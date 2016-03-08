function [ dirS,dirP] = directionSP( dirK )
    % directionSP returns direction cosines of local s and p vectors given k
    % vector. The function is vectorized so it can work on multiple inputs 
    % once at the same time.
    % Inputs:
    %   dirK: (3XN matrix) direction cosines of the ray
    % Outputs:
    %   dirS,dirP: (3XN matrix) unit vectors in the direction of local 
    %                           S and P coordinates

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
    
    nRay = size(dirK,2);
    % normalize dirK
    magDirK = sqrt(sum(dirK.^2,1)); % (1XN vector) magDirK = [magK1,magK2,...]
    magDirK = repmat(magDirK,[3,1]); % a 3xN matrix from 1XN vector 
    dirK = dirK./magDirK;
       
    temp = compute3dCross(dirK, repmat([1;0;0],[1,nRay]));
    a = sum(temp,1);
    dirP = repmat([0;1;0],[1,nRay]);
    dirP(:,a~=0) = temp(:,a~=0);

    dirS = compute3dCross(dirP,dirK);

    % just to have similar results with Zemax, let's use its assumption
    dirS = -dirS;
    dirP = -dirP;
end

