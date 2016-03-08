function [refLocalRayDirection,TIR] = computeRefractedRayDirection ...
        (incidentDirection,normalVector,indexBefore,indexAfter)
	% COMPUTEREFRACTEDRAYDIRECTION to calculate the new direction after refraction
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	% Ref: Prof Gross Lecture notes (Optical System Design I, Chapter 1)

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Part of the RAYTRACE toolbox
	%   Written by: Yi Zhong 05.03.2013
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
	% 04.09.2012    Yi Zhong             Original Version         Version 2.1
	% Oct 14,2013   Worku, Norman G.     OOP Version              Use snell's law in 3D
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    
	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%     try
        nRay = size(incidentDirection,2);

        % use the 3D snells law from Prof. Gross Script.
        u = (indexBefore./indexAfter); % scalar
        s = incidentDirection;
        e = normalVector;
        %  normalize s if the mag is d/t from unity but now both incident
        %  directions and surface normals are assumed to be unit vectors!!
        edots = compute3dDot(e,s);
        sp = (ones(3,1)*u).*s + (ones(3,1)*(-u.*edots+sqrt(1-(u.^2).*(1-edots.^2)))).*e;
        %sp = repmat(u,[3,1]).*s+repmat((-u.*edots+sqrt(1-(u.^2).*(1-edots.^2))),[3,1]).*e;
        refLocalRayDirection = sp ;
        TIR = zeros([1,nRay]);

        totIR = (imag(sum(sp,1))~=0);
        refLocalRayDirection(:,totIR) = NaN ;
        TIR(totIR) = 1;   
%     catch err
% 
%          %open file
%          fid = fopen('logFile','a+');
%          % write the error to file
%          % first line: message
%          fprintf(fid,'%s\n',err.message);
%          % following lines: stack
%          for e=1:length(err.stack)
%             fprintf(fid,'%sin %s at %i\n',txt,err.stack(e).name,err.stack(e).line);
%          end
%          % close file
%          fclose(fid)   
%          msgbox(strcat(err.message,' So the function "computeRefractedRayDirection" will return NaN'), 'Program Error','error');
%          refLocalRayDirection = repmat([NaN;NaN;NaN],[1,nRay]); 
%          TIR = NaN([1,nRay]); 
%     end
end


