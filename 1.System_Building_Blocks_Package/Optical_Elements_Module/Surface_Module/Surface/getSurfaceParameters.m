function [ paramNames,paramDisplayNames,paramTypes,paramValues,paramValuesDisp] = ...
        getSurfaceParameters(currentSurface,tableName,rowNumber)
    % getSurfaceParameters: returns the surface parameter
    % paramName,paramType,paramValue,paramValueDisp
    % tablename = 'Basic','TiltDecenter','Aperture'. If the rowNumber is
    % specified then the data for specific row will be returned.
    
    if nargin == 2
        rowNumber = 0; % Return all parameters
    end
    
    if  rowNumber == 0 % Return all parameters
        switch tableName
            case 'Basic'
                paramNames{1,1} = 'Thickness';
                paramDisplayNames{1,1} = 'Thickness';
                paramTypes{1,1} = 'numeric';
                paramValues{1,1} = currentSurface.Thickness;
                paramValuesDisp{1,1} = currentSurface.Thickness;
                
                paramNames{2,1} = 'Glass';
                paramDisplayNames{2,1} = 'Glass';
                paramTypes{2,1} = 'Glass';
                paramValues{2,1} = currentSurface.Glass;
                paramValuesDisp{2,1} = currentSurface.Glass.Name;
                
                paramNames{3,1} = 'Coating';
                paramDisplayNames{3,1} = 'Coating';
                paramTypes{3,1} = 'Coating';
                paramValues{3,1} = currentSurface.Coating;
                paramValuesDisp{3,1} = currentSurface.Coating.Name;
                
                paramNames{4,1} = 'Radius';
                paramDisplayNames{4,1} = 'Radius';
                paramTypes{4,1} = 'numeric';
                paramValues{4,1} = currentSurface.Radius;
                paramValuesDisp{4,1} = currentSurface.Radius;
                
                paramNames{5,1} = 'Conic';
                paramDisplayNames{5,1} = 'Conic';
                paramTypes{5,1} = 'numeric';
                paramValues{5,1} = currentSurface.Conic;
                paramValuesDisp{5,1} = currentSurface.Conic;
                
                % Add additional surface type specific basic parameters
                [ uniqueParamNames, uniqueParamDisplayNames,...
                    uniqueParamFormats, uniqueParametersStruct] = ...
                    getSurfaceUniqueParameters( currentSurface);
                nUniqueParams = length(uniqueParamNames);
                if nUniqueParams == 1 && isempty(uniqueParamNames{1})
                    return;
                end
                for kk = 1:nUniqueParams
                    paramNames{5+kk,1} = uniqueParamNames{kk};
                    paramDisplayNames{5+kk,1} = uniqueParamDisplayNames{kk};
                    paramTypes{5+kk,1} = uniqueParamFormats{kk};
                    paramValues{5+kk,1} = uniqueParametersStruct.(uniqueParamNames{kk});
                    
                    switch lower(paramTypes{5+kk,1})
                        case lower('logical')
                            if paramValues{5+kk,1}
                                paramValuesDisp{5+kk,1}  = '1';
                            else
                                paramValuesDisp{5+kk,1} = '0';
                            end
                        case lower('numericVector')
                            paramValuesDisp{5+kk,1} = ['Vector[',num2str(size(paramValues{5+kk,1},1)),']'];
                        otherwise
                            paramValuesDisp{5+kk,1}  = paramValues{5+kk,1};
                    end
                end
            case 'TiltDecenter'
                paramNames{1,1} = 'TiltX';
                paramDisplayNames{1,1} = 'Tilt in X';
                paramTypes{1,1} = 'numeric';
                paramValues{1,1} = currentSurface.Tilt(1);
                paramValuesDisp{1,1} = currentSurface.Tilt(1);
                
                paramNames{2,1} = 'TiltY';
                paramDisplayNames{2,1} = 'Tilt in Y';
                paramTypes{2,1} = 'numeric';
                paramValues{2,1} = currentSurface.Tilt(2);
                paramValuesDisp{2,1} = currentSurface.Tilt(2);
                
                paramNames{3,1} = 'TiltZ';
                paramDisplayNames{3,1} = 'Tilt in Z';
                paramTypes{3,1} = 'numeric';
                paramValues{3,1} = currentSurface.Tilt(3);
                paramValuesDisp{3,1} = currentSurface.Tilt(3);
                
                paramNames{4,1} = 'DecenterX';
                paramDisplayNames{4,1} = 'Decenter in X';
                paramTypes{4,1} = 'numeric';
                paramValues{4,1} = currentSurface.Decenter(1);
                paramValuesDisp{4,1} = currentSurface.Decenter(1);
                
                paramNames{5,1} = 'DecenterY';
                paramDisplayNames{5,1} = 'Decenter in Y';
                paramTypes{5,1} = 'numeric';
                paramValues{5,1} = currentSurface.Decenter(2);
                paramValuesDisp{5,1} = currentSurface.Decenter(2);
                
            case 'Aperture'
                currentAperture = currentSurface.Aperture;
                decX = currentAperture.Decenter(1);
                decY = currentAperture.Decenter(2);
                
                paramNames{1,1} = 'DecenterX';
                paramDisplayNames{1,1} = 'Decenter in X';
                paramTypes{1,1} = 'numeric';
                paramValues{1,1} = decX;
                paramValuesDisp{1,1} = decX;
                
                paramNames{2,1} = 'DecenterY';
                paramDisplayNames{2,1} = 'Decenter in Y';
                paramTypes{2,1} = 'numeric';
                paramValues{2,1} = decY;
                paramValuesDisp{2,1} = decY;
                
                rotation = currentAperture.Rotation;
                
                paramNames{3,1} = 'Rotation';
                paramDisplayNames{3,1} = 'Rotation (deg)';
                paramTypes{3,1} = 'numeric';
                paramValues{3,1} = rotation;
                paramValuesDisp{3,1} = rotation;
                
                % Add additional aperture type specific parameters
                [uniqueParamNames, uniqueParamFormats,uniqueParameterStruct,...
                    uniqueParamDisplayNames] = getApertureUniqueParameters( currentAperture );
                apertureUniqueParameters = currentAperture.UniqueParameters;
                nUniqueParams = length(uniqueParamNames);
                for kk = 1:nUniqueParams
                    paramNames{3+kk,1} = uniqueParamNames{kk};
                    paramDisplayNames{3+kk,1} = uniqueParamDisplayNames{kk};
                    paramTypes{3+kk,1} = uniqueParamFormats{kk};
                    paramValues{3+kk,1} = apertureUniqueParameters.(uniqueParamNames{kk});
                    switch lower(class(paramValues{3+kk,1}))
                        case lower('logical')
                            if paramValues{3+kk,1}
                                paramValuesDisp{3+kk,1}  = 'True';
                            else
                                paramValuesDisp{3+kk,1} = 'False';
                            end
                        otherwise
                            paramValuesDisp{3+kk,1}  = paramValues{3+kk,1};
                    end
                end
            case 'Grating'
                currentGrating = currentSurface.Grating;
                % Add additional aperture type specific parameters
                [uniqueParamNames, uniqueParamFormats,uniqueParameterStruct,...
                    uniqueParamDisplayNames] = getGratingUniqueParameters( currentGrating );
                gratingUniqueParameters = uniqueParameterStruct;
                nUniqueParams = length(uniqueParamNames);
                paramNames = cell(nUniqueParams,1);
                paramTypes = cell(nUniqueParams,1);
                paramValues = cell(nUniqueParams,1);
                paramValuesDisp = cell(nUniqueParams,1);
                for kk = 1:nUniqueParams
                    paramNames{kk,1} = uniqueParamNames{kk};
                    paramDisplayNames{kk,1} = uniqueParamDisplayNames{kk};
                    paramTypes{kk,1} = uniqueParamFormats{kk};
                    paramValues{kk,1} = gratingUniqueParameters.(uniqueParamNames{kk});
                    switch lower(class(paramValues{kk,1}))
                        case lower('logical')
                            if paramValues{kk,1}
                                paramValuesDisp{kk,1}  = 'True';
                            else
                                paramValuesDisp{kk,1} = 'False';
                            end
                        otherwise
                            paramValuesDisp{kk,1}  = paramValues{kk,1};
                    end
                end
        end
    else
        switch tableName
            case 'Basic'
                switch rowNumber
                    case 1
                        paramNames{1,1} = 'Thickness';
                        paramDisplayNames{1,1} = 'Thickness';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Thickness;
                        paramValuesDisp{1,1} = currentSurface.Thickness;
                    case 2
                        paramNames{1,1} = 'Glass';
                        paramDisplayNames{1,1} = 'Glass';
                        paramTypes{1,1} = 'Glass';
                        paramValues{1,1} = currentSurface.Glass;
                        paramValuesDisp{1,1} = currentSurface.Glass.Name;
                    case 3
                        paramNames{1,1} = 'Coating';
                        paramDisplayNames{1,1} = 'Coating';
                        paramTypes{1,1} = 'Coating';
                        paramValues{1,1} = currentSurface.Coating;
                        paramValuesDisp{1,1} = currentSurface.Coating.Name;
                    case 4
                        paramNames{1,1} = 'Radius';
                        paramDisplayNames{1,1} = 'Radius';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Radius;
                        paramValuesDisp{1,1} = currentSurface.Radius;
                    case 5
                        paramNames{1,1} = 'Conic';
                        paramDisplayNames{1,1} = 'Conic';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Conic;
                        paramValuesDisp{1,1} = currentSurface.Conic;    
                    otherwise
                        % Add additional surface type specific basic parameters
                        [ uniqueParamNames, uniqueParamDisplayNames,...
                            uniqueParamFormats, uniqueParametersStruct] = ...
                                getSurfaceUniqueParameters( currentSurface);
                        uniqueParamIndex = rowNumber-5;
                        paramNames{1,1} = uniqueParamNames{uniqueParamIndex};
                        paramDisplayNames{1,1} = uniqueParamDisplayNames{uniqueParamIndex};
                        paramTypes{1,1} = uniqueParamFormats{uniqueParamIndex};
                        paramValues{1,1} = uniqueParametersStruct.(uniqueParamNames{uniqueParamIndex});
                        switch lower(class(paramValues{1,1}))
                            case lower('logical')
                                if paramValues{1,1}
                                    paramValuesDisp{1,1}  = '1';
                                else
                                    paramValuesDisp{1,1} = '0';
                                end
                            case lower('numericVector')    
                                paramValuesDisp{1,1} = paramValues{1,1};
                            otherwise
                                paramValuesDisp{1,1}  = paramValues{1,1};
                        end
                end
            case 'TiltDecenter'
                switch rowNumber
                    case 1
                        paramNames{1,1} = 'TiltX';
                        paramDisplayNames{1,1} = 'Tilt in X';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Tilt(1);
                        paramValuesDisp{1,1} = currentSurface.Tilt(1);
                    case 2
                        paramNames{1,1} = 'TiltY';
                        paramDisplayNames{1,1} = 'Tilt in Y';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Tilt(2);
                        paramValuesDisp{1,1} = currentSurface.Tilt(2);
                    case 3
                        paramNames{1,1} = 'TiltZ';
                        paramDisplayNames{1,1} = 'Tilt in Z';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Tilt(2);
                        paramValuesDisp{1,1} = currentSurface.Tilt(2);
                    case 4
                        paramNames{1,1} = 'DecenterX';
                        paramDisplayNames{1,1} = 'Decenter in X';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Decenter(1);
                        paramValuesDisp{1,1} = currentSurface.Decenter(1);
                    case 5
                        paramNames{1,1} = 'DecenterY';
                        paramDisplayNames{1,1} = 'Decenter in Y';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = currentSurface.Decenter(2);
                        paramValuesDisp{1,1} = currentSurface.Decenter(2);
                    otherwise
                end
            case 'Aperture'
                currentAperture = currentSurface.Aperture;
                switch rowNumber
                    case 1
                        decX = currentAperture.Decenter(1);
                        paramNames{1,1} = 'DecenterX';
                        paramDisplayNames{1,1} = 'Decenter in X';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = decX;
                        paramValuesDisp{1,1} = decX;
                    case 2
                        decY = currentAperture.Decenter(2);
                        paramNames{1,1} = 'DecenterY';
                        paramDisplayNames{1,1} = 'Decenter in Y';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = decY;
                        paramValuesDisp{1,1} = decY;
                    case 3
                        rotation = currentAperture.Rotation;
                        paramNames{1,1} = 'Rotation';
                        paramDisplayNames{1,1} = 'Rotation (deg)';
                        paramTypes{1,1} = 'numeric';
                        paramValues{1,1} = rotation;
                        paramValuesDisp{1,1} = rotation;
                    otherwise
                        % Add additional aperture type specific parameters
                        [uniqueParamNames, uniqueParamFormats,uniqueParameterStruct,...
                            uniqueParamDisplayNames] = getApertureUniqueParameters( currentAperture );
                        apertureUniqueParameters = currentAperture.UniqueParameters;
                        uniqueParamIndex = rowNumber-3;
                        paramNames{1,1} = uniqueParamNames{uniqueParamIndex};
                        paramDisplayNames{1,1} = uniqueParamDisplayNames{uniqueParamIndex};
                        paramTypes{1,1} = uniqueParamFormats{uniqueParamIndex};
                        paramValues{1,1} = apertureUniqueParameters.(uniqueParamNames{uniqueParamIndex});
                        switch lower(class(paramValues{1,1}))
                            case lower('logical')
                                if paramValues{1,1}
                                    paramValuesDisp{1,1}  = '1';
                                else
                                    paramValuesDisp{1,1} = '0';
                                end
                            otherwise
                                paramValuesDisp{1,1}  = paramValues{1,1};
                        end
                end
            case 'Grating'
                currentGrating = currentSurface.Grating;
                % Add additional aperture type specific parameters
                [uniqueParamNames, uniqueParamFormats,uniqueParameterStruct,...
                    uniqueParamDisplayNames] = getGratingUniqueParameters( currentGrating );
                
                gratingUniqueParameters = uniqueParameterStruct;
                
                paramNames{1,1} = uniqueParamNames{1};
                paramDisplayNames{1,1} = uniqueParamDisplayNames{1};
                paramTypes{1,1} = uniqueParamFormats{1};
                paramValues{1,1} = gratingUniqueParameters.(uniqueParamNames{1});
                
                switch lower(class(paramValues{1,1}))
                    case lower('logical')
                        if paramValues{1,1}
                            paramValuesDisp{1,1}  = 'True';
                        else
                            paramValuesDisp{1,1} = 'False';
                        end
                    otherwise
                        paramValuesDisp{1,1}  = paramValues{1,1};
                end
        end
    end
end

