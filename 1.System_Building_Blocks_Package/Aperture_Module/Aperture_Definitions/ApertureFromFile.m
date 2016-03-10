function [ returnDataStruct] = ApertureFromFile(returnFlag,apertureParameters,inputDataStruct)
    %ApertureFromFile  Defn of aperture which is stored in the form of
    %file. At the moment the file is assumed to be picture and text file
    %with the matrix.
    % apertureParameters = values of {'File','WidthInX','WidthInY'}
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
        disp(['Error: The function ApertureFromFile() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 3
            disp(['Error: The function ApertureFromFile() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 3
            disp(['Error: The function ApertureFromFile() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    %%
    switch returnFlag(1)
        case 1 % Return the field names and initial values of apertureParameters
            returnData1 = {'FileName','WidthInX','WidthInY','UsedFraction'};
            returnData1_Display = {'File Name','Width In X','Width In Y','Used Fraction'};
            returnData2 = {'file','numeric','numeric','numeric'};
            defaultApertureParameter = struct();
            [thisFolderPath,thisFileName,ext] = fileparts(mfilename('fullpath'));
            defaultApertureParameter.FileName = [thisFolderPath,'\DefaultAperture.jpg'];
            defaultApertureParameter.WidthInX = 10;
            defaultApertureParameter.WidthInY = 10;
            defaultApertureParameter.UsedFraction = 0.75;
            returnData3 = defaultApertureParameter;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Display;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Return the maximum radius in x and y axis
            maximumRadiusXY(1) = (apertureParameters.WidthInX)/2;
            maximumRadiusXY(2) = (apertureParameters.WidthInY)/2;
            
            returnDataStruct.MaximumRadiusXY = maximumRadiusXY;
        case 3 % Return the if the given points in xyVector are inside or outside the aperture.
            xyVectorOrMesh = inputDataStruct.xyVector;
            if ndims(xyVectorOrMesh) == 3
                isXYMesh = 1;
                pointX = xyVectorOrMesh(:,:,1);
                pointY = xyVectorOrMesh(:,:,2);
            elseif ndims(xyVectorOrMesh) == 2
                isXYMesh = 0;
                pointX = xyVectorOrMesh(:,1);
                pointY = xyVectorOrMesh(:,2);
            end
            
            widthInX = apertureParameters.WidthInX;
            widthInY = apertureParameters.WidthInY;
            usedFraction = apertureParameters.UsedFraction; % Fraction of the aperture actually used
            fullFileName = apertureParameters.FileName;
            % Determine the type of file and import as matrix
            [thisFolderPath,thisFileName,ext] = fileparts(fullFileName);
            % Import and save the file as mat file for future use
            switch lower(ext)
                case {'.mat'}
                    load([thisFolderPath,'\',thisFileName,'.mat'],'StoredMatrix');
                    storedAperture = StoredMatrix;
                case {'.bmp','.jpg','.png'}
                    storedAperture = double(flipud(rgb2gray(imread(fullFileName))));
                case {'.txt'} % coma delimited text file
                    storedAperture = dlmread(filename);
                otherwise
                    disp('Error: The file defining the aperture is not supported.');
                    storedAperture = ones(50,50);
            end
            StoredMatrix = storedAperture;
            save([thisFolderPath,'\',thisFileName,'.mat'],'StoredMatrix');
            storedApertureNormalized = storedAperture/max(max(storedAperture));
            
            % Compute pixel number corresponding to the given pointX and
            % pointY vector
            tol = 10^-15; % Avoids rays falsely flaged as out of aperture due to numerics
            [ny,nx] = size(storedApertureNormalized);
            innerWidthInX = widthInX*usedFraction;
            innerWidthInY = widthInY*usedFraction;
            interpolationMethod = 'linear';
            [X,Y] = meshgrid(linspace(-innerWidthInX/2,innerWidthInX/2,nx),linspace(-innerWidthInY/2,innerWidthInY/2,ny));
            V = storedApertureNormalized;
            Xq = pointX;
            Yq = pointY;
            Vq = griddata(X(:),Y(:),V(:),Xq(:),Yq(:),interpolationMethod);
            umInsideTheMainAperture = (~isnan(Vq) & Vq > 0.5+tol);
            if isXYMesh
                umInsideTheMainAperture = reshape(umInsideTheMainAperture,[size(pointX)]);
            end
            returnDataStruct.IsInsideTheMainAperture = umInsideTheMainAperture;
    end
    
end

