function [ returnDataStruct] = OBJECT( ...
        returnFlag,componentParameters,inputDataStruct)
    %OBJECT : COmponent for object surfaces
    % componentParameters = values of {'Unused'}
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
        disp('Error: The function OBJECT() needs atleat the return type.');
        returnDataStruct = NaN;
        return;
    end
    
    if returnFlag == 4
        if nargin < 2
            % take the defualt componentparameters
            returnFlag = 2;
            [returnDataStruct] = OBJECT(returnFlag);
            componentParameters = returnDataStruct.DefaultUniqueParametersStruct;
        end
        if nargin < 3
            inputDataStruct.FirstTilt = [0,0,0];
            inputDataStruct.FirstDecenter = [0,0];
            inputDataStruct.FirstTiltDecenterOrder  = 1;%{'Dx','Dy','Dz','Tx','Ty','Tz'};
            inputDataStruct.LastThickness = 10;
            inputDataStruct.ComponentTiltMode = 1;%'NAX';
        end
    end
    %%
    switch returnFlag(1)
        case 1 % About  component
            returnData1 = {'OBJECT'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            returnData2 = {[pathstr,'\OBJECT.jpg']};  % Image file name
            returnData3 = {['Object surface: is a plane sequence.']};  % Text description
            
            returnDataStruct.Name = returnData1;
            returnDataStruct.ImageFullFileName = returnData2;
            returnDataStruct.Description = returnData3;
        case 2 % 'BasicComponentDataFields' table field names and initial values in COmponent Editor GUI
            defaultCompUniqueStruct = struct();
            defaultCompUniqueStruct.Unused = 0;
            returnDataStruct.UniqueParametersStructFieldNames = {'Unused'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldDisplayNames = {'Unused'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldFormats = {'numeric'}; % parameter types
            returnDataStruct.DefaultUniqueParametersStruct= defaultCompUniqueStruct; % default value
        case 3 % 'Extra Data' table field names and initial values in Component Editor GUI
            returnDataStruct.UniqueExtraDataFieldNames = {'Unused'};
            returnDataStruct.DefaultUniqueExtraData = {[0]};
        case 4 % return the surface array of the compont
            surfaceArray = Surface;
            surfaceArray(1).Tilt = inputDataStruct.FirstTilt;
            surfaceArray(1).Decenter = inputDataStruct.FirstDecenter;
            surfaceArray(1).TiltDecenterOrder = inputDataStruct.FirstTiltDecenterOrder;
            surfaceArray(end).Thickness = inputDataStruct.LastThickness;
            surfaceArray(end).TiltMode = inputDataStruct.ComponentTiltMode;
            
            referenceCoordinateTM = inputDataStruct.ReferenceCoordinateTM;
            previousThickness = inputDataStruct.PreviousThickness;
            % Tilt and decenter
            currentSurface = surfaceArray(1);
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
                currentSurface,referenceCoordinateTM,previousThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            surfaceArray(1) = currentSurface;
            
%             if strcmpi(surfaceArray(1).Aperture.Type,'FloatingCircularAperture')
%                 surfaceArray(1).Aperture.Type = 'CircularAperture';
%                 surfaceArray(1).Aperture.UniqueParameters.SmallDiameter = 0;
%                 surfaceArray(1).Aperture.UniqueParameters.LargeDiameter = ...
%                     surfaceArray(1).Aperture.UniqueParameters.Diameter;
%             end
            if surfaceArray(1).Aperture.Type == 1 %'FloatingCircularAperture'
                surfaceArray(1).Aperture.Type = 2; %'CircularAperture';
                surfaceArray(1).Aperture.UniqueParameters.SmallDiameter = 0;
                surfaceArray(1).Aperture.UniqueParameters.LargeDiameter = ...
                    surfaceArray(1).Aperture.UniqueParameters.Diameter;
            end            
            surfaceArray(1).IsObject = 1;
            returnDataStruct.SurfaceArray = surfaceArray; % surface array
    end
