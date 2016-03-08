function [ multiConfigurationVariables ] = ...
        getOpticalElementMultiConfigurationVariables( opticalElement )
    %getOpticalElementMultiConfigurationVariables Summary of this function goes here
    %   Detailed explanation goes here
    if isSurface(opticalElement)
        [ multiConfigurationVariables ] = ...
            getSurfaceMultiConfigurationVariables( opticalElement );
    elseif isComponent(opticalElement)
        [ multiConfigurationVariables ] = ...
            getComponentMultiConfigurationVariables( opticalElement );
    else
    end
end

