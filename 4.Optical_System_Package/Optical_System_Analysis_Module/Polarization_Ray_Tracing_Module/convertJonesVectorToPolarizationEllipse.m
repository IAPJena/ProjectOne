function ellipseParameter = convertJonesVectorToPolarizationEllipse( Ex,Ey )
    % convertJonesVectorToPolarizationEllipse: convert jones vector to
    % polarization ellipse parameter.
    % The function is vectorized so it can work on
    % multiple inputs once at the same time..    
    % Input:
    %   Ex, Ey: The electric field components of jones vector 
    % Output:
    %   ellipseParameter: [a,b,rotation,angle] a&b: smi major and minor
    %   axis of the ellipse,rotation: +1 for Clockwise ellipse and -1 for
    %   counterclockwise ellipse. angle: the inclination angle of the
    %   ellipse in degree
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
    
    nRay = size(Ex,2);
    alpha = atan(abs(Ey./Ex));
    alpha(alpha==0) = 0.0000000001*pi/180;
    alpha(alpha==pi/2) = 89.99999999*pi/180;

    delta = angle(Ey./Ex);
    dir = sign(delta);
    dir(dir==0) = 1;

    % Convert to Poincare
    cond1 = (alpha<= pi/4) & (abs(delta) <= pi/2);
    cond2 = (alpha <= pi/4) & (abs(delta) > pi/2);
    psi(1:nRay) = .5*atan(cos(delta).*tan(2*alpha)) + pi/2;
    psi(cond1) = .5*atan(cos(delta(cond1)).*tan(2*alpha(cond1)));
    psi(cond2) = .5*atan(cos(delta(cond2)).*tan(2*alpha(cond2))) + pi;
    chi = .5*asin(sin(delta).*sin(2*alpha));

    a = sqrt(((abs(Ex)).^2+(abs(Ey)).^2)./(1+(tan(chi)).^2));
    b = a.*abs(tan(chi));

    ellipseParameter = [a;b;dir;psi*180/pi];

end

