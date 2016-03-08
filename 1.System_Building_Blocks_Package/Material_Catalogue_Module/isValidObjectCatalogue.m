function [ valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames] = isValidObjectCatalogue...
        (objectType, objectCatalogueFullName )
    %ISVALIDCOATINGCATALOGUE Retruns whether the object catalogue is vlaid or not.
    % Inputs:
    %   (objectType, objectCatalogueFullName)
    % Outputs:
    %    [valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    if nargin == 0
        disp(['Error: The isValidObjectCatalogue needs objectType ',...
            'and objectCatalogueFullName as argument']);
        valid = 0;
        fileInfoStruct = NaN;
        dispMsg = '';
        relatedCatalogueFullFileNames = '';
        return;
    elseif nargin == 1
        [FileName,PathName] = uigetfile('*.mat','Select MAT Catalogue File');
        if ~isempty(FileName)&&~isempty(PathName) && ...
                ~isnumeric(FileName) && ~isnumeric(PathName)
            objectCatalogueFullName = [PathName,FileName];
        else
            disp(['Error: The isValidObjectCatalogue needs glassCatalogueFullName as argument']);
            valid = 0;
            fileInfoStruct = NaN;
            dispMsg = '';
            relatedCatalogueFullFileNames = '';
            return;
        end
    end
    
    validCatalogueTypes = {'CoatingCatalogue','GlassCatalogue','OpticalSystemCatalogue'};
    [pathstr,name,ext] = fileparts(objectCatalogueFullName);
    
    %load the object array and field info struct from the file
    %     try
    if exist(objectCatalogueFullName,'file')&&~isempty(name)
        relatedCatalogueFullFileNames = objectCatalogueFullName;
        S = load(objectCatalogueFullName);
        % Variable named FileInfoStruct and ObjectArray does exsist
        if isfield(S,'FileInfoStruct') && isfield(S,'ObjectArray')
            fileInfo = S.FileInfoStruct;
            objectArray = S.ObjectArray;
            % Variable named FileInfoStruct is empty
            if isempty(fieldnames(fileInfo))
                valid = 0;
                fileInfoStruct = [];
                dispMsg = 'Error: Invalid Object Catalogue File';
                return
            else
                if (strcmpi(fileInfo.Type,objectType))%&& strcmpi(class(objectArray),objectType))
                    valid = 1;
                    fileInfoStruct = fileInfo;
                    dispMsg = 'Success: Object Catalogue File is Valid.';
                    return
                else
                    valid = 0;
                    fileInfoStruct = [];
                    dispMsg = 'Error: Invalid Object Catalogue File';
                    return
                end
            end
        else
            valid = 0;
            fileInfoStruct = [];
            dispMsg = 'Error: Invalid Object Catalogue File';
            return
        end
    else
        % check if the catalogue exists in another path
        valid = 0;
        fileInfoStruct = [];
        relatedCatalogueFullFileNames = which([name,ext],'-all');
        dispMsg = ['Error:  ',objectCatalogueFullName ,'  does not exists.'];
        return
    end
    
    
