function [ ObjectCatalogueFileList ] = getAllObjectCatalogues(objectType, dirName)
    %getAllObjectCatalogues Searches for all Object catalogue files in the
    % given directory. And returns their full file names. Object catalogues 
    %  are defined as matlab workspace variables 'ObjectArray','FileInfoStruct' 
    % saved in a single .mat file as catalogue. The ObjectArray has array of 
    % objects and the FileInfoStruct is struct with fields such as Name,Type,
    % Date which  are used to validate the catalogue.
    % Inputs:
    %   (objectType, dirName)
    % Outputs:
    %    [ObjectCatalogueFileList]
    
    
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
    if nargin < 1
        disp('Error: The getAllObjectCatalogues needs atleast objectType as argument');
        return;
    elseif nargin == 1
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
            end
        end
    end
    % get all files
    fileList = getAllFiles( dirName );
    validFileIndex = 0;
    % loop through the file lists and check if they are valid Object catalogue
    % files. NB. Object catalogue files have .MAT extension and have
    % ObjectArrry and FileInfoStruct variables. And FileInfoStruct.Type =
    % 'Coating' or 'Glass' or 'OpticalSystem'
    ObjectCatalogueFileList{1,:} = [];
    for k = 1:size(fileList,1)
        fullFileName = fileList{k,:};
        [pathstr,name,ext] = fileparts(fullFileName);
        if ~isempty(name)
            if strcmpi(ext,'.mat') && ~ strcmpi(name(1),'$') % .mat files which are not hidden
                if isValidObjectCatalogue(objectType, fullFileName)
                    validFileIndex = validFileIndex + 1;
                    ObjectCatalogueFileList{validFileIndex,:} = fullFileName;
                else
                    
                end
            else
                
            end
        else
        end
        
    end
    % disp([num2str(validFileIndex),' Valid Object Catalogue Files Found.']);
    if ~validFileIndex
        ObjectCatalogueFileList = [];
    end
end

