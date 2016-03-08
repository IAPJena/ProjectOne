function newCoating = Coating(coatingName,coatingCatalogueFileList,coatingType,coatingParameters)
    % Coating Struct:
    %
    %   Defines coating attached to the optical surfaces. All coating
    %   types are defined using external functions and this class makes
    %   calls to the external functions to work with the coating.
    %
    % Properties: 3 and Methods: 12
    %
    % Example Calls: (2 modes of function calls)
    %% Mode 1: Create or search for coating with out saving. For this mode
    %  only the first two inputs are passed.
    %
    % newCoating = Coating()
    %   Returns a null coating which has no optical effect at all.
    %
    % newCoating = Coating(coatingName)
    %   Searchs for coating with given name in all coating catalogues and returns
    %   the coating object if it exists or a coating selection dialog box if not found.
    %
    % newCoating = Coating(coatingName,coatingCatalogueFileList)
    %   Searchs for coating with given name in the specified coating catalogues and returns
    %   the coating object if it exists or a coating selection dialog box if not found.
    %
    %% Mode 2: Create a new coating and then save. The function operates in this mode
    %  when more than 2 inputs are passed to it.
    %
    % newCoating = Coating(coatingName,coatingCatalogueFileList,coatingType)
    %   Creates a new coating with given name and given type with its default parameters.
    %   The second argument is used to list of coating catalogue files to save the new
    %   coating. If it is 'All', then all available catalogue files will be prompted
    %   for user to select one.
    %
    % newCoating = Coating(coatingName,coatingCatalogueFileList,coatingType,coatingParameters)
    %   Creates a new coating with given name and given type with coatingParameters as
    %   its initial parameters. The second argument is used to list of coating catalogue
    %   files to save the new coating. If it is 'All', then all available
    %   catalogue files will be prompted for user to select one.
    %
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jun 17,2015   Worku, Norman G.     Support the user defined coating
    %                                    definitions
    
    % A method used to construct a new coating object from its parameters.
    
    % If only coatingName,coatingCatalogueFileList are given, then search
    % for the coating in the catalogue. If exists extract, otherwise open
    % GUI for selection of another coating
    if nargin < 3
        % Look for the coating in the availbale coating catalogues.
        if nargin < 1 || isempty(coatingName) % Enable construction  with no inputs
            newCoating.Name = 'NullCoating';
            newCoating.Type = 'NullCoating';
            [~,~,defaultCoatingparameters] = getCoatingUniqueParameters( 'NullCoating' );
            newCoating.UniqueParameters = defaultCoatingparameters;
            newCoating.SavedIndex = 0;
            newCoating.ClassName = 'Coating';
            return;
        end
        if nargin < 2 || strcmpi(coatingCatalogueFileList{1},'All')
            % get all coating catalogues
            objectType = 'Coating';
            coatingCatalogueFileList = getAllObjectCatalogues(objectType);
        end
        savedCoating = extractCoatingFromAvailableCatalogues(upper(coatingName),coatingCatalogueFileList);
        if isempty(savedCoating)
            disp([coatingName,' can not be found in any of the available coating catalogues.']);
            
            button = questdlg('The coating is not found in the catalogues. Do you want to choose another?','Coating Not Found');
            switch button
                case 'Yes'
                    coatingEnteryFig = coatingDataInputDialog(coatingCatalogueFileList);
                    set(coatingEnteryFig,'WindowStyle','Modal');
                    uiwait(coatingEnteryFig);
                    selectedCoating = getappdata(0,'Coating');
                case 'No'
                    selectedCoating = '';
                    % Do nothing
                    disp('Warning: Undefined coating is ignored.');
                case 'Cancel'
                    selectedCoating = '';
                    % Do nothing
                    disp('Warning: Undefined coating is ignored.');
            end
            if isempty(selectedCoating)
                disp(['No coating is selected so Null coating is used.']);
                selectedCoating = Coating();
            else
                disp([selectedCoating.Name,' is extracted from available coating catalogue.']);
            end
            newCoating = selectedCoating;
        else
            newCoating = savedCoating;
            disp([coatingName,' is extracted from available coating catalogue.']);
        end
    else
        if strcmpi(coatingCatalogueFileList{1},'All')
            % get all coating catalogues
            objectType = 'Coating';
            coatingCatalogueFileList = getAllObjectCatalogues(objectType);
        end
        % If the coatingType and/or coatingParameters of the new coating is
        % also given then add it to the given coating catalogue and return it.
        if nargin < 4
            [~,~,defaultCoatingparameters] = getCoatingUniqueParameters( coatingType );
            coatingParameters = defaultCoatingparameters;
        end
        
        newCoating = Coating();
        newCoating.Name = coatingName;
        newCoating.Type = coatingType;
        newCoating.UniqueParameters = coatingParameters;
        newCoating.ClassName = 'Coating';
        
        % if the coating already exists in the catalogue then update its
        % parameters and type otherwise add a new coating
        [savedCoating,catalogueIndex,coatingIndex] = extractCoatingFromAvailableCatalogues(upper(coatingName),coatingCatalogueFileList);
        if isempty(savedCoating)
            % Make the user choose the catalogue to which the new coating is to
            % be added.
            [Selection,ok] = listdlg('PromptString','Select the Coating Catalogue File:',...
                'SelectionMode','single',...
                'ListString',coatingCatalogueFileList);
            if ok
                selectedCatalogueFullName = coatingCatalogueFileList{Selection};
                if isValidObjectCatalogue('Coating', selectedCatalogueFullName)
                    coatingIndex = addObjectToObjectCatalogue('Coating', newCoating,selectedCatalogueFullName,'ask');
                else
                    disp('Error: The selected catalogue is invalid. So the coating is not saved to the catalogue.');
                end
            else
                disp('Warning: The coating is not saved to the catalogue.');
            end
        else
            selectedCatalogueFullName = coatingCatalogueFileList{catalogueIndex};
            coatingIndex = addObjectToObjectCatalogue('Coating', newCoating,selectedCatalogueFullName,'ask');
        end
        newCoating.SavedIndex = coatingIndex;
    end
end

function [savedCoating,catalogueIndex,coatingIndex] = extractCoatingFromAvailableCatalogues(coatingName,CoatingCatalogueFileList)
    if nargin == 0
        disp('Error: extractCoatingFromAvailableCatalogues needs atleast one argument. ');
        savedCoating = [];
        coatingIndex = [];
        catalogueIndex = [];
        return;
    elseif nargin == 1
        % get all Coating catalogues
        objectType = 'Coating';
        % dirName = Just use default directory dirName = [pwd,'\Catalogue_Files'];
        [ CoatingCatalogueFileList ] = getAllObjectCatalogues(objectType);
    elseif nargin == 2
        % get all glass catalogues
        objectType = 'Coating';
    end
    % Search for the Coating in all the catalogues
    for kk = 1:size(CoatingCatalogueFileList,1)
        coatingCatalogueFullName = CoatingCatalogueFileList{kk};
        [ coatingObject,objectIndex ] = extractObjectFromObjectCatalogue...
            (objectType,coatingName,coatingCatalogueFullName );
        if objectIndex ~= 0
            break;
        end
    end
    % if exists return the coating
    if objectIndex ~= 0
        coatingIndex = objectIndex;
        savedCoating = coatingObject;
        catalogueIndex = kk;
    else
        savedCoating = [];
        coatingIndex = [];
        catalogueIndex = [];
    end
end