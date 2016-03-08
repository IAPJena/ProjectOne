function polarizationXYZ = ...
        convertSPToXYZPolarization...
        (jonesVectorSP,rayDirection,surfaceNormal)
    % convertSPToXYZPolarization: Converts a given jones vector in SP 
    % coordinate to polarization vector in XYZ axis based on the coordinate 
    % transformation concept. 
    % The function is vectorized so if the inputs are vectors then 
    % the output will also be vector of the same size.
    % 
    % Inputs:
    %   jonesVectorSP: % 2xN matrix : complex valued jones vector in s-p axis 
    %                      [Jsmag*exp(i*Jsphase);Jpmag*exp(i*Jpphase)]
    %   rayDirection: 3XN matrix : direction cosines of the ray
    %   surfaceNormal: 3XN matrix with each column corresponding to the
    %   surface normal used for conversion.
    % Outputs:
    %   polarizationXYZ: 3XN matrix : The electric field vector in XYZ
    %   coordinate

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

    nRay = size(jonesVectorSP,2);    
    % Form a marix of local polarization vector from the jones vector
    localVector = [jonesVectorSP;zeros(1,nRay)];
    
    % Find axes of spk local coordinate interms of global xyz coordinate
    dirK = rayDirection;
    % Using surfaceNormal Axis Reference: 
    % The dirS vector is determined from dirK X surfaceNormal, and then dirP = dirK X dirS
    % If dirK and surfaceNormal are parallel, then dirS is just made same as X axis.
    dirS = compute3dCross(dirK,surfaceNormal);
    dirKParallelToSurfNormal = sum(abs(dirS),1)==0;
    if sum(dirKParallelToSurfNormal)
        dirS(:,dirKParallelToSurfNormal) = [1;0;0];
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
    
    polarizationXYZ = product3DMatrix;
end

