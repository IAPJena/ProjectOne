function [ harmonicField ] = computeFinalHarmonicField( rayTraceResult,initialHarmonicField,...
        effectsToInclude,lensUnitFactor,OPLRef )
    %convertToHarmonicField Converts ray data to harmonic field
    
    %
    N1 = size(rayTraceResult,1);
    N2 = size(rayTraceResult,2);
    harmonicField = initialHarmonicField;
    
    if effectsToInclude == 1 % OPL
        wavLen = initialHarmonicField.Wavelength;
        k0 = 2*pi./wavLen;
        OPLinMeter = reshape(([rayTraceResult.TotalOpticalPathLength]-OPLRef)*lensUnitFactor,N1,N2);
        
        % Replace the NaN (which come for rays outside aperture) with zeros
        OPLinMeter(isnan(OPLinMeter)) = 0;
        
        % GPLinMeter = reshape([rayTraceResult.TotalGroupPathLength]*lensUnitFactor,Nx,Ny);
        % OPLinMeter = GPLinMeter;
        phaseFactor = k0*OPLinMeter;
        initialEx = computeEx(harmonicField);
        finalEx = initialEx.*exp(1i*phaseFactor);
        rayIntersectionPoint = [rayTraceResult.ExitRayPosition]*lensUnitFactor;
        xMax = max(rayIntersectionPoint(1,:));
        xMin = min(rayIntersectionPoint(1,:));
        yMax = max(rayIntersectionPoint(2,:));
        yMin = min(rayIntersectionPoint(2,:));
        % new sampling distance
        dx = (xMax-xMin)/N1;
        dy = (yMax-yMin)/N2;
        harmonicField.SamplingDistance = [dx,dy];
        % The field shall be interpolated to new grid to include any grid
        % distortion effect. But now this is ignored
        harmonicField.ComplexAmplitude(:,:,1) = finalEx;
    else % OPL + Fresnels refraction/reflection
        disp('Error: Currently polarization is not supported.');
        harmonicField = [];
        return;
    end
    
end

