function [ newHarmonicFieldSet ] = convertGaussianBeamSetToHarmonicFieldSet( ...
        gaussianBeamSet,Nx,Ny,windowSizeX,windowSizeY,coherentSuperposition )
    %convertGaussianBeamSetToHarmonicFieldSet Assume the gaussian
    %beam parameters are all given on the plane perpendicular to the
    %central ray.
    
    if nargin < 5
        disp(['Error: The function convertGaussianBeamSetToHarmonicFieldSet',...
            'requires atleast 5 input arguments, gaussianBeamSet,Nx,Ny,',...
            'windowSizeX and windowSizeY.']);
        newHarmonicFieldSet = NaN;
        return;
    end
    if nargin < 6
        coherentSuperposition = 0;
    end
    
    [ generallyAstigmaticGaussianBeamSet ] = ...
        convertSimpleToGenerallyAstigmaticGaussianBeamSet...
        ( gaussianBeamSet );
    [ newHarmonicFieldSet ] = convertGenerallyAstigmaticGaussianBeamToHarmonicField( ...
        generallyAstigmaticGaussianBeamSet,Nx,Ny,windowSizeX,windowSizeY,coherentSuperposition );
 end

