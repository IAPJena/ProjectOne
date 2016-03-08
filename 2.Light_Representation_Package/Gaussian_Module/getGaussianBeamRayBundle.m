function [ gaussianBeamRayBundle ] = getGaussianBeamRayBundle( gaussianBeamSet )
    %getGaussianBeamRayBundle Gives the five rays used to represent the gaussian beam
    % In the resulting ray bundle, the ray properties are put in agiven order
    % corresonging for each gaussian beam. They are put in the following order
    % central + waist x + waist y + div x + div y ray properties. That is
    % every 5th property corresponds to the centeral ray and so for others.
    % This speeds up ray tracing by enabling simultanous ray trace for all
    % rays.
    % The code is also vectorized. Multiple inputs and outputs are possible.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    if isGaussianBeamSet(gaussianBeamSet)
        [ waistRayInX,waistRayInY ] = getGaussianBeamWaistRays( gaussianBeamSet );
        [ divergenceRayInX,divergenceRayInY  ] = getGaussianBeamDivergenceRays( gaussianBeamSet );
        centralRay = getGaussianBeamCentralRays( gaussianBeamSet );
    elseif isGenerallyAstigmaticGaussianBeamSet(gaussianBeamSet)
        complexRay1Position = newGaussianBeamSet.ComplexRay1Position;
        complexRay1Direction = newGaussianBeamSet.ComplexRay1Direction;
        complexRay2Position = newGaussianBeamSet.ComplexRay2Position;
        complexRay2Direction = newGaussianBeamSet.ComplexRay2Direction;
        centralRayPosition = newGaussianBeamSet.CentralRayPosition;
        centralRayDirection = newGaussianBeamSet.CentralRayDirection;
        wavelength = newGaussianBeamSet.Wavelength;
        
        waistRayInX = ScalarRayBundle( imag(complexRay1Position),imag(complexRay1Direction),wavelength);
        waistRayInY = ScalarRayBundle( imag(complexRay2Position),imag(complexRay2Direction),wavelength);
        divergenceRayInX = ScalarRayBundle( real(complexRay1Position),real(complexRay1Direction),wavelength);
        divergenceRayInY = ScalarRayBundle( real(complexRay2Position),real(complexRay2Direction),wavelength);
        centralRay = ScalarRayBundle( centralRayPosition,centralRayDirection,wavelength);
    end
    nGaussian = gaussianBeamSet.nGaussian;
    gaussianBeamRayBundle = ScalarRayBundle;
    
    gaussianBeamRayBundle.Position(:,1:5:5*nGaussian) = centralRay.Position;
    gaussianBeamRayBundle.Position(:,2:5:5*nGaussian) = waistRayInX.Position;
    gaussianBeamRayBundle.Position(:,3:5:5*nGaussian) = waistRayInY.Position;
    gaussianBeamRayBundle.Position(:,4:5:5*nGaussian) = divergenceRayInX.Position;
    gaussianBeamRayBundle.Position(:,5:5:5*nGaussian) = divergenceRayInY.Position;
    
    
    gaussianBeamRayBundle.Direction(:,1:5:5*nGaussian) = centralRay.Direction;
    gaussianBeamRayBundle.Direction(:,2:5:5*nGaussian) = waistRayInX.Direction;
    gaussianBeamRayBundle.Direction(:,3:5:5*nGaussian) = waistRayInY.Direction;
    gaussianBeamRayBundle.Direction(:,4:5:5*nGaussian) = divergenceRayInX.Direction;
    gaussianBeamRayBundle.Direction(:,5:5:5*nGaussian) = divergenceRayInY.Direction;
    
    gaussianBeamRayBundle.Wavelength(:,1:5:5*nGaussian) = centralRay.Wavelength;
    gaussianBeamRayBundle.Wavelength(:,2:5:5*nGaussian) = waistRayInX.Wavelength;
    gaussianBeamRayBundle.Wavelength(:,3:5:5*nGaussian) = waistRayInY.Wavelength;
    gaussianBeamRayBundle.Wavelength(:,4:5:5*nGaussian) = divergenceRayInX.Wavelength;
    gaussianBeamRayBundle.Wavelength(:,5:5:5*nGaussian) = divergenceRayInY.Wavelength;
    
    gaussianBeamRayBundle.FixedParameters.TotalNumberOfPupilPoints = 5*nGaussian;
    gaussianBeamRayBundle.FixedParameters.TotalNumberOfFieldPoints = 1;
    gaussianBeamRayBundle.FixedParameters.TotalNumberOfWavelengths = 1;
end

