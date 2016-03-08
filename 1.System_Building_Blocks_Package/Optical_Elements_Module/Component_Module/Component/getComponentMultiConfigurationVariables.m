function [ multiConfigurationVariables ] = ...
        getComponentMultiConfigurationVariables( component )
    %getSurfaceMultiConfigurationVariables Summary of this function goes here
    %   Detailed explanation goes here
    uniqueParameters = getComponentUniqueParameters(component);
    
    if ~isempty(uniqueParameters{1})
        for kk = 1:length(uniqueParameters)
            uniqueParameters{kk} = ['UniqueParameters.',uniqueParameters{kk}];
        end
        multiConfigurationVariables = [{'LastThickness'},uniqueParameters,{'StopSurfaceIndex','FirstTiltDecenterOrder',...
            'FirstTilt','FirstDecenter','ComponentTiltMode'}];
    else
        multiConfigurationVariables = [{'LastThickness','StopSurfaceIndex','FirstTiltDecenterOrder',...
            'FirstTilt','FirstDecenter','ComponentTiltMode'}];
    end
end

