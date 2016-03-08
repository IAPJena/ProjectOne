function [ returnDataStruct] = PlaneWaveProfile(returnFlag,spatialProfileParameters,inputDataStruct)
    % PlaneWaveProfile A user defined function for plane wave spatial profile
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined spatial profiles.
    % spatialProfileParameters = values of {'Diameter'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Return the field names and initial values of spatialProfileParameters
    % which could be used in the Source definition GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the spatial profile shape and size(fieldDiameter)
    %   inputDataStruct:
    %        empty
    %   returnDataStruct:
    %       returnDataStruct.BoarderShape
    %       returnDataStruct.BoarderDiameter
    % 3: Return the spatial profile for given meshgrid points xMesh and yMesh
    %   inputDataStruct:
    %       inputDataStruct.xMesh
    %       inputDataStruct.yMesh
%     %       inputDataStruct.LateralPosition
    %   returnDataStruct:
    %       returnDataStruct.SpatialProfileMatrix,
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 09,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input values
    if nargin < 1
        disp(['Error: The function PlaneWaveProfile() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 1
            % OK
        elseif returnFlag == 2
            % get the default parameters
            retF = 1;
            returnData = PlaneWaveProfile(retF);
            spatialProfileParameters = returnData.DefaultUniqueParametersStruct;
        else
            disp(['Error: The function PlaneWaveProfile() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 1
            % OK
        elseif returnFlag == 2
            % OK
        else
            disp(['Error: The function PlaneWaveProfile() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of spatialProfileParameters
            returnData1 = {'Diameter'};
            returnData1_Disp = {'Diameter'};
            returnData2 = {'numeric'};
            
            spatialProfileParametersStruct = struct();
            spatialProfileParametersStruct.Diameter = 1*10^-3;
            returnData3 = spatialProfileParametersStruct;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
            
        case 2 % Return the spatial profile shape and size(fieldDiameter)
            boarderShape = 1; % elliptical
            diameterX = spatialProfileParameters.Diameter;
            diameterY = spatialProfileParameters.Diameter;
            returnDataStruct.BoarderShape = boarderShape;
            returnDataStruct.BoarderDiameter = [diameterX,diameterY]';
        case 3 % Return the spatial profile
            x = inputDataStruct.xMesh;
            y = inputDataStruct.yMesh;
%             % lateral offset
%             cx = inputDataStruct.LateralPosition(1);
%             cy = inputDataStruct.LateralPosition(2);
            % The plane wave profile
            Uxy = ones(size(x));
            returnDataStruct.SpatialProfileMatrix = Uxy;% (sizeX X sizeY) Matrix of normalized amplitude
    end
end