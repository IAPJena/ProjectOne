function [ initialRayBundleDirections ] = computeInitialRayBundleDirections...
    (fieldPointPosition,pupilSamplingPoints)
    % computeInitialRayBundleDirections: computes and returns direction of 
    % rays in a ray bundle starting from a point in the object plane. For 
    % objects at infinity an imaginary object plane (which is 1 units behind
    % the 1st surface) is used.
    % The function is vectorized so initial directions for multiple field
    % points can be computed at the same time.
    % Input:
    %   fieldPointPosition: 3 X nField Matrice of Position of object point 
    %   which is initial position of all rays.
    %   pupilSamplingPoints: 3 X nRay  matrix containg values of 
    %   pupil sampling coordinates for all field points (the same for all).

    % Outputs:
    %   initialRayBundleDirections: matrix of ray bundle directions on the
    %   object plane
    
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
    % Jan 20,2014   Worku, Norman G.     Vectorized version
    
	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    nRay = size(pupilSamplingPoints,2);
    nField = size(fieldPointPosition,2);
    
    % Make both matrices of 3X(nRay*nField) matrix to enable simple subtraction
    % field1,field1,field1 . . . field2,field2,field2 . . . .
    
    pupilSamplingPoints = repmat(pupilSamplingPoints,[1,nField]);    
    allFieldPosition = cellfun(@(x) x*ones(1,nRay),...
        num2cell(fieldPointPosition,[1]),'UniformOutput',false);
    fieldPointPosition = cell2mat(allFieldPosition);
    
    rayDir = pupilSamplingPoints-fieldPointPosition; 

    dirMag =  sqrt((sum((rayDir).^2,1)));
    dirMag = ones(3,1)*dirMag;% repmat(dirMag,[3,1]);
    
    % if pupil is to the left of field point, the ray direction should be
    % negated to get real ray.
    initialRayBundleDirections = rayDir./dirMag;
end

