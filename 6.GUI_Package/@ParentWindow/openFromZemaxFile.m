function [ opened ] = openFromZemaxFile(parentWindow,zmxFullFileName)
% openFromZemaxFile: Imports and opens zmx files. The function 'importZemaxFile'
% opens the .ZMX file and reads the optical system data from the file.
% Member of ParentWindow class

aodHandles = parentWindow.ParentHandles;

% Coating Catalogue
tableData1 = get(aodHandles.tblCoatingCatalogues,'data');
if ~isempty(tableData1)
    % Take only the selected ones
    selectedRows1 = find(cell2mat(tableData1(:,1)));
    if ~isempty(selectedRows1)
        coatingCatalogueListFullNames = tableData1(selectedRows1,3);
    else
        coatingCatalogueListFullNames = '';
    end
else
    coatingCatalogueListFullNames = '';
end


% Glass Catalogue
tableData1 = get(aodHandles.tblGlassCatalogues,'data');
if ~isempty(tableData1)
    % Take only the selected ones
    selectedRows1 = find(cell2mat(tableData1(:,1)));
    if ~isempty(selectedRows1)
        glassCatalogueListFullNames = tableData1(selectedRows1,3);
    else
        glassCatalogueListFullNames = '';
    end
else
    glassCatalogueListFullNames = '';
end

importedOpticalSystem = importZemaxFile (zmxFullFileName,...
    coatingCatalogueListFullNames,glassCatalogueListFullNames);

opened = openSavedOpticalSystem(parentWindow,importedOpticalSystem,0);
end
