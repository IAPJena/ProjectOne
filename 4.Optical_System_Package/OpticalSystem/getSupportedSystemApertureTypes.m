function [ fullNames,shortNames  ] = getSupportedSystemApertureTypes(index)
    %GETSUPPORTEDSYSTEMAPERTURETYPES Summary of this function goes here
    %   Detailed explanation goes here
    shortNames = {'ENPD','OBNA','FLST'};
    fullNames = {'EnterancePupilDiameter','ObjectSpaceNA','FloatByStopSize'};
     if nargin == 1
       shortNames = shortNames{index}; 
       fullNames = fullNames{index};
    end
end

