function [linePlaneIntersection,distance] = computeLinePlaneIntersection(linePoint,lineVector,planePoint,planeNormalVector)
    %computeLinePlaneIntersection Computes the intersection of a line with a plane
    % linePoint,lineVector: A point in the line and unit vector in the dirtection of the line
    % planePoint,planeTangentVector: A point in the plane and unit vector in the
    % surface normal direction
    % The function is vectorized and so can accept 3xN inputs and gives 3xN
    % outputs
    % distance: is signed dostance from the given line point to the
    % intersection point computed
    
    % Make sure that sizes of all inputs are equal. Otherwise make them equal
    % by repeating the last value till maximum number is reached
    % Determine the size of each inputs
    nLinePoint = size(linePoint,2);
    nLineVector = size(lineVector,2);
    nPlanePoint = size(planePoint,2);
    nPlaneNormalVector = size(planeNormalVector,2);
    % The number inputs is maximum of all inputs
    nMax = max([nLinePoint,nLineVector,nPlanePoint,nPlaneNormalVector]);
    
    
    % Fill the smaller inputs to have nMax size by repeating their
    % last element
    if nLinePoint < nMax
        linePoint = cat(2,linePoint,repmat(linePoint(:,end),[1,nMax-nLinePoint]));
    end
    if nLineVector < nMax
        lineVector = cat(2,lineVector,repmat(lineVector(:,end),[1,nMax-nLineVector]));
    end
    if nPlanePoint < nMax
        planePoint = cat(2,planePoint,repmat(planePoint(:,end),[1,nMax-nPlanePoint]));
    end
    if nPlaneNormalVector < nMax
        planeNormalVector = cat(2,planeNormalVector,repmat(planeNormalVector(:,end),[1,nMax-nPlaneNormalVector]));
    end
    
    
    % Normalize
    lineVector = normalize2DMatrix(lineVector);
    planeNormalVector = normalize2DMatrix(planeNormalVector);
    % Compute the distance of the intersection point of the given points along
    % the ray direction with the plane
    cosineOfAngle = compute3dDot(planeNormalVector,lineVector);
    nonIntersectingLines = (abs(cosineOfAngle) < 10^-10);
    distance(~nonIntersectingLines) = -compute3dDot(planeNormalVector(:,~nonIntersectingLines),linePoint(:,~nonIntersectingLines)-planePoint(:,~nonIntersectingLines))./...
        compute3dDot(planeNormalVector(:,~nonIntersectingLines),lineVector(:,~nonIntersectingLines));
    distance(nonIntersectingLines) = Inf;
    % Compute the intersection points
    linePlaneIntersection = linePoint + lineVector.*repmat(distance,[3,1]);
end

