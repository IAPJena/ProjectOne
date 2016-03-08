function [ initialRayBundlePositions2 ] = computeInitialRayBundlePositions...
        (commonRayDirectionCosine,pupilSamplingPoints,entrancePupilLocationZ,objThick)
    % computeInitialRayBundlePositions: computes and returns positions of a
    % collimated ray bundle at the object plane. For objects at infinity an
    % imaginary object plane (which is 1 units behind the 1st surface) is
    % used.
    % The function is vectorized so initial directions for multiple field
    % points can be computed at the same time.
    % Input:
    %   commonRayDirectionCosine: 3 X nField Matrice of Direction cosine commn to all collimated
    %   rays
    %   pupilSamplingPoints: 3 X nRay X nField matrix containg values of pupil sampling
    %   coordinates.
    %   entrancePupilLocationZ: Location of entrance pupil from the first lens surface
    %   objThick: thickness related to the object surface
    % Outputs:
    %   initialRayBundlePositions: matrix of ray bundle positions on the
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
    nField = size(commonRayDirectionCosine,2);
    
    % Make both matrices of 3X(nRay*nField) matrix to enable simple subtraction
    % field1,field1,field1 . . .(nRay times), field2,field2,field2 . . . .
    pupilSamplingPoints = repmat(pupilSamplingPoints,[1,nField]);
    
    allFieldDirectionCosine = cellfun(@(x) x*ones(1,nRay),...
        num2cell(commonRayDirectionCosine,[1]),'UniformOutput',false);
    allRayDirectionCosine = cell2mat(allFieldDirectionCosine);
    
    objZ = - objThick;
    dx = allRayDirectionCosine(1,:);
    dy = allRayDirectionCosine(2,:);
    dz = allRayDirectionCosine(3,:);
    
    % ray position at plane Z = - objThick;
    rayPosX = pupilSamplingPoints(1,:) - ...
        (dx./dz).*(pupilSamplingPoints(3,:)-objZ);
    rayPosY = pupilSamplingPoints(2,:,:) - ...
        (dy./dz).*(pupilSamplingPoints(3,:)-objZ);
    rayPosZ = objZ*ones(1,nRay*nField); %repmat(objZ,[1,nRay*nField]);
    initialRayBundlePositions = cat(1,rayPosX,rayPosY,rayPosZ);
    
    % compute intersection point of the rays with plane perpendicular
    % to cheif ray (for each field) and meeting with the cheif ray at Z = - objThick;
    % find cheif ray indices which passes the pupil at (0,0,Zp)
    cheifRayIndices = find(pupilSamplingPoints(1,:) + pupilSamplingPoints(2,:)==0);
    if isempty(cheifRayIndices)
        initialRayBundlePositions2 = initialRayBundlePositions;
    else
        for pp = 1:nField
            rayIndexRange = [(pp-1)*nRay+1:(pp)*nRay];
            % compute intersection point of the rays with plane perpendicular
            % to cheif ray and meeting with the cheif ray at z = 0;
            linePoint = initialRayBundlePositions(:,rayIndexRange);
            lineVector = allRayDirectionCosine(:,rayIndexRange);
            planePoint = initialRayBundlePositions(:,cheifRayIndices(pp));
            planeNormalVector = allRayDirectionCosine(:,cheifRayIndices(pp));
            [linePlaneIntersection(:,rayIndexRange),distance] = computeLinePlaneIntersection(linePoint,lineVector,planePoint,planeNormalVector);
            
        end
        initialRayBundlePositions2 = linePlaneIntersection;
    end
end
