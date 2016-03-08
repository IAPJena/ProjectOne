function [ addedPosition ] = addObjectToObjectCatalogue...
        (objectType, object,objectCatalogueFullName,ask_replace )
    % addObjectToObjectCatalogue: Adds the given object to the given object
    % catalogue. Object catalogues are defined as matlab workspace variables
    %  'ObjectArray','FileInfoStruct' saved in a single .mat file as
    %  catalogue. The ObjectArray has array of objects and the
    %  FileInfoStruct is struct with fields such as Name,Type,Date which
    %  are used to validate the catalogue.
    % Inputs:
    %   (objectType, object,objectCatalogueFullName,ask_replace)
    % Outputs:
    %    [ addedPosition ]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    if nargin == 3
        ask_replace = 'ask';
    end
    switch lower(ask_replace)
        case lower('ask')
            Ask = 1;
            Replace = 0;
        case lower('replace')
            Ask = 0;
            Replace = 1;
    end
    
    if ~strcmpi(object.ClassName,objectType)
        disp('Error: The object to be added and the catalogue type does not match.');
        addedPosition = 0;
        return;
    end
    
    if isValidObjectCatalogue(objectType, objectCatalogueFullName )
        %load the coating catalogue file
        load(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
        %check that the  Object doesnot exsist in the catalogue
        % Compare the existance of each object on the catalogue
        if isempty(ObjectArray)
            existingObjectNames = '';
        else
            existingObjectNames = {ObjectArray.Name};
        end
        newObjectNames = {object.Name};
        % locations will be cell array of logicals arrays indicating exactly
        % where the new object name exists in the old catalogue
        locations = cellfun(@(x) strcmpi(x,existingObjectNames),newObjectNames,...
            'UniformOutput', false);
        locations = find(cell2mat(locations));
        % Indices of new object which are already exsisting
        alreadyExistingObjIndices = ceil(locations./size(existingObjectNames,2));
        
        if ~isempty(alreadyExistingObjIndices)
            for k = 1:size(alreadyExistingObjIndices,1)
                repeatedName = newObjectNames{alreadyExistingObjIndices(k)};
                alternativeName = [repeatedName,'1'];
                if Ask
                    button = questdlg(strcat(repeatedName, ' is already in the catalogue.',...
                        ' Do you want to save with new object name: ',alternativeName, ' ?'),...
                        'New Object Name','Yes Save','No Replace','Yes Save');
                    switch button
                        case 'Yes Save'
                            % Give new name for the new object
                            object(alreadyExistingObjIndices(k)).Name = alternativeName;
                            [ addedPosition ] = addObjectToObjectCatalogue...
                                (objectType, object,objectCatalogueFullName,'ask' );
                        case 'No Replace'
                            newObjectNames = {object.Name};
                            indexInTheCat = find(strcmpi(existingObjectNames,repeatedName));
                            ObjectArray(indexInTheCat) = object;
                            save(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
                            clear ObjectArray;
                            clear 'FileInfoStruct';
                            disp(char(['Successfully updated: ',newObjectNames]));
                            addedPosition = indexInTheCat;
                    end
                    
                else
                    newObjectNames = {object.Name};
                    indexInTheCat = find(strcmpi(existingObjectNames,repeatedName));
                    ObjectArray(indexInTheCat) = object;
                    save(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
                    clear ObjectArray;
                    clear 'FileInfoStruct';
                    disp(char(['Successfully updated: ',newObjectNames]));
                    addedPosition = indexInTheCat;
                end
            end
        else
            
            newObjectNames = {object.Name};
            indexInTheCat = [length(ObjectArray)+1 : length(ObjectArray)+length(object)];
            ObjectArray(indexInTheCat) = object;
            save(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
            clear ObjectArray;
            clear 'FileInfoStruct';
            disp(char(['Successfully added: ',newObjectNames]));
            addedPosition = indexInTheCat;
        end
    else
        addedPosition = 0;
        disp('Error: The catalogue is not valid.');
    end
end

