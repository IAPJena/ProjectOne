function [ objectCatalogueFileNames ] = getAnObjectCatalogue(objectCatalogueName,objectType, dirName)
    %getAnObjectCatalogue Searches for all Object catalogue files in the
    % given directory and returns the file name of the one with given name.
    % Inputs:
    %   (objectCatalogueName,objectType, dirName)
    % Outputs:
    %    [objectCatalogueFileNames]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    % make the current path the default search path
    if nargin < 2
        disp('Error: The getAnObjectCatalogue needs atleast objectCatalogueName and objectType as argument');
        objectCatalogueFileNames = NaN;
        return;
    elseif nargin == 2
        dirName = [pwd,'\Catalogue_Files'];
        if ~exist(dirName)
            mkdir(dirName);
            addpath(dirName);
            if strcmpi(objectType,'Coating')
                createNewObjectCatalogue('coating', ...
                    [dirName,'\Coating_Catalogue00.mat'],'replace' );
            elseif strcmpi(objectType,'Glass')
                createNewObjectCatalogue('glass', ...
                    [dirName,'\Glass_Catalogue00.mat'],'replace' );
            else
                disp('Error: Invalid objectType argument to getAnObjectCatalogue funtion.');
                objectCatalogueFileNames = NaN;
                return;
            end
        end
    end
    
    % get all files
    fileList = getAllFiles( dirName );
    validMatchingFileIndex = 0;
    % loop through the file lists and check if they are valid Object catalogue
    % files. NB. Object catalogue files have .MAT extension and have
    % ObjectArrry and FileInfoStruct variables. And FileInfoStruct.Type =
    % 'Coating' or 'Glass' or 'OpticalSystem'
    objectCatalogueFileNames{1,:} = [];
    for k = 1:size(fileList,1)
        fullFileName = fileList{k,:};
        [pathstr,name,ext] = fileparts(fullFileName);
        if ~isempty(name) && (strcmpi(name,objectCatalogueName) || strcmpi([name,ext],objectCatalogueName))
            if strcmpi(ext,'.mat') && ~ strcmpi(name(1),'$') % .mat files which are not hidden
                if isValidObjectCatalogue(objectType, fullFileName)
                    validMatchingFileIndex = validMatchingFileIndex + 1;
                    objectCatalogueFileNames{validMatchingFileIndex,:} = fullFileName;
                else
                    
                end
            else
                
            end
        else
        end
        
    end
    % disp([num2str(validFileIndex),' Valid Object Catalogue Files Found.']);
    if ~validMatchingFileIndex
        objectCatalogueFileNames = [];
    end
end

