function [ maxApertureRadius ] = getMaximumApertureRadius( surfAperture )
    %GETMINIMUMAPERTURERADIUS Returns the minimum radius of aperture which
    %is used to compute the stop surface of the system.
    
    % As it is difficult to compute the minimum radius of different aperture 
    % shapes, i just used the minimum of the outer radius 
    [outerApertShape,maximumRadiusXY] = getOuterAperture( surfAperture );
    maxApertureRadius = max(maximumRadiusXY); 
end

