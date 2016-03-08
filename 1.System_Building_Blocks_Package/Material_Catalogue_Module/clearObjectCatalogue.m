function [ cleared ] = clearObjectCatalogue(objectType, objectCatalogueFullName )
    %CLEARCOATINGCATALOGUE Remove all object from the catalogue
    % Inputs:
    %   (objectType,objectCatalogueFullName)
    % Outputs:
    %    [ cleared ]
    
    
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
        % delete the exsisting and create anew one
        delete(objectCatalogueFullName);
        cleared = createNewObjectCatalogue(objectType, objectCatalogueFullName );
        disp('The catalogue is successfully cleared.');
    else
        cleared = 0;
        disp('Error: The catalogue is not valid.');
    end
end

