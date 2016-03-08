function [ returnDataStruct] = CircularObstruction(returnFlag,apertureParameters,inputDataStruct)
    %CircularObstruction  Defn of aperture with circular obstruction in the center.
    % (It is the complement of the circular aperture with the given inner(smaller)
    % and outer(lareger) diameter.)
    % apertureParameters = values of {'SmallDiameter','LargeDiameter'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Aperture specific 'UniqueApertureParameters' table field names
    % and initial values in Aperture Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the maximum radius in x and y axis
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.MaximumRadiusXY
    % 3: Determine weather the given xy points are inside the main(inner) aperture.
    %   inputDataStruct:
    %       inputDataStruct.xyVector
    %           NB. The xyVector should be given with respect to the center of the
    %           unrotated and undecentered aperture.
    %   Output Struct:
    %       returnDataStruct.IsInsideTheMainAperture
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 03,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input vaalues
    if nargin < 1
        disp(['Error: The function CircularObstruction() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 3
            disp(['Error: The function CircularObstruction() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 3
            disp(['Error: The function CircularObstruction() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end

    %%
    switch returnFlag(1)
        case 1 % Return the field names and initial values of apertureParameters
            returnData1 = {'SmallDiameter','LargeDiameter'};
            returnData1_Display = {'Small Diameter','Large Diameter'};
            returnData2 = {'numeric','numeric'};
            defaultApertureParameter = struct();
            defaultApertureParameter.SmallDiameter = 5;
            defaultApertureParameter.LargeDiameter = 10;
            returnData3 = defaultApertureParameter;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Display;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
            
        case 2 % Return the maximum radius in x and y axis
            maximumRadiusXY(1) = (apertureParameters.LargeDiameter)/2;
            maximumRadiusXY(2) = maximumRadiusXY(1);
            
            returnDataStruct.MaximumRadiusXY = maximumRadiusXY;
            
            
        case 3 % Return the if the given points in xyVector are inside or outside the aperture.
            xyVectorOrMesh = inputDataStruct.xyVector;
            if ndims(xyVectorOrMesh) == 3
                pointX = xyVectorOrMesh(:,:,1);
                pointY = xyVectorOrMesh(:,:,2);
            elseif ndims(xyVectorOrMesh) == 2
                pointX = xyVectorOrMesh(:,1);
                pointY = xyVectorOrMesh(:,2);
            end
            smallRadius = (apertureParameters.SmallDiameter)/2;
            largeRadius = (apertureParameters.LargeDiameter)/2;

            tol = 10^-15; % Avoids rays falsely flaged as out of aperture due to numerics
            umInsideTheMainAperture = ((((pointX).^2 + (pointY).^2)/largeRadius^2) >= 1-tol) |...
                ((((pointX).^2 + (pointY).^2)/smallRadius^2) <= 1+tol);
            returnDataStruct.IsInsideTheMainAperture = umInsideTheMainAperture;
    end
end

