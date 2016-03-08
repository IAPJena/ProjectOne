function selectedObject = objectDataInputDialog(objectType,objectCatalogueListFullNames, referenceWavelength, fontSize,fontName)
    % objectDataInputDialog: Defines a dilog box which is used to input object
    % data based on its type. And returns an object selected from the
    % dialog box. It has uiwait function which halts the excusion of the
    % whole program till user sesectes a given object and closes the
    % dialog.
    % Inputs:
    %   (objectType)
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
    
    
    % Default Input
    if nargin == 0
        disp('Error: The function objectDataInputDialog needs atleast an objectType as argument.');
        selectedObject = NaN;
        return;
    elseif nargin == 1
        % Get all catalogues from current folder
        objectCatalogueListFullNames = getAllObjectCatalogues(objectType);
        % Used as primary wavelength for relative thickness values
        referenceWavelength = 0.55*10^-6;        
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 2
        % Used as primary wavelength for relative thickness values
        referenceWavelength = 0.55*10^-6;
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 3
        fontSize = 9.5;
        fontName = 'FixedWidth';
    elseif nargin == 4
        fontName = 'FixedWidth';
    end
    
    switch lower(objectType)
        case 'coating'
            coatingDataInputDialog(referenceWavelength,objectCatalogueListFullNames,fontName,fontSize);
            uiwait(gcf);
            selectedObject = getappdata(0,'Coating');
        case 'glass'
            glassDataInputDialog(objectCatalogueListFullNames,fontName,fontSize);
            uiwait(gcf);
            selectedObject = getappdata(0,'Glass');
    end
    
end