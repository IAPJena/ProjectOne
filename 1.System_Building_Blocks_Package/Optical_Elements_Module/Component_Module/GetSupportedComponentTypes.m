function [ fullNames,shortNames  ] = GetSupportedComponentTypes(index)
    %GETSUPORTEDCOMPONENTS Returns the currntly supported compoents as cell array
    if nargin < 1
        index = 0;
    end
    shortNames = {'SQS','Grating1D','Prism'};
    fullNames = {'SequenceOfSurfaces','Grating1D','Prism'};
    %'Object','Image', are also comp types but not displayed
    if index
        shortNames = shortNames{index};
        fullNames = fullNames{index};
    end
end
