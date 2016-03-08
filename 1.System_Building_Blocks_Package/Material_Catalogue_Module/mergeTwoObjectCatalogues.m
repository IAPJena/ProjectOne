function [ objCatFullNameMergedFullName ] = mergeTwoObjectCatalogues...
        (objectType, objCatFullName1,objCatFullName2,objCatFullNameMergedFullName )
    %mergeTwoObjectCatalogues Merge two  object catalogues and save in a
    % single file. Object catalogues are defined as matlab workspace variables
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
    
    % Default inputs
    if nargin < 3
        disp(['Error: The mergeTwoObjectCatalogues needs atleast objectType ',...
            'objCatFullName1 and objCatFullName2 as argument']);
        return;
    elseif nargin == 3
        objCatFullNameMergedFullName = createNewObjectCatalogue(objectType);
    end
    if isValidObjectCatalogue(objectType, objCatFullName1 ) && ...
            isValidObjectCatalogue(objectType, objCatFullName2 )
        %load the 1st object catalogue file
        load(objCatFullName1,'ObjectArray','FileInfoStruct');
        objectArray1 = ObjectArray;
        clear ObjectArray;
        clear FileInfoStruct;
        %load the 2nd object catalogue file
        load(objCatFullName2,'ObjectArray','FileInfoStruct');
        objectArray2 = ObjectArray;
        clear ObjectArray;
        clear FileInfoStruct;
        addObjectToObjectCatalogue(objectType,objectArray1,objCatFullNameMergedFullName );
        addObjectToObjectCatalogue(objectType,objectArray2,objCatFullNameMergedFullName );
        
        [~,cat1Name,~]  = fileparts(objCatFullName1);
        [~,cat2Name,~]  = fileparts(objCatFullName2);
        [~,mergedCatName,~] = fileparts(objCatFullNameMergedFullName);
        disp(['Merging successful: ',cat1Name,' + ',cat2Name,' = ', mergedCatName]);
    else
        delete(objCatFullNameMergedFullName);
        objCatFullNameMergedFullName = '';
        disp('Error: The catalogue is not valid.');
    end
end

