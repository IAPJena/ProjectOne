function incidenceAngle = computeIncidenceAngle (incidentDirection,surfaceNormal);
	% COMPUTEINCIDENCEANGLE to calculate the incident angle inc (the angle betweent 
	% the incident ray and the normal vector of the surface) according to the direction 
	% cosines of the ray
	% Inputs:
	%   incidentDirection: is a 1-by-3 vector, which is the directions cosines of the ray (j-1)
	%   surfaceNormal: 1-by-3 element vector, which is the normal vector cosines of the 
	%                  surface j at the intersection point.
	% Output:
	% incidenceAngle: scalar which is the local incident angle of the surface j and the 0<=inc<=(pi/2)
	
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
	% 29.08.2012    Yi Zhong             Original Version         Version 2.1
	% Oct 14,2013   Worku, Norman G.     OOP Version              Version 3.0

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	try
		incidenceAngle = acos(abs((incidentDirection*surfaceNormal')/...
		(norm(incidentDirection)*norm(surfaceNormal)))); % all the angle are expressed 
		% positive and we do not consider that the angle could be negative
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
		 
		msgbox(strcat(err.message,' So the function "computeIncidenceAngle" will return NaN'), ...
		'Program Error','error');
		incidenceAngle = NaN;
	end
end

