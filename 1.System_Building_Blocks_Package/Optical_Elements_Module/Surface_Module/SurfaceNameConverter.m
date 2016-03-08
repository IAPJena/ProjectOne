function [ convertedName ] = SurfaceNameConverter( givenName,conversionType )
%SurfaceNameConverter converts the full name to disp name of the
%surface or vice versa
if nargin == 0
    convertedName = NaN;
    return;
elseif nargin == 1
    conversionType = 1;
end
[ fullNames, shortNames ] = GetSupportedSurfaces();
if conversionType == 1
    % short name to full name converter
    convertedName = fullNames{find(strcmpi(shortNames,givenName))};    
else
    % Full name to short name converter
    convertedName = fullNames{find(strcmpi(fullNames,givenName))}; 
end
end

