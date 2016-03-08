function [ outputGaussianBeamArray ] = gaussianBeamTracerTester2( optSystem,initialGaussianBeamParameters)
    %gaussianBeamTracerTester2 Traces gaussian beam from start surface to end surface
    % and returns the output gaussian beam for last surface using the gaussianbeamtracer function.
    % initialGaussianBeamParameters = [waistX,waistY,distanceFromWaist,fieldIndex,wavelngthIndex]
    % All in lens unit
    
    lensUnitFactor = getLensUnitFactor(optSystem);
    wavelengthUnitFactor = getWavelengthUnitFactor(optSystem);
    if nargin == 0
        disp('Error: The function gaussianBeamTracer needs atleast the optical system object.');
        outputGaussianBeamArray = NaN;
        return
    elseif nargin == 1
        % defaults gaussian: waist size of 0.05 lens units and
        % surface 1 to waist distance of zero; Field index = 1; wavlength index
        % = 1;
        
        %fieldIndex = 3;
        fieldIndex = 1;
        wavelengthIndex = 2;
        
        % For gaussian the waist should be atleast 3 * the wavelength, lets
        % take 10*wavelength
        %         wavelength = getSystemWavelength(optSystem,wavelengthIndex)*wavelengthUnitFactor;
        %         waistX = wavelength*1000 ;
        %         waistY = wavelength*1000 ;
        
        % Lets take 1 mm by 1 mm gaussian
        waistX = 10^-3;
        waistY = 3*10^-3;
        distanceFromWaist = 0*lensUnitFactor;
        
        initialGaussianBeamParameters = [waistX,waistY,distanceFromWaist,fieldIndex,wavelengthIndex];
    elseif nargin == 2
    else
    end
    
    [ NonDummySurfaceArray,nNonDummySurface,NonDummySurfaceIndices,...
        surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem );
    
    startSurface = 1;
    endSurface = nSurface;
    
    surfIndicesAfterStartSurface = find(NonDummySurfaceIndices>=startSurface);
    startNonDummyIndex = surfIndicesAfterStartSurface(1);
    surfIndicesBeforeEndSurface = find(NonDummySurfaceIndices<=endSurface);
    endNonDummyIndex = surfIndicesBeforeEndSurface(end);
    
    if NonDummySurfaceArray(1).Thickness > 10^10
        objectThickness = 0;
    else
        objectThickness = NonDummySurfaceArray(1).Thickness*lensUnitFactor;
    end
    
    waistX = initialGaussianBeamParameters(1);
    waistY = initialGaussianBeamParameters(2);
    distanceFromWaist = initialGaussianBeamParameters(3);
    
    % Compute the central ray from field and wavelength indices so that it can
    % be used in all following analysis
    fieldIndex = initialGaussianBeamParameters(4);
    wavelengthIndex = initialGaussianBeamParameters(5);
    
    switch (optSystem.FieldType)
        case 1 % lower('ObjectHeight')
            % Convert the values from lens unit to meter
            fieldPointXYInSI =((optSystem.FieldPointMatrix(fieldIndex,1:2))')*...
                lensUnitFactor;
        case 2 % lower('Angle')
            % Leave in degrees
            fieldPointXYInSI = ((optSystem.FieldPointMatrix(fieldIndex,1:2))');
    end
    wavLenInM = optSystem.WavelengthMatrix(wavelengthIndex,1)*...
        getWavelengthUnitFactor(optSystem);
    cheifRay = getChiefRay(optSystem,fieldPointXYInSI,wavLenInM );
    
    % Define the initial gaussian beam just before the start surface
    initialGaussianBeamSet = ScalarGaussianBeamSet();
    centralRay = cheifRay;
    
    initialGaussianBeamSet.CentralRayPosition = [centralRay.Position,centralRay.Position];
    initialGaussianBeamSet.CentralRayDirection = [centralRay.Direction,centralRay.Direction];
    initialGaussianBeamSet.CentralRayWavelength = [centralRay.Wavelength,centralRay.Wavelength];
    initialGaussianBeamSet.WaistRadiusInX = [waistX,4*waistX];
    initialGaussianBeamSet.WaistRadiusInY = [waistY,waistY];
    initialGaussianBeamSet.DistanceFromWaistInX = [distanceFromWaist,distanceFromWaist];
    initialGaussianBeamSet.DistanceFromWaistInY = [distanceFromWaist,distanceFromWaist];
    initialGaussianBeamSet.LocalXDirection = [[1,0,0]',[1,0,0]'];
    initialGaussianBeamSet.LocalYDirection = [[0,1,0]',[0,1,0]'];
    initialGaussianBeamSet.PeakAmplitude = [1,1];
    initialGaussianBeamSet.nGaussian = 2;
    
    [ outputGaussianBeamArray ] = gaussianBeamTracer( optSystem,initialGaussianBeamSet);

    % Plot results
    
    
end

