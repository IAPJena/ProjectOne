function [ newGlassCatalogueFullName ] = createNewGlassCatalogue...
        (glassCatalogueFullName,ask_replace,initialGlassArray )
    % createNewGlassCatalogue: Create a new Glass catalogue in matlab and
    % intialize to initialGlassArray or an empty array of glass.
    % Inputs:
    %   (glassCatalogueFullName,ask_replace,initialGlassArray)
    % Outputs:
    %   [newGlassCatalogueFullName].
    
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
    initialObjectArray = initialGlassArray;
    [ newGlassCatalogueFullName ] = createNewObjectCatalogue...
        (objectType, objectCatalogueFullName,ask_replace,initialObjectArray );
end

