function angle = computeAngleBetweenVectors (vect1,vect2);
	% computeAngleBetweenVectors: to calculate the angle between vect1 to vect2
	%  The function is vectorized so it can work on
    % multiple inputs once at the same time.
    %   The function is also vectorized so if the inputs are array then 
    %   the output will also be array of the same size. 
	% Inputs:
	%   vect1,vect2: are 3-by-N vectors, 
	% Output:
	%  angle: NX1 which is the angle between the two vectors. Alaways
	%  between 0rad to +pi rad. Angle is always +Ve 
   
    
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
	% Jan 14,2014   Worku, Norman G.     Original Version              Version 3.0
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    % Compute the scalar product and A.B = |A||B|Cos(theta)
    n = size(vect1,2);
%     angle = atan2(computeNormOfMatrix(compute3dCross(vect1,vect2)),compute3dDot(vect1,vect2));
    
    angle = acos((compute3dDot(vect1,vect2))./...
        ((sqrt(sum(vect1.^2,1))).*(sqrt(sum(vect2.^2,1)))));
end

