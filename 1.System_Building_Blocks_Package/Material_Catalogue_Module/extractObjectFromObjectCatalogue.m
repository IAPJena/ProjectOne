function [ extractedObject,objectIndex,dispInfo ] = extractObjectFromObjectCatalogue...
        (objectType,objectName,objectCatalogueFullName )
    %EXTRACTCOATINGFROMCOATINGCATALOGUE extracts a  object from the catalogue
    % given its name.
    % Inputs:
    %   (objectType,objectName,objectCatalogueFullName)
    % Outputs:
    %    [  extractedObject,objectIndex,dispInfo  ]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    if isValidObjectCatalogue(objectType, objectCatalogueFullName )
        % load the  object catalogue file
        load(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
        if strcmpi(objectName,'all')
            extractedObject = ObjectArray;
            clear ObjectArray;
            clear 'FileInfoStruct';
            dispInfo  = (strcat('All objects are succefully extracted from the given catalogue.'));
        else
            %check that the  object doesnot exsist in the catalogue
            name = objectName;
            try
            location = find(strcmpi({ObjectArray.Name},name));
            catch
                location = '';
            end
            if isempty(location)
                extractedObject = NaN;
                objectIndex = 0;
                dispInfo = (strcat(name, ' is not in the given catalogue.'));
                return;
            else
                objectIndex = location(1);
                extractedObject = ObjectArray(objectIndex);
                clear ObjectArray;
                clear 'FileInfoStruct';
                dispInfo = (strcat(name, ' succefully extracted from the given catalogue.'));
            end
        end
        
    else
        extractedObject = NaN;
        objectIndex = 0;
        dispInfo = ('Error: The catalogue is not valid.');
        disp(dispInfo);
    end
    
end

