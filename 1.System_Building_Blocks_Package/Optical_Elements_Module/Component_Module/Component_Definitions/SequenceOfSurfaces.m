function [ returnDataStruct] = SequenceOfSurfaces( ...
        returnFlag,componentParameters,inputDataStruct)
    %SequenceOfSurfaces COmponent composed of a general sequence of surfaces
    % componentParameters = values of {'SurfaceArray'}
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
        disp('Error: The function SequenceOfSurfaces() needs atleat the return type.');
        returnDataStruct = NaN;
        return;
    end
    
    if returnFlag == 4
        if nargin < 2
            % take the defualt componentparameters
            returnFlag = 2;
            [returnDataStruct] = SequenceOfSurfaces(returnFlag);
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
            returnData1 = {'SQS'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            returnData2 = {[pathstr,'\SequenceOfSurfaces.jpg']};  % Image file name
            returnData3 = {['Sequence of surface: is a general sequence of'...
                ' surface whose tilt, decenter and aperture parameters are',...
                ' determined by that of the primary surface, which is usually',...
                ' the first surface in the sequence. It can be used to',...
                ' represent a single surface, singlet lens, doublet lens ...']};  % Text description
            
            returnDataStruct.Name = returnData1;
            returnDataStruct.ImageFullFileName = returnData2;
            returnDataStruct.Description = returnData3;
            
        case 2 % 'BasicComponentDataFields' table field names and initial values in COmponent Editor GUI
            defaultCompUniqueStruct = struct();
            defaultCompUniqueStruct.SurfaceArray = Surface;
            
            returnDataStruct.UniqueParametersStructFieldNames = {'SurfaceArray'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldDisplayNames = {'Surface Array'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldFormats = {'SQS'};
            returnDataStruct.DefaultUniqueParametersStruct= defaultCompUniqueStruct; % default value
            
        case 3 % 'Extra Data' table field names and initial values in Component Editor GUI
            returnDataStruct.UniqueExtraDataFieldNames = {'Unused'};
            returnDataStruct.DefaultUniqueExtraData = {[0]};
        case 4 % return the surface array of the compont
            surfaceArray = componentParameters.SurfaceArray;
            surfaceArray(1).Tilt = inputDataStruct.FirstTilt;
            surfaceArray(1).Decenter = inputDataStruct.FirstDecenter;
            surfaceArray(1).TiltDecenterOrder = inputDataStruct.FirstTiltDecenterOrder;
            surfaceArray(end).Thickness = inputDataStruct.LastThickness;
            surfaceArray(end).TiltMode = inputDataStruct.ComponentTiltMode;
            referenceCoordinateTM = inputDataStruct.ReferenceCoordinateTM;
            previousThickness = inputDataStruct.PreviousThickness;
            % Tilt and decenter
            nSurf = length(surfaceArray);
            for kk = 1:nSurf
                currentSurface = surfaceArray(kk);
                [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
                    currentSurface,referenceCoordinateTM,previousThickness);
                % set surface property
                currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
                currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
                previousThickness = currentSurface.Thickness;
                surfaceArray(kk) = currentSurface;
            end
            returnDataStruct.SurfaceArray = surfaceArray; % surface array
    end
