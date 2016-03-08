function polarizationVector = convertJVToPolVector(JV,dirK)
    % convertJonesVectToPolVect Converts a given jones vector to polarization
    % vector. The function is vectorized so if the inputs are vectors then 
    % the output will also be vector of the same size.
    % 
    % Inputs:
    %   JV: % 2xN matrix : complex valued jones vector in s-p axis 
    %                      [Jsmag*exp(i*Jsphase);Jpmag*exp(i*Jpphase)]
    %                     If JV is just single vector then it is used for
    %                     all ray directions given
    %   dirK: 3XN matrix : direction cosines of the ray
    % Outputs:
    %   polarizationVector: 3XN matrix : The electric field vector

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

    % Extract the S and P component from the jones vector
    if size(JV,2) == 1
        nRay = size(dirK,2);
        JV = repmat(JV,[1,nRay]);
    end
    fieldS = JV(1,:);
    fieldP = JV(2,:);
    [dirS,dirP] = directionSP(dirK);
    [Fx,Fy,Fz] = changeCoordinate(fieldS,fieldP,0,dirS,dirP,dirK);

    polarizationVector = [Fx;Fy;Fz];

end

