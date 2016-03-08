function [ addedPosition ] = addGlassToGlassCatalogue...
        (newGlass,glassCatalogueFullName,ask_replace )
    % addGlassToGlassCatalogue: Adds the given glass to the given glass
    % catalogue. If the glass already exists then it asks to save in
    % another name or just replaces based on the ask_replace argument
    % Inputs:
    %   (newGlass,glassCatalogueFullName,ask_replace)
    % Outputs:
    %   [added]
    
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
    object = newGlass;
    objectCatalogueFullName = glassCatalogueFullName;
    [ addedPosition ] = addObjectToObjectCatalogue...
        (objectType, object,objectCatalogueFullName,ask_replace );
end

