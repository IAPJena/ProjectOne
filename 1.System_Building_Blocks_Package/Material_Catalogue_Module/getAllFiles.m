function [ fileList ] = getAllFiles( dirName )
    %getAllFiles: Searches for all  files in the given directory. And
    % returns their full file names.
    % Inputs:
    %   (dirName)
    % Outputs:
    %    [  fileList  ]
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    % Default directory is caurrent directory
    if nargin < 1
        dirName = pwd;
    end
    
    if dirName == 0
        fileList = NaN;
        return;
    end
    dirData = dir(dirName);      % Get the data for the current directory
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList = {dirData(~dirIndex).name}';  % Get a list of the files
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
    %   that are not '.' or '..'
    for iDir = find(validIndex)                  % Loop over valid subdirectories
        nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
        fileList = [fileList; getAllFiles(nextDir)];  % Recursively call getAllFiles
    end
end

