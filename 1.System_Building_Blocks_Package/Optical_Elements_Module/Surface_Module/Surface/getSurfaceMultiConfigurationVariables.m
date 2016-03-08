function [ multiConfigurationVariables,multiConfigurationVariableFormats ] = ...
        getSurfaceMultiConfigurationVariables( surface )
    %getSurfaceMultiConfigurationVariables Summary of this function goes here
    %   Detailed explanation goes here
    [surfUniqueParameters,~,surfUniqueParameterFormats] = getSurfaceUniqueParameters(surface);
    if isempty(surfUniqueParameters{1})
        surfUniqueParameters = '';
    else
        for kk = 1:length(surfUniqueParameters)
            surfUniqueParameters{kk} = ['UniqueParameters.',surfUniqueParameters{kk}];
        end
    end
    % Surface Aperture
    surfAperture = surface.Aperture;
    [ apertureParameters,apertureParameterFormats ] = ...
        getSurfaceApertureMultiConfigurationVariables( surfAperture );
    if isempty(apertureParameters{1})
        apertureParameters = '';
    else
        for kk2 = 1:length(apertureParameters)
            apertureParameters{kk2} = ['Aperture.',apertureParameters{kk2}];
        end
    end
    
    % Grating
    grating = surface.Grating;
    [ gratingParameters,gratingParameterFormats ] = ...
        getGratingMultiConfigurationVariables( grating );
    if isempty(gratingParameters{1})
        gratingParameters = '';
    else
        for kk3 = 1:length(gratingParameters)
            gratingParameters{kk3} = ['Grating.',gratingParameters{kk3}];
        end
    end

    multiConfigurationVariables = [{'Thickness','Glass.Name','Coating.Name','Radius',...
        'Conic'},surfUniqueParameters,{'ExtraData'},apertureParameters,gratingParameters,...
        {'TiltDecenterOrder', 'Tilt','Decenter','TiltMode',...
        'StopSurfaceIndex','IsHidden','IsIgnored'}]; 
    multiConfigurationVariableFormats = [{'numeric','char','char','numeric',...
        'numeric'},surfUniqueParameterFormats,{'numeric'},apertureParameterFormats,gratingParameterFormats,...
        {'numeric', 'numeric','numeric','numeric',...
        'numeric','logical','logical'}]; 
end

