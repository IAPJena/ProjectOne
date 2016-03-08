function [ powCoeff ] = convertAmplitudeToPowerCoefficients( ampCoeff,reflection,lambda,incAngle,n_s,n_c )
    %CONVERTAMPLITUDETOPOWERCOEFFICIENTS Converts the amplitude
    %coefficients (transmission/reflection) to power coefficient based on
    %given incidence angle, clading and substrate index at given wavelength
    
    if reflection
        powCoeff = (abs(ampCoeff)).^2;
    else
        epsilon_c = (n_c).^2;
        epsilon_s = (n_s).^2;
        
        % K vector in substrate
        ks = (2*pi./lambda).*n_s;
        ksx = ks.*sin((incAngle));
        
        % x component of K vector is the same for all layer
        kx=ksx;
        
        % Z components of K vector in substrate and cladding
        ksz = sqrt((2*pi./lambda).^2.*epsilon_s - (kx).^2);
        kcz = sqrt((2*pi./lambda).^2.*epsilon_c - (kx).^2);
        
        powCoeff = (real(kcz).*(abs(ampCoeff)).^2)./(real(ksz));
    end
end

