function [ multiConfigurationVariables,multiConfigurationVariableFormats ] = ...
        getGratingMultiConfigurationVariables( surfGrating )
    %getGratingsMultiConfigurationVariables Summary of this function goes here
    %   Detailed explanation goes here
    [uniqueParameters,uniqueParameterFormats] = getGratingUniqueParameters(surfGrating);
    if ~isempty(uniqueParameters{1})
        for kk = 1:length(uniqueParameters)
            uniqueParameters{kk} = ['UniqueParameters.',uniqueParameters{kk}];
        end
        multiConfigurationVariables = [{'DiffractionOrder'},uniqueParameters];
        multiConfigurationVariableFormats = [{'numeric'},uniqueParameterFormats];
    else
        multiConfigurationVariables = [{'DiffractionOrder'}];
        multiConfigurationVariableFormats = [{'numeric'}];
    end
end

