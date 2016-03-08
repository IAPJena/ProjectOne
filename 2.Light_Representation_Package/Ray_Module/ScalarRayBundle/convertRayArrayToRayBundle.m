function [ scalarRayBundle ] = convertRayArrayToRayBundle( scalarRayVector )
    %convertRayArrayToRayBundle Converts the array of scalar rays (vector
    %of scalr rays) to scalar ray bundle which is required for ray tracing
    %in the toolbox. A RayBundle is scalar structure with all members being
    %vector where as RayArray is vector of Rays where each element
    %indicates each ray. The later is not convienent for fast raytracing so
    %shall be converted to raybundle before ray tracing.
    
    
    scalarRayBundle = ScalarRayBundle;
    scalarRayBundle.Position = [scalarRayVector.Position];
    scalarRayBundle.Direction = [scalarRayVector.Direction];
    scalarRayBundle.Wavelength = [scalarRayVector.Wavelength];
    scalarRayBundle.ClassName = 'ScalarRayBundle';   
end

