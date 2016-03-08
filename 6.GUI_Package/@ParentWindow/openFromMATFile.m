function [ opened ] = openFromMATFile(parentWindow,fullFileName)
    % openFromMATFile : Open an optical system from MAT file
    % Member of ParentWindow class
    
    % Load the MAT file with variable SavedOpticalSystem which defines the
    % optical system object.
    load(fullFileName);
    opened = openSavedOpticalSystem(parentWindow,SavedOpticalSystem,fullFileName);
end
