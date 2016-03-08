function [ pupilCoordinates ] = computePupilCoordinates( rayBundlePosition,...
        rayBundleDirection,axialLocationOfThePupil )
    %GETPUPILCOORDINATES returns the pupil coordinates given a ray bundle
    %and location of the pupil
    
    linePoint = rayBundlePosition;
    lineVector = rayBundleDirection;
    
    planePoint = [0;0;axialLocationOfThePupil];
    planeNormalVector = [0;0;1];
    
    [linePlaneIntersection,distance] = computeLinePlaneIntersection(...
        linePoint,lineVector,planePoint,planeNormalVector);
    
    pupilCoordinates = linePlaneIntersection(1:2,:);
end

