function refRayDirection = computeReflectedRayDirection (incidentDirection,surfaceNormal);

	%COMPUTERELFLECTEDRAYDIRECTION to calculate the new direction after reflection
	%   Ref: G.H.Spencer and M.V.R.K.Murty, GENERAL RAY-TRACING PROCEDURE
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % Inputs:
    %   surfaceNormal: 3-by-N matrix, which is the normal to the surface
	%   incidentDirection: 3-by-N matrix, which is the direction cosines of the unit 
	%                      vector of the direction of the incident ray
    % Output
    %   refRayDirection: 3-by-N matrix, which is the direction cosines of
    %   reflected ray.
   % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Part of the RAYTRACE toolbox
	%   Written by: Yi Zhong 29.08.2012
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University  
	
	%   Modified By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% 06.09.2012    Yi Zhong             Original Version         Version 2.1
	% Oct 14,2013   Worku, Norman G.     OOP Version              Version 3.0
	% Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	try
        nRay = size(incidentDirection,2);
		a = sum((incidentDirection.*surfaceNormal),1)./...
			sum((surfaceNormal.*surfaceNormal),1);
		M = -2*a;
		refRayDirection = incidentDirection + repmat(M,[3,1]).*surfaceNormal;
	catch err
		 %open file
		 fid = fopen('logFile','a+');
		 % write the error to file
		 % first line: message
		 fprintf(fid,'%s\n',err.message);
		 % following lines: stack
		 for e=1:length(err.stack)
			fprintf(fid,'%sin %s at %i\n',txt,err.stack(e).name,err.stack(e).line);
		 end
		 % close file
		 fclose(fid)
	   
		 msgbox(strcat(err.message,' So the function "computeReflectedRayDirection" will return NaN'),...
             'Program Error','error');
		 refRayDirection = repmat([NaN;NaN;NaN],[1,nRay]) ;
	end
end

