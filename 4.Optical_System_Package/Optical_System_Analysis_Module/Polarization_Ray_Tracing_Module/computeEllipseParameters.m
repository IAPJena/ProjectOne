function ellipseParameters = computeEllipseParameters( polarizationVector)
    % computeEllipseParameters: computes ellipse parameters for a polarization
    % vector in XY Plane. The function is vectorized so it can work on
    % multiple inputs once at the same time.
    % Input:
    %   polarizationVector: The electric field vector for which elliplse is calculated 
    % Output:
    %   ellipseParameters: [a,b,rotation,angle] a&b: smi major and minor
    %   axis of the ellipse,rotation: +1 for Clockwise ellipse and -1 for
    %   counterclockwise ellipse. angle: the inclination angle of the
    %   ellipse in degree.
    %   The function is also vectorized so if the inputs are array then 
    %   the output will also be array of the same size.
    
    % For this time consider only XY plane
    % But later expand to any arbitrary plane in space described by ellNormal
    % computeEllipseParameters( polarizationVector,ellNormal)
    
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

    %%%% Checked with Zemax and Works Well%%%%%%%%%%
    Ex = polarizationVector(1,:);
    Ey = polarizationVector(2,:);
    ellipseParameters = convertJonesVectorToPolarizationEllipse(Ex,Ey);
end

