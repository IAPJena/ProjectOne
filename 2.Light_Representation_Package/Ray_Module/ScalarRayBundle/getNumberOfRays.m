function [ nRays ] = getNumberOfRays( scalarRayBundle )
    %GETNUMBEROFRAYS Returns the number of rays in the scalar ray bundle
    
    nRays = length(scalarRayBundle.Wavelength);   
end

