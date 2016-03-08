function [ valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames] = isValidGlassCatalogue...
        (glassCatalogueFullName )
    % isValidGlassCatalogue Retruns whether the glass catalogue is vlaid or
    % not. If the glass catalogue is valid but is located in different path than
    % specifed the new location is returned as relatedCatalogueFullFileNames.
    % Inputs:
    %   (glassCatalogueFullName)
    % Outputs:
    %   [valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames].
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % July 28,2014   Worku, Norman G.     Original Version
    
    objectType = 'Glass';
    objectCatalogueFullName = glassCatalogueFullName;
    [ valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames] = isValidObjectCatalogue...
        (objectType, objectCatalogueFullName );
end