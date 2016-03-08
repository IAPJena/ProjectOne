function [ newGaussianBeamSet ] = ...
        GenerallyAstigmaticGaussianBeamSet( complexRay1Position,...
        complexRay1Direction,complexRay2Position,complexRay2Direction,...
        centralRayPosition,centralRayDirection,wavelength,totalOpticalPathLength )
    %GENERALLYASTIGMATICGAUSSIANBEAMSET Defines a generally astigmatic
    %gaussain beam using the complex ray parameters
    
    if nargin < 7
        disp(['Error: The function GenerallyAstigmaticGaussianBeamSet ',...
            'requires atleast 7 input arguments : complexRay1Position,',...
            'complexRay1Direction,complexRay2Position,complexRay2Direction,',...
            'centralRayPosition,centralRayDirection and wavelength.']);
        newGaussianBeamSet = NaN;
        return;
    end
    if nargin < 8
        totalOpticalPathLength = 0;
    end
    newGaussianBeamSet.ComplexRay1Position = complexRay1Position;
    newGaussianBeamSet.ComplexRay1Direction = complexRay1Direction;
    newGaussianBeamSet.ComplexRay2Position = complexRay2Position;
    newGaussianBeamSet.ComplexRay2Direction = complexRay2Direction;
    newGaussianBeamSet.CentralRayPosition = centralRayPosition;
    newGaussianBeamSet.CentralRayDirection = centralRayDirection;
    newGaussianBeamSet.Wavelength = wavelength;
    newGaussianBeamSet.TotalOpticalPathLength = totalOpticalPathLength;
    newGaussianBeamSet.ClassName = 'GenerallyAstigmaticGaussianBeamSet';
end

