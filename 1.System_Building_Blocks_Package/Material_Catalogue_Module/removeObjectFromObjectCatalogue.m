function [ removed ] = removeObjectFromObjectCatalogue(objectType, objectName,objectCatalogueFullName )
    %REMOVECOATINGTOCOATINGCATALOGUE removes a object to the given
    % catalogue. Object catalogues are defined as matlab workspace variables
    %  'ObjectArray','FileInfoStruct' saved in a single .mat file as
    %  catalogue. The ObjectArray has array of objects and the
    %  FileInfoStruct is struct with fields such as Name,Type,Date which
    %  are used to validate the catalogue.
    % Inputs:
    %   (objectType, objCatFullName1,objCatFullName2,objCatFullNameMergedFullName)
    % Outputs:
    %    [mergedSuccess]
    
    
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
        %load the object catalogue file
        load(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
        %check that the object does exsist in the catalogue
        name = objectName;
        location = find(strcmpi({ObjectArray.Name},name));
        if isempty(location)
            disp(strcat(name, ' is not in the given catalogue.'));
            removed = 0;
            return;
        else
            ObjectArray = ObjectArray([1:location(1)-1,location(1)+1:end]);
            save(objectCatalogueFullName,'ObjectArray','FileInfoStruct');
            clear 'ObjectArray';
            clear 'FileInfoStruct';
            disp(strcat(name, ' is successfully removed from the catalogue.'));
            removed = 1;
        end
    else
        removed = 0;
        disp('Error: The catalogue is not valid.');
    end
end



