function [ outHarmonicFieldSet ] = getHFSourceHarmonicFieldSet( harmonicFieldSource )
    %GETHARMONICFIELDSET Summary of this function goes here
    %   Detailed explanation goes here
    
    [ sampDistX,sampDistY ] = getHFSourceSamplingDistance( harmonicFieldSource);
    [ intensityVect, wavelengthVect, referenceWavelengthIndex ] = ...
        getHFSourcePowerSpectrumProfile( harmonicFieldSource );
    [ U_xyTot,xlinTot,ylinTot] = getHFSourceSpatialProfile( harmonicFieldSource );
    [ matrixOfJonesVector ] = getHFSourcePolarizationProfile( harmonicFieldSource );

    center = harmonicFieldSource.LateralPosition;
    direction = getHFSourcePrincipalDirection(harmonicFieldSource);
    % Construct array of harmonic fields
    nSpectralMode = length(wavelengthVect);
    nSpatialMode = size(U_xyTot,3);
    wavelen = (wavelengthVect(:))';
    Ex = zeros([size(U_xyTot,1),size(U_xyTot,2),nSpectralMode*nSpatialMode]);
    Ey = Ex;
    
    
    for spect = 1:nSpectralMode
        % For each spectral mode compute all the spatial modes
        for spat = 1:nSpatialMode
            fieldIndex = (spect-1)*nSpatialMode + spat;
            Ex(:,:,fieldIndex) = sqrt(intensityVect(spect))*matrixOfJonesVector(:,:,1).*U_xyTot(:,:,spat);
            Ey(:,:,fieldIndex) = sqrt(intensityVect(spect))*matrixOfJonesVector(:,:,2).*U_xyTot(:,:,spat);
        end
    end
    wavelenAll = repmat(wavelen,[nSpatialMode,1]);
    wavelenAll = (wavelenAll(:))';
    refIndex = referenceWavelengthIndex;
    domain = 1; % Spatial domain
    outHarmonicFieldSet = HarmonicFieldSet(Ex,Ey,sampDistX,sampDistY,wavelenAll,center,direction,domain,refIndex);
end
