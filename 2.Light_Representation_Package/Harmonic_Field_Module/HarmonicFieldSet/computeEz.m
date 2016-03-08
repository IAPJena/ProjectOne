function [Ez,xlin,ylin] = computeEz(harmonicFieldSet,selectedFieldIndex)
    % Use the equation Ez = -IFFT{(1/Kz)*[Kx*FFT{Ex} + Ky*FFT{Ey}]}
    % From VirtualLab Documentation
    if nargin < 1
        harmonicFieldSet = HarmonicFieldSet;
    end
    if nargin < 2
        selectedFieldIndex = 0;
    end
    
    [ harmonicFieldSetIn2ndDomain] = computeFieldFFT(harmonicFieldSet);
    % All fields are in K domain
    ExInk = squeeze(harmonicFieldSetIn2ndDomain.ComplexAmplitude(:,:,1,:)); % 3rd dim for different fields in the set
    EyInk = squeeze(harmonicFieldSetIn2ndDomain.ComplexAmplitude(:,:,2,:)); % 3rd dim for different fields in the set
    nx = size(EyInk,2);
    ny = size(EyInk,1);
    samplingPoints = [nx;ny];
    samplingDistance = harmonicFieldSetIn2ndDomain.SamplingDistance;
    centerXY = harmonicFieldSetIn2ndDomain.Center;
    [kxlin,kylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);
    
    % Now multiply the Ex and Ey with corresponding Kx and Ky
    nFields = harmonicFieldSetIn2ndDomain.NumberOfHarmonicFields;
    deltaIn2ndDomain = harmonicFieldSetIn2ndDomain.SamplingDistance;
    wavelength = harmonicFieldSetIn2ndDomain.Wavelength;
    
    samplingDistanceNew = zeros(2,nFields);
    if selectedFieldIndex
        Ez = zeros(ny,nx,1);
        [Kx,Ky] = meshgrid(kxlin(:,:,selectedFieldIndex),kylin(:,:,selectedFieldIndex));
        Kz = sqrt((2*pi/wavelength(selectedFieldIndex)).^2 - Kx.^2 - Ky.^2);
        complexEzInK = (Kx.*ExInk(:,:,selectedFieldIndex) + Ky.*EyInk(:,:,selectedFieldIndex))./Kz;
        [ EinIn1stDomain,deltaIn1stDomain ] = computeIFFT2( complexEzInK,deltaIn2ndDomain(:,selectedFieldIndex) );
        Ez(:,:) = -EinIn1stDomain;
        samplingDistanceNew = deltaIn1stDomain;
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistanceNew, centerXY(:,selectedFieldIndex));
    else
        Ez = zeros(ny,nx,nFields);
        % Do it for all fields in the set
        for ff = 1:nFields
            [Kx,Ky] = meshgrid(kxlin(:,:,ff),kylin(:,:,ff));
            Kz = sqrt((2*pi/wavelength(ff)).^2 - Kx.^2 - Ky.^2);
            complexEzInK = (Kx.*ExInk(:,:,ff) + Ky.*EyInk(:,:,ff))./Kz;
            [ EinIn1stDomain,deltaIn1stDomain ] = computeIFFT2( complexEzInK,deltaIn2ndDomain(:,ff) );
            Ez(:,:,ff) = -EinIn1stDomain;
            samplingDistanceNew(:,ff) = deltaIn1stDomain;
        end
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistanceNew, centerXY);
    end
end

