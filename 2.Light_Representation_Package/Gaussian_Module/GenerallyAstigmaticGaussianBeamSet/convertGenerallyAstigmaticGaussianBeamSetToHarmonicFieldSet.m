function [ newHarmonicFieldSet ] = convertGenerallyAstigmaticGaussianBeamSetToHarmonicFieldSet( ...
        generallyAstigmaticGaussianBeamSet,Nx,Ny,windowSizeX,windowSizeY,coherentSuperposition )
    %CONVERTGENERALLYASTIGMATICGAUSSIANTOHARMONICFIELD Assume the gaussian
    %beam parameters are all given on the plane perpendicular to the
    %central ray.
    
    if nargin < 5
        disp(['Error: The function convertGenerallyAstigmaticGaussianBeamToHarmonicField',...
            'requires atleast 5 input arguments, generallyAstigmaticGaussianBeamSet,Nx,Ny,',...
            'windowSizeX and windowSizeY.']);
        newHarmonicFieldSet = NaN;
        return;
    end
    if nargin < 6
        coherentSuperposition = 0;
    end
    
    totalOpticalPathLength = generallyAstigmaticGaussianBeamSet.TotalOpticalPathLength;
    wavelen = generallyAstigmaticGaussianBeamSet.Wavelength;
    centralRayPosition = generallyAstigmaticGaussianBeamSet.CentralRayPosition;
    centralRayDirection = generallyAstigmaticGaussianBeamSet.CentralRayDirection;
    domain = 1;% 1 for Spatial domain, and 2 for spatial frequency
    sampDistX = windowSizeX/(Nx-1);
    sampDistY = windowSizeY/(Ny-1);
    xlin = linspace(-0.5*windowSizeX,0.5*windowSizeX,Nx);
    ylin = linspace(-0.5*windowSizeY,0.5*windowSizeY,Ny);
    [X,Y] = meshgrid(xlin,ylin);
    
    % Use the vectorial formula given in the
    % Vector Formulation Of The Ray-Equivalent Method For General Gaussian Beam Propagation
    % Author(s): Alan W Greynolds
    % Date Published: 19 December 1986
    complexRay1Position = generallyAstigmaticGaussianBeamSet.ComplexRay1Position;
    complexRay2Position = generallyAstigmaticGaussianBeamSet.ComplexRay2Position;
    complexRay1Direction = generallyAstigmaticGaussianBeamSet.ComplexRay1Direction;
    complexRay2Direction = generallyAstigmaticGaussianBeamSet.ComplexRay2Direction;
    
    p1x = complexRay1Position(1,:) - centralRayPosition(1,:);
    p1y = complexRay1Position(2,:) - centralRayPosition(2,:);
    p2x = complexRay2Position(1,:) - centralRayPosition(1,:);
    p2y = complexRay2Position(2,:) - centralRayPosition(2,:);
    
    complexRay1Direction_projected = complexRay1Direction-...
        (ones(3,1)*(dot(complexRay1Direction,centralRayDirection))).*centralRayDirection;
    complexRay2Direction_projected = complexRay2Direction-...
        (ones(3,1)*(dot(complexRay2Direction,centralRayDirection))).*centralRayDirection;
    
    d1x = complexRay1Direction_projected(1,:)./(sqrt(sum((abs(complexRay1Direction_projected)).^2)));
    d1y = complexRay1Direction_projected(2,:)./(sqrt(sum((abs(complexRay1Direction_projected)).^2)));
    d2x = complexRay2Direction_projected(1,:)./(sqrt(sum((abs(complexRay2Direction_projected)).^2)));
    d2y = complexRay2Direction_projected(2,:)./(sqrt(sum((abs(complexRay2Direction_projected)).^2)));
    
    % Now loop over each gaussian beam paramter and covert to complex
    % field
    
    nGaussian = length(p1x);
    E00 = 1;
    waveNumber = 2*pi./wavelen;
    centralRayPhase = exp(-1i*totalOpticalPathLength.*(2*pi./wavelen));
    Ex = 0*X;
    Ey = Ex;
    
    for kk = 1:nGaussian
        p1_cross_p2 = p1x(kk)*p2y(kk)-p1y(kk)*p2x(kk);
        p1_cross_r = p1x(kk)*Y-p1y(kk)*X;
        p2_cross_r = p2x(kk)*Y-p2y(kk)*X;
        d1_dot_r = d1x(kk)*X + d1y(kk)*Y;
        d2_dot_r = d2x(kk)*X + d2y(kk)*Y;
        k = waveNumber(kk);
        ampCoeff =(E00/sqrt(p1_cross_p2));
        % In the litrature it is just imaginary but for my test of free
        % space propagation, the real value gives good result.
        ampCoeff = abs(ampCoeff);
        additionalPhase = centralRayPhase(kk);
        Ex(:,:,kk) = additionalPhase*ampCoeff*exp(-1i*k*((p1_cross_r.*d2_dot_r - p2_cross_r.*d1_dot_r)/(2*p1_cross_p2)));
        Ey(:,:,kk) = Ex(:,:,kk)*0;
    end
    if coherentSuperposition
        % Check if the fields can be superposed coherently??
        % Should have the same wavelength, sampling parameters and central
        % ray
        
        % Add the complex amplitudes and then take all other parameters
        % from the first field
        Ex = sum(Ex,3);
        Ey = sum(Ey,3);
        sampDistX = sampDistX(:,1);
        sampDistY = sampDistY(:,1);
        wavelen = wavelen(:,1);
        centralRayPosition = centralRayPosition(:,1);
        centralRayDirection = centralRayDirection(:,1);
        domain = domain(:,1);
    end
    
    newHarmonicFieldSet = HarmonicFieldSet(Ex,Ey,sampDistX,sampDistY,wavelen,...
        centralRayPosition(1:2,:),centralRayDirection,domain);
end

