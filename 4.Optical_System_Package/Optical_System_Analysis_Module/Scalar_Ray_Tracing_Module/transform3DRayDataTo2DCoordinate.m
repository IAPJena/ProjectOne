function [ localRayPosition,localRayDirection ] = transform3DRayDataTo2DCoordinate( ...
        baseRayDirection,baseRayPoint,secondaryRayDirection,secondaryRayPoint,...
        refrencePoint,localXDirection,localYDirection)
    %TRANSFORM3DRAYDATATO2DCOORDINATE COnverts the 3d ray data to 2d local
    %coordinate formed by the base ray and plane perpendicular to base ray
    %  baseRayDirection,baseRayPoint,secondaryRayDirection,secondaryRayPoint:
    %  direction cosines and points on the base and secondary ray (3x1 vector)
    %  refrencePoint: point through which the plane perpendicular to the base
    %  ray passes
    % The function is vectorized and so can accept 3xN inputs and gives 3xN
    % outputs
    
    % Compute the distance of the intersection point of the given points along
    planePoint = refrencePoint;
    planeNormalVector = baseRayDirection;
    baseRayIntersection = computeLinePlaneIntersection(baseRayPoint,baseRayDirection,planePoint,planeNormalVector);
    secondaryRayIntersection = computeLinePlaneIntersection(secondaryRayPoint,secondaryRayDirection,planePoint,planeNormalVector);
    
    % Now compute the relative height and direction of the secondary ray w.r.t
    % base ray
    relativeHeightVector = secondaryRayIntersection - baseRayIntersection;
    relativeDirectionCosines = secondaryRayDirection - ...
        repmat(compute3dDot(baseRayDirection,secondaryRayDirection),[3,1]).*baseRayDirection;
    
    % Now project these to 2D local coordinates
    % Assume thar the refernce point lies on the local x axis (this is always
    % valid if the reference point lies in the origin of the new local coordinate whuch is always the case)
    localRayPosition = [compute3dDot(relativeHeightVector,localXDirection);...
        compute3dDot(relativeHeightVector,localYDirection)];
    localRayDirection  = [compute3dDot(relativeDirectionCosines,localXDirection);...
        compute3dDot(relativeDirectionCosines,localYDirection)];
end

