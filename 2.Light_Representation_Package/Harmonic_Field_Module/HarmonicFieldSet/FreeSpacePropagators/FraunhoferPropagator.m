function [ finalHarmonicField ] = FraunhoferPropagator( initialHarmonicField,...
        propagationDistance,outputWindowSize,addSphericalCorrection )
    %FRAUNHOFERPROPAGATOR computes the scalar (Ex far field diffraction pattern
    % using fft based fraunhofer integral
    
    finalHarmonicField = initialHarmonicField;
    
    nHarmonicFields = (initialHarmonicField.NumberOfHarmonicFields);
    [allEx,allxp,allyp] =  computeEx(initialHarmonicField);
    allEy =  computeEy(initialHarmonicField);
    allWavelength = initialHarmonicField.Wavelength;
    
    for kk = 1:nHarmonicFields
        efdx = allEx(:,:,1,kk);
        efdy = allEy(:,:,1,kk);
        xp = squeeze(allxp(:,:,kk)); 
        yp = squeeze(allyp(:,:,kk));
%         finalHarmonicField = initialHarmonicField(:,:,:,kk);
%         [efdx,xp,yp] = computeEx(finalHarmonicField);
%         [efdy] = computeEy(finalHarmonicField);
        
        % efd = initialHarmonicField.computeEx;
        npx = size(efdx,2);
        npy = size(efdx,1);
        
        dus = outputWindowSize/2; % size to see the result (radius)
        xs = linspace(-dus,dus,npx);
        ys = linspace(-dus,dus,npy);
        % ys = xs;
        z = propagationDistance ;
        wl = allWavelength(kk);
        
        if addSphericalCorrection
            % If input field is computed on an exit pupil sphere and not on plane
            % Add spherical phase correction as the existing diffraction code
            % assumes plane to plane propagation (the initial wavefront has
            % curvature = Z of propagation)
            [xpm,ypm] = meshgrid(xp,yp);
            rpm = sqrt(xpm.^2+ypm.^2);
            rcurv = z;
            efdx = efdx .* exp(-1i*pi/(wl*z)*(rpm.^2));
            efdy = efdy .* exp(-1i*pi/(wl*z)*(rpm.^2));
        end
        % The prop_fraun_fft function assumes size efd = Nx x Ny
        % But normally the efd computed above is Ny x Nx so transposing the
        % input and return of the function
        efdxs = (prop_fraun_fft(xp,yp,efdx',xs,ys,z,wl))';
        efdys = (prop_fraun_fft(xp,yp,efdy',xs,ys,z,wl))';
        
        dx_final = outputWindowSize/npx;
        dy_final = outputWindowSize/npy;
        
        finalHarmonicField.ComplexAmplitude(:,:,1) = efdxs;
        finalHarmonicField.ComplexAmplitude(:,:,2) = efdys;
        newComplexAmplitude = cat(3,permute(efdxs,[1,2,4,3]),permute(efdys,[1,2,4,3]));
        finalHarmonicField.ComplexAmplitude(:,:,:,kk) = newComplexAmplitude;
    end
    finalHarmonicField.SamplingDistance(1) = dx_final;
    finalHarmonicField.SamplingDistance(2) = dy_final;
end

