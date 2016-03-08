function [ multiConfigurationVariables,multiConfigurationVariableFormats ] = ...
        getSurfaceApertureMultiConfigurationVariables( surfAperture )
    %GETSURFACEAPERTUREMULTICONFIGURATIONVARIABLES Summary of this function goes here
    %   Detailed explanation goes here
    [uniqueParameters,uniqueParameterFormats] = getApertureUniqueParameters(surfAperture);
    if ~isempty(uniqueParameters{1})
        for kk = 1:length(uniqueParameters)
            uniqueParameters{kk} = ['UniqueParameters.',uniqueParameters{kk}];
        end
        multiConfigurationVariables = [{'Decenter', 'Rotation','DrawAbsolute',...
            'OuterShape','AdditionalEdge','AdditionalEdgeType'},uniqueParameters];
        multiConfigurationVariableFormats = [{'numeric', 'numeric','logical',...
            'numeric','numeric','numeric'},uniqueParameterFormats];
    else
        multiConfigurationVariables = [{'Decenter', 'Rotation','DrawAbsolute',...
            'OuterShape','AdditionalEdge','AdditionalEdgeType'}];
        multiConfigurationVariableFormats = [{'numeric', 'numeric','logical',...
            'numeric','numeric','numeric'}];
    end
end

