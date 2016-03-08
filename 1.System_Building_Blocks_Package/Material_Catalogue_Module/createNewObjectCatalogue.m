function [ newObjectCatalogueFullName ] = createNewObjectCatalogue(objectType, ...
        objectCatalogueFullName,ask_replace,initialObjectArray )
    % CREATENEWCOATINGCATALOGUE Create anew  object catalogue and intialize
    % empty array of the corresponding object.Object catalogues are defined
    % as matlab workspace variables 'ObjectArray','FileInfoStruct' saved in
    % a single .mat file as  catalogue. The ObjectArray has array of objects and the
    %  FileInfoStruct is struct with fields such as Name,Type,Date which
    %  are used to validate the catalogue.
    % Inputs:
    %   (objectType, objectCatalogueFullName,ask_replace,initialObjectArray)
    % Outputs:
    %    [ newObjectCatalogueFullName ]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    %Default values
    if nargin < 1
        disp('Error: The function needs atleast objectType as argumet');
        newObjectCatalogueFullName = '';
        return;
    elseif nargin == 1
        objectCatalogueFullName = 'default'; [pwd,'\Catalogue_Files','\New_',objectType,'.mat'];
        ask_replace = 'ask';
    elseif nargin == 2
        ask_replace = 'ask';
    elseif nargin == 3
        ask_replace = 'ask';
    end
    
    if nargin < 4
        switch lower(objectType)
            case 'coating'
                initialObjectArray = createEmptyCoating();
            case 'glass'
                initialObjectArray = createEmptyGlass();
        end
    end
    if strcmpi(objectCatalogueFullName,'default')
        objectCatalogueFullName = [pwd,'\Catalogue_Files','\New_',objectType,'.mat'];
    end
    switch lower(ask_replace)
        case lower('ask')
            Ask = 1;
            Replace = 0;
        case lower('replace')
            Ask = 0;
            Replace = 1;
    end
    
    %check if the catalogue already exsit
    if exist(objectCatalogueFullName,'file')
        [pathstr,name,ext] = fileparts(objectCatalogueFullName);
        alternativeName = fullfile(pathstr,[name,'1',ext]);
        if Ask
            button = questdlg(strcat('There already exists an Object catalogue named ', ...
                name, '. Do you want to create the catalogue with new name: ',name, '1 ?'),...
                'New Catalogue Name','Yes Save','No Replace','Yes Save');
            switch button
                case 'Yes Save'
                    newObjectCatalogueFullName = alternativeName;
                    newObjectCatalogueFullName = createNewObjectCatalogue(objectType,...
                        newObjectCatalogueFullName,ask_replace,initialObjectArray );
                case 'No Replace'
                    % delete the exsisting and create anew one
                    delete(objectCatalogueFullName);
                    newObjectCatalogueFullName = createNewObjectCatalogue(...
                        objectType, objectCatalogueFullName,ask_replace,initialObjectArray );
            end
        else
            % delete the exsisting and create anew one
            delete(objectCatalogueFullName);
            newObjectCatalogueFullName = createNewObjectCatalogue(...
                objectType, objectCatalogueFullName ,ask_replace,initialObjectArray);
        end
    else
        
        FileInfoStruct =  struct();
        ObjectArray = initialObjectArray;
        switch lower(objectType)
            case 'coating'
                FileInfoStruct.Type = 'Coating';
            case 'glass'
                FileInfoStruct.Type = 'Glass';
        end
        FileInfoStruct.Date = fix(clock); % Clock = [YYYY MM DD HH MM SS]
        save(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
        save(objectCatalogueFullName,'ObjectArray','FileInfoStruct','-append');
        newObjectCatalogueFullName = objectCatalogueFullName;
    end
end

