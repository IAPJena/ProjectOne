function [NAI,exitPupilLocation,exitPupilDiameter,entrancePupilDiameter,...
        entrancePupilPupilLocation,angularMagnification,paraxialImageDistance] = ...
        getImageNA(optSystem,wavLen)
    % getImageNA: returns image space NA of the optical system

    if nargin < 2
        wavLen = getPrimaryWavelength(optSystem);
    end
    exitPupilLocation = getExitPupilLocation(optSystem,wavLen);
    
    [exitPupilDiameter,entrancePupilDiameter,entrancePupilPupilLocation,...
        angularMagnification] = getExitPupilDiameter(optSystem,wavLen);
    
    [surfaceArray, numberOfSurfaces ] = getSurfaceArray(optSystem);
    lastButOneSurf = surfaceArray(numberOfSurfaces-1);
    
    imageRefractiveIndex = getRefractiveIndex(lastButOneSurf.Glass,wavLen);
    imageThick = lastButOneSurf.Thickness;
    paraxialImageDistance = getParaxialImageLocation(optSystem);
    NAI = computeImageNA...
        (exitPupilLocation,exitPupilDiameter, imageRefractiveIndex,...
        imageThick, paraxialImageDistance);
end