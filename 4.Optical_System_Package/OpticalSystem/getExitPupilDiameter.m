function [ExitPupilDiameter,EntrancePupilDiameter,EntrancePupilPupilLocation,...
        AngularMagnification] = getExitPupilDiameter(optSystem,wavLen)
    % getExitPupilDiameter: returns EXP diameter
    if nargin < 2
        wavLen = getPrimaryWavelength(optSystem);
    end
    [EntrancePupilDiameter,EntrancePupilPupilLocation] = getEntrancePupilDiameter(optSystem,wavLen);
    AngularMagnification = getAngularMagnification(optSystem,wavLen);
    ExitPupilDiameter = abs(EntrancePupilDiameter/AngularMagnification);
end