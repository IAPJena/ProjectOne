function [ returnDataStruct] = Grating1D( ...
        returnFlag,componentParameters,inputDataStruct)
    %Grating1D : Component defining a simple 1 dimensional grating
    % componentParameters = values of {'Glass','LineDensity','DiffractionOrder','LengthX','LengthY'}
    % inputDataStruct : Struct of all additional inputs (not included in the component parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: About the component
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.Name
    %       returnDataStruct.ImageFullFileName
    %       returnDataStruct.Description
    % 2: Component specific 'UniqueParametersStruct' table field names and
    %    initial values in Surface Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 3: Component 'Extra Data' parameters
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueExtraDataFieldNames
    %       returnDataStruct.DefaultUniqueExtraData
    % 4: The surface array of the component
    %   inputDataStruct:
    %       inputDataStruct.FirstTilt
    %       inputDataStruct.FirstDecenter
    %       inputDataStruct.FirstTiltDecenterOrder
    %       inputDataStruct.LastThickness
    %       inputDataStruct.ComponentTiltMode
    %   Output Struct:
    %       returnDataStruct.SurfaceArray
    
    %% Default input values
    if nargin < 1
        disp('Error: The function Grating1D() needs atleat the return type.');
        returnDataStruct = NaN;
        return;
    end
    
    if returnFlag == 4
        if nargin < 2
            % take the defualt componentparameters
            returnFlag = 2;
            [returnDataStruct] = Grating1D(returnFlag);
            componentParameters = returnDataStruct.DefaultUniqueParametersStruct;
        end
        if nargin < 3
            inputDataStruct.FirstTilt = [0,0,0];
            inputDataStruct.FirstDecenter = [0,0];
            inputDataStruct.FirstTiltDecenterOrder  = {'Dx','Dy','Dz','Tx','Ty','Tz'};
            inputDataStruct.LastThickness = 10;
            inputDataStruct.ComponentTiltMode = 'NAX';
        end
    end
    
    %%
    switch returnFlag(1)
        case 1 % About  component
            returnData1 = {'Grating1D'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            returnData2 = {[pathstr,'\Grating1D.jpg']};  % Image file name
            returnData3 = {['Grating1D: Is a one dimensional grating on a plane',...
                ' surface. If the glass after the grating is set to MIRROR then',...
                ' the grating is used in reflective mode and otherwise it is used',...
                ' in refractive mode. The grating is defined by the grating line',...
                ' density (lines/um) and diffraction order.']};  % Text description
            
            returnDataStruct.Name = returnData1;
            returnDataStruct.ImageFullFileName = returnData2;
            returnDataStruct.Description = returnData3;
        case 2 % 'UniqueParameterStruct' table field names and initial values in COmponent Editor GUI
            defaultCompUniqueStruct = struct();
            defaultCompUniqueStruct.Glass = Glass('');
            defaultCompUniqueStruct.LineDensity = 100;
            defaultCompUniqueStruct.DiffractionOrder = 1;
            defaultCompUniqueStruct.LengthX = 20;
            defaultCompUniqueStruct.LengthY = 20;
            
            
            returnDataStruct.UniqueParametersStructFieldNames = {'Glass','LineDensity','DiffractionOrder','LengthX','LengthY'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldDisplayNames = {'Glass','LineDensity','DiffractionOrder','Width in X','Width in Y'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldFormats = {'Glass','numeric','numeric','numeric','numeric'}; % parameter types
            returnDataStruct.DefaultUniqueParametersStruct= defaultCompUniqueStruct; % default value
            
        case 3 % 'Extra Data' table field names and initial values in Component Editor GUI
            returnDataStruct.UniqueExtraDataFieldNames = {'Unused'};
            returnDataStruct.DefaultUniqueExtraData = {[0]};
        case 4 % return the surface array of the compont
            firstTilt = inputDataStruct.FirstTilt;
            firstDecenter = inputDataStruct.FirstDecenter;
            firstTiltDecenterOrder = inputDataStruct.FirstTiltDecenterOrder;
            lastThickness = inputDataStruct.LastThickness;
            compTiltMode = inputDataStruct.ComponentTiltMode;
            referenceCoordinateTM = inputDataStruct.ReferenceCoordinateTM;
            previousThickness = inputDataStruct.PreviousThickness;
            surfaceArray = computeGrating1DSurfaceArray(componentParameters,...
                firstTilt,firstDecenter,firstTiltDecenterOrder,lastThickness,...
                compTiltMode,referenceCoordinateTM,previousThickness); % surface array
            
            returnDataStruct.SurfaceArray = surfaceArray; % surface array
    end
end


function surfArray = computeGrating1DSurfaceArray(componentParameters,...
        firstTilt,firstDecenter,firstTiltDecenterOrder,lastThickness,...
        compTiltMode,referenceCoordinateTM,previousThickness)
    tempSurfaceArray = Surface;
    tempSurfaceArray(1).Tilt = firstTilt;
    tempSurfaceArray(1).Decenter = firstDecenter;
    tempSurfaceArray(1).TiltDecenterOrder = firstTiltDecenterOrder;
    tempSurfaceArray(end).Thickness = lastThickness;
    tempSurfaceArray(end).TiltMode = compTiltMode;
    
    tempSurfaceArray(1).TiltMode = compTiltMode;
    
    % Tilt and decenter
    currentSurface = tempSurfaceArray(1);
    [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
        currentSurface,referenceCoordinateTM,previousThickness);
    % set surface property
    currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
    currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
    tempSurfaceArray(1) = currentSurface;
    
    type = 'RectangularAperture';
    apertDecenter = [0,0];
    apertRotInDeg = 0;
    drawAbsolute = 0;
    outerShape = 'Rectangular';
    additionalEdge = 0;
    uniqueParameters = struct();
    uniqueParameters.DiameterX = componentParameters.LengthX;
    uniqueParameters.DiameterY = componentParameters.LengthY;
    
    tempSurfaceArray(1).Aperture = Aperture(type,apertDecenter,apertRotInDeg,...
        drawAbsolute,outerShape,additionalEdge,uniqueParameters);
    tempSurfaceArray(1).Glass = componentParameters.Glass;
    tempSurfaceArray(1).Thickness = lastThickness;
    
    tempSurfaceArray(1).UniqueParameters.GratingLineDensity = ...
        componentParameters.LineDensity;
    tempSurfaceArray(1).UniqueParameters.DiffractionOrder = ...
        componentParameters.DiffractionOrder;
    
    surfArray = tempSurfaceArray;
end