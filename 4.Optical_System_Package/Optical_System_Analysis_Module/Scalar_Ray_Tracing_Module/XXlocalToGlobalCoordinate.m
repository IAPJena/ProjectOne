function [globalRayIntersectionPoint,globalExitRayPosition,globalSurfaceNormal,globalIncidentRayDirection,...
        globalExitRayDirection,globalRayPolarizationVectorBefore,globalRayPolarizationVector] = ...
        localToGlobalCoordinate(localRayIntersectionPoint,localExitRayPosition,...
        localSurfaceNormal,localIncidentRayDirection,localExitRayDirection,...
        surfaceCoordinateTM,polarized,localRayPolarizationVectorBefore,localRayPolarizationVector)
    
	% LOCALTOGLOBALCOORDINATE the transfer from the local coordinate system back to 
	% the reference coordinate system 
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
	%   REF:G.H.Spencer and M.V.R.K.Murty, GENERAL RAY-TRACING PROCEDURE
	% Inputs:
	%   localRayData
	%   polarized: Indicator for polarized ray.
	%   localSurfaceNormal: (normal vector to the surface in local coordinate system)
    %   surfaceCoordinateTM: 4x4 coordinate transfer
    %   matrices for local surface and reference coordinate system
    %   localIncidentRayDirection,localExitRayDirection: Incident and exit ray direction 
	%                                                      cosines in local coordinate
	% Output:
	%   globalRayData: 
	%   globalSurfaceNormal: (normal vector to the surface in global coordinate system)
	%   globalIncidentRayDirection,globalExitRayDirection: Incident and exit ray direction 
	%                                                      cosines in global coordinate
	
   % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Part of the RAYTRACE toolbox
	%   Written by: Yi Zhong 05.03.2013
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University  
	
	%   Modified By With New Algorithms: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% 04.09.2012    Yi Zhong             Original Version         Version 2.1
	% Oct 14,2013   Worku, Norman G.     OOP Version              Version 3.0
    % Dec 22,2013   Worku, Norman G.     New Algorithm
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    
	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        nRay = size(localRayIntersectionPoint,2);
        
        surfGlobalPosition = surfaceCoordinateTM(1:3,4);
        toLocalRotation = surfaceCoordinateTM(1:3,1:3); % from global to local
        toGlobalRotation = toLocalRotation';
		% coordinates of Pj in the reference system
        globalRayIntersectionPoint = (toGlobalRotation*localRayIntersectionPoint + ...
            repmat(surfGlobalPosition,[1,nRay]));
        globalExitRayPosition = (toGlobalRotation*localExitRayPosition + ...
            repmat(surfGlobalPosition,[1,nRay]));

		% direction cosines of the ray in the reference system
        if polarized
            globalRayPolarizationVectorBefore = (toGlobalRotation*localRayPolarizationVectorBefore); 
            globalRayPolarizationVector = (toGlobalRotation*localRayPolarizationVector);             
        else
            globalRayPolarizationVectorBefore = repmat([NaN;NaN;NaN],[1,nRay]);
			globalRayPolarizationVector = repmat([NaN;NaN;NaN],[1,nRay]);
        end
        
        globalSurfaceNormal = (toGlobalRotation*localSurfaceNormal);
        globalIncidentRayDirection = (toGlobalRotation*localIncidentRayDirection);
        globalExitRayDirection = (toGlobalRotation*localExitRayDirection);
end

