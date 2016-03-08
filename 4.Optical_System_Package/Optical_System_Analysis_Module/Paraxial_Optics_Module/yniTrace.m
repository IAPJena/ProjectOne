function [yf uf] = yniTrace(yi,ui,initialSurf,finalSurf, refIndex,thick,curv)
	% ynuTrace: Performs ynu trace for paraxial fileds
	% Inputs
	% 	yi,ui,: height from the optical axis, y, and its slope (tangent of angle), u
	% 	initialSurf,finalSurf,: initial and final surface indices
	% 	refIndex,thick,curv : arrays of n,t of medium following and C of each surface from object to image direction
	% Output
	% 	yf,uf,: height from the optical axis, y, and its slope (tangent of angle), u


    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	% Example Call
	% yniTrace(1,0.56,0,2,[1 1.4 1.4],[4 2 5],[Inf 3 -3])

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

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	if initialSurf==finalSurf
		yf=yi;
		uf=ui;
	elseif initialSurf < finalSurf
		%forward trace
		y=yi;
		u=ui;
		for k=initialSurf:1:finalSurf-1
			t=thick(k);
			c=curv(k+1);
			n=refIndex(k);
			nPrime=refIndex(k+1);
			
			if t~=Inf
				y=y+t*u;
			end
			paI=u+y*c; %The yui method generates the paraxial angles of incidence 
			% during the trace and is probably the most common method used in computer programs.
			u=u+((n/nPrime)-1)*paI;
		end
		yf=y;
		uf=u;
	elseif initialSurf > finalSurf
		%reverse trace
		y=yi;
		u=-ui;    
		for k=initialSurf:-1:1+finalSurf
			t=thick(k-1);
			c=-curv(k);
			n=refIndex(k);
			nPrime=refIndex(k-1);

			paI=u+y*c;
			u=(u+((n/nPrime)-1)*paI);
			if t~=Inf
			   y=y+t*u;
			end
		end  
		yf=y;
		uf=-u;    
	else
		
	end
end

