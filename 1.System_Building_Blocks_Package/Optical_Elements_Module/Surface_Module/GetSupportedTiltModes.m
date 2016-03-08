function [fullNames,displayNames] = GetSupportedTiltModes(index)
    if nargin < 1
        index = 0;
    end
    fullNames = {'DAR' 'NAX' 'BEN'};
    displayNames = {'DAR (Decenter and Return)' 'NAX (New Axis)' 'BEN (Bend Axis)'};
    if index
        fullNames= fullNames{index};
        displayNames= displayNames{index};
    end
end

