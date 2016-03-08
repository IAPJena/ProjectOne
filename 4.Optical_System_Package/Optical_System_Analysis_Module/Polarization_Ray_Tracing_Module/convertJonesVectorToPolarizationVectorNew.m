function polarizationVector = ...
        convertJonesVectorToPolarizationVectorNew...
        (jonesVector,rayDirection,surfaceNormal)
    % convertJonesVectorToPolarizationVector: Converts a given jones vector to polarization
    % vector based on the coordinate transformation concept. 
    % The function is vectorized so if the inputs are vectors then 
    % the output will also be vector of the same size.
    % 
    % Inputs:
    %   jonesVector: % 2xN matrix : complex valued jones vector in s-p axis 
    %                      [Jsmag*exp(i*Jsphase);Jpmag*exp(i*Jpphase)]
    %   rayDirection: 3XN matrix : direction cosines of the ray
    %   surfaceNormal: 3XN matrix with each column corresponding to the
    %   surface normal used for conversion.
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
	% Jan 18,2014   Worku, Norman G.     Original Version       Version 3.0
	% Jan 30,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    nRay = size(jonesVector,2);
    % Form a marix of local polarization vector from the jones vector
    localVector = [jonesVector;zeros(1,nRay)];
    
    % Find axes of spk local coordinate interms of global coordinate
    dirK = rayDirection;
    % We use 3rd option in Zemax in the Object space but to generalize for
    % any surface surfaceNormal is taken as input.
    % Using Z Axis Reference: 
    % The S vector is determined from K cross Z, and P = K cross S
    % dirZ = repmat([0;0;1],[1,nRay]);
    
    % The S vector is determined from K cross surfaceNormal, and P = K cross S
    dirS = compute3dCross(dirK,surfaceNormal);
    % For dirK || surfaceNormal => dirS = 0, the S and P components correspond to X and
    % Y components respectively. So handle that condition carefully.
    try 
    % If sum(abs(dirS),1)==0 is false for all then error occurs and we 
    % just want to skip the line in that case as the dirS != 0 for 
    % all and no problem exsists
        dirS(:,sum(abs(dirS),1)==0) = [1;0;0];
    catch
        
    end
    dirP = compute3dCross(dirK,dirS);  
    
    %Normalize the direction cosines
    dirS = dirS./repmat(sqrt(sum(dirS.^2,1)),[3,1]);
    dirP = dirP./repmat(sqrt(sum(dirP.^2,1)),[3,1]);
    dirK = dirK./repmat(sqrt(sum(dirK.^2,1)),[3,1]);
    % Rotation matrix from local to global coordinate. The dirS,dirP and
    % dirK shall be the column of the rotation matrix.
    toGlobalRotation(:,1,:) = dirS;
    toGlobalRotation(:,2,:) = dirP;
    toGlobalRotation(:,3,:) = dirK;
    % Multiply the rotation matrix slicewisely with the
    % localPolarizationVector
    product3DMatrix = multiplySliced3DMatrices( toGlobalRotation,localVector);
    
    polarizationVector = product3DMatrix;
end

