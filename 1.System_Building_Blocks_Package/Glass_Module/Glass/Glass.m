function newGlass = Glass(glassName,glassCatalogueFileList,glassType,glassParameters,...
        internalTransmittance,thermalData,wavelengthRange,resistanceData,otherData,glassComment)
    % Glass Struct:
    %   Glass Defines optical glass in the optical system. The temprature dependance
    %   of refractive index of the glass is ignored in the current version
    %
    % Properties: 3 and Methods: 12
    %
    % Example Calls: (2 modes of function calls)
    %
    %% Mode 1: Create or search for glass with out saving. For this mode
    %  only the first two inputs are passed.
    %
    %   newGlass = Glass()
    %       Returns a default 'IdealNonDispersive' glass
    %   newGlass = Glass(glassName)
    %       Searches for and returns the glass  named 'glassName' from all
    %       avaialble glass catalogues.
    %   newGlass = Glass('1.70')
    %       Creates and returns an 'IdealNonDispersive' glass with refractive
    %       index of 1.70.
    %   newGlass = Glass('1.50 54.00 0.00')
    %       Creates and returns an 'IdealDispersive' glass with refractive
    %       index of 1.50,Abbe number 54.00 and relative partial dispersion
    %       of 0.00.
    %   newGlass = Glass(glassName,glassCatalogueFileList)
    %       Searches for and returns the glass named 'MyGlassName' from the
    %       given glass catalogues list.
    %
    %% Mode 2: Create a new glass and then save. The function operates in
    %  this mode when more than 2 inputs are passed to it.
    %
    %   newGlass = Glass(glassName,glassCatalogueFileList,glassType)
    %       Creates a new glass with given name and given type with its default parameters.
    %       The second argument is used to list of glass catalogue files to save the new
    %       glass. If it is 'All', then all available catalogue files will be prompted
    %       for user to select one.
    %
    %   newGlass = Glass(glassName,glassCatalogueFileList,glassType,glassParamStruct)
    %       Creates a new glass with given name and given type with the given glassParamStruct.
    %       The second argument is used to list of glass catalogue files to save the new
    %       glass. If it is 'All', then all available catalogue files will be prompted
    %       for user to select one.
    %  ....
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jun 17,2015   Worku, Norman G.     Support the user defined glass
    %                                    definitions
    
    if nargin < 3 % Mode 1
        if  nargin == 0 || isempty(glassName) || strcmpi(glassName,'None') ||...
                strcmpi(glassName,'Air') % Enable construction  with no inputs, 'none', 'air'
            glassName = '';
            glassCatalogueFileList = {'All'};
            
            glassType = 'IdealNonDispersive';
            [~,~,defaultParamStruct] = getCoatingUniqueParameters( glassType );
            
            glassParameters = defaultParamStruct;
            internalTransmittance  = zeros(1,3);
            thermalData  = zeros(10,1);
            wavelengthRange  = zeros(2,1);
            resistanceData  = zeros(5,1);
            otherData  = zeros(6,1);
            glassComment  = 'No comment';
            
            newGlass = struct();
            newGlass.Name = glassName;
            newGlass.Type = glassType;
            newGlass.UniqueParameters = glassParameters;
            newGlass.InternalTransmittance = internalTransmittance;
            newGlass.ResistanceData = resistanceData;
            newGlass.ThermalData = thermalData;
            newGlass.OtherData = otherData;
            newGlass.WavelengthRange  = wavelengthRange;
            newGlass.Comment = glassComment; %
            newGlass.ClassName = 'Glass';
            return;
        elseif strcmpi(glassName,'Mirror')
            glassName = 'Mirror';
            glassCatalogueFileList = {'All'};
            
            glassType = 'IdealNonDispersive';
            [~,~,defaultParamStruct] = getCoatingUniqueParameters( glassType );
            
            glassParameters = defaultParamStruct;
            internalTransmittance  = zeros(1,3);
            thermalData  = zeros(10,1);
            wavelengthRange  = zeros(2,1);
            resistanceData  = zeros(5,1);
            otherData  = zeros(6,1);
            glassComment  = 'No comment';
            
            newGlass = struct();
            newGlass.Name = glassName;
            newGlass.Type = glassType;
            newGlass.UniqueParameters = glassParameters;
            newGlass.InternalTransmittance = internalTransmittance;
            newGlass.ResistanceData = resistanceData;
            newGlass.ThermalData = thermalData;
            newGlass.OtherData = otherData;
            newGlass.WavelengthRange  = wavelengthRange;
            newGlass.Comment = glassComment; %
            newGlass.ClassName = 'Glass';
            return;
        else
            if nargin == 1 || (strcmpi(glassCatalogueFileList{1},'All'))
                % get all glass catalogues
                objectType = 'Glass';
                glassCatalogueFileList = getAllObjectCatalogues(objectType);
            end
            % Check if glassName is just the refractive index
            % as in the case of IdealDispersive and
            % IdealNonDispersive glass types
            fixedIndexData = str2num(glassName);
            if isempty(fixedIndexData)
                % Search for the given glass in glass
                % catalogues
                % Look for the glass in the availbale glass catalogues.
                savedGlass = extractGlassFromAvailableCatalogues(upper(glassName),glassCatalogueFileList);
                if isempty(savedGlass)
                    disp([glassName,' can not be found in any of the available glass catalogues.']);
                    button = questdlg('The glass is not found in the catalogues. Do you want to choose another?','Glass Not Found');
                    switch button
                        case 'Yes'
                            glassEnteryFig = glassDataInputDialog(glassCatalogueFileList);
                            set(glassEnteryFig,'WindowStyle','Modal');
                            uiwait(glassEnteryFig);
                            selectedGlass = getappdata(0,'Glass');
                        case 'No'
                            selectedGlass = '';
                            % Do nothing
                            disp('Warning: Undefined glass is ignored.');
                        case 'Cancel'
                            selectedGlass = '';
                            % Do nothing
                            disp('Warning: Undefined glass is ignored.');
                    end
                    if isempty(selectedGlass)
                        disp(['No glass is selected so empty glass is used.']);
                        selectedGlass = Glass();
                    else
                        disp([selectedGlass.Name,' is extracted from available glass catalogue.']);
                    end
                    newGlass = selectedGlass;
                    return;
                else
                    newGlass = savedGlass;
                    %                 disp([glassName,' is extracted from available glass catalogue.']);
                    return;
                end
            else
                nFixedIndexData = length(fixedIndexData);
                if nFixedIndexData == 1
                    glassName = [num2str((fixedIndexData(1)),'%.4f ')];
                    glassType = 'IdealNonDispersive';
                    glassParameters = struct();
                    glassParameters.RefractiveIndex = fixedIndexData(1);
                    
                    disp([glassName,' is IdealNonDispersive glass.']);
                elseif nFixedIndexData == 2
                    glassName = [num2str((fixedIndexData(1)),'%.4f '),',',...
                        num2str((fixedIndexData(2)),'%.4f '),',',...
                        num2str((0),'%.4f ')];
                    glassType = 'IdealDispersive';
                    glassParameters = struct();
                    glassParameters.RefractiveIndex = fixedIndexData(1);
                    glassParameters.AbbeNumber = fixedIndexData(2);
                    glassParameters.DeltaRelativePartialDispersion = 0;
                    
                    disp([glassName,' is IdealDispersive glass.']);
                else
                    glassName = [num2str((fixedIndexData(1)),'%.4f '),',',...
                        num2str((fixedIndexData(2)),'%.4f '),',',...
                        num2str((fixedIndexData(3)),'%.4f ')];
                    glassType = 'IdealDispersive';
                    glassParameters = struct();
                    glassParameters.RefractiveIndex = fixedIndexData(1);
                    glassParameters.AbbeNumber = fixedIndexData(2);
                    glassParameters.DeltaRelativePartialDispersion = fixedIndexData(3);
                    
                    disp([glassName,' is IdealDispersive glass.']);
                end
                internalTransmittance  = zeros(1,3);
                thermalData  = zeros(10,1);
                wavelengthRange  = zeros(2,1);
                resistanceData  = zeros(5,1);
                otherData  = zeros(6,1);
                glassComment  = 'No comment';
                
                newGlass.Name = glassName;
                newGlass.Type = glassType;
                newGlass.UniqueParameters = glassParameters;
                newGlass.InternalTransmittance = internalTransmittance;
                newGlass.ResistanceData = resistanceData;
                newGlass.ThermalData = thermalData;
                newGlass.OtherData = otherData;
                newGlass.WavelengthRange  = wavelengthRange;
                newGlass.Comment = glassComment; %
                newGlass.SavedIndex = 0;
                newGlass.ClassName = 'Glass';
                return;
            end
        end
    else % Mode 2
        if (strcmpi(glassCatalogueFileList{1},'All'))
            % get all glass catalogues
            objectType = 'Glass';
            glassCatalogueFileList = getAllObjectCatalogues(objectType);
        end
        % If the glassType and/or other inputs of the new glass is
        % also given then add it to the given glass catalogue and return it.
        if nargin < 4
            [~,~,defaultParamStruct] = getCoatingUniqueParameters( glassType );
            glassParameters = defaultParamStruct;
        end
        
        if nargin < 5
            internalTransmittance  = zeros(1,3);
        end
        if nargin < 6
            thermalData  = zeros(10,1);
        end
        if nargin < 7
            wavelengthRange  = zeros(2,1);
        end
        if nargin < 8
            resistanceData  = zeros(5,1);
        end
        if nargin < 9
            otherData  = zeros(6,1);
        end
        if nargin < 10
            glassComment  = 'No comment';
        end
        
    end
    
    newGlass.Name = glassName;
    newGlass.Type = glassType;
    newGlass.UniqueParameters = glassParameters;
    newGlass.InternalTransmittance = internalTransmittance;
    newGlass.ResistanceData = resistanceData;
    newGlass.ThermalData = thermalData;
    newGlass.OtherData = otherData;
    newGlass.WavelengthRange  = wavelengthRange;
    newGlass.Comment = glassComment; %
    newGlass.ClassName = 'Glass';
    newGlass.SavedIndex = 0;
    
    % Save the new glass in to glass catalogue
    % if the glass already exists in the catalogue then update its
    % parameters and type, otherwise add a new glass
    [savedGlass,catalogueIndex,glassIndex] = extractGlassFromAvailableCatalogues(upper(glassName),glassCatalogueFileList);
    if isempty(savedGlass)
        % Make the user choose the catalogue to which the new glass is to
        % be added.
        [Selection,ok] = listdlg('PromptString','Select the Glass Catalogue File:',...
            'SelectionMode','single',...
            'ListString',glassCatalogueFileList);
        if ok
            selectedCatalogueFullName = glassCatalogueFileList{Selection};
            if isValidObjectCatalogue('Glass', selectedCatalogueFullName)
                glassIndex = addObjectToObjectCatalogue('Glass', newGlass,selectedCatalogueFullName,'ask');
            else
                disp('Error: The selected catalogue is invalid. So the glass is not saved to the catalogue.');
            end
        else
            disp('Warning: The glass is not saved to the catalogue.');
        end
    else
        selectedCatalogueFullName = glassCatalogueFileList{catalogueIndex};
%         glassIndex = addObjectToObjectCatalogue('Glass', newGlass,selectedCatalogueFullName,'ask');
    end
    newGlass.SavedIndex = glassIndex;
    
end


function [savedGlass,catalogueIndex,glassIndex] = extractGlassFromAvailableCatalogues(glassName,GlassCatalogueFileList)
    if nargin == 0
        disp('Error: extractGlassFromAvailableCatalogues needs atleast one argument. ');
        savedGlass = [];
        catalogueIndex = [];
        glassIndex = [];
        return;
    elseif nargin == 1
        % get all glass catalogues
        objectType = 'Glass';
        % dirName = Just use default directory dirName = [pwd,'\Catalogue_Files'];
        [ GlassCatalogueFileList ] = getAllObjectCatalogues(objectType);
    elseif nargin == 2
        % get all glass catalogues
        objectType = 'Glass';
    end
    % Search for the glass in all the catalogues
    for kk = 1:size(GlassCatalogueFileList,1)
        glassCatalogueFullName = GlassCatalogueFileList{kk};
        [ glassObject,objectIndex ] = extractObjectFromObjectCatalogue...
            (objectType,glassName,glassCatalogueFullName );
        if objectIndex ~= 0
            break;
        end
    end
    % if exists return the glass
    if objectIndex ~= 0
        glassIndex = objectIndex;
        catalogueIndex = kk;
        savedGlass = (glassObject);
    else
        savedGlass = [];
        catalogueIndex = [];
        glassIndex = [];
    end
end

