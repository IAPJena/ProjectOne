function [ extractedGlass,locationIndex,dispInfo ] = extractGlassFromCatalogue...
    (glassName,glassCatalogueFullName )
    % extractGlassFromCatalogue extracts a Glass from the catalogue given its name

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%	Optical System Design Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% July 28,2014   Worku, Norman G.     Original Version        
    
    if nargin == 0
        disp('Error: The function extractGlassFromCatalogue needs atleast the glassName as input parameter.');
        return;
    elseif nargin == 1
        [FileName,PathName] = uigetfile('*.mat','Select MAT Glass Catalogue File');
        if ~isempty(FileName)&&~isempty(PathName) && ...
                ~isnumeric(FileName) && ~isnumeric(PathName)
            glassCatalogueFullName = [PathName,FileName];
        else
            extractedGlass = NaN;
            locationIndex = 0;
            dispInfo = ('Error: The catalogue is not valid.');
            disp(dispInfo);
            return;
        end    
    end

    if isValidGlassCatalogue(glassCatalogueFullName )
        % load the Glass object catalogue file
        load(glassCatalogueFullName,'GlassArray','FileInfoStruct');
        if strcmpi(glassName,'all')
            extractedGlass = GlassArray;
            clear GlassArray;
            clear 'FileInfoStruct';
            dispInfo  = (strcat('All glasses are succefully extracted from the given catalogue.'));
        else
            %check that the glass does not exsist in the catalogue
            name = glassName;
            location = find(strcmpi({GlassArray.Name},name));
            if isempty(location)
                extractedGlass = NaN;
                locationIndex = 0;
                dispInfo = (strcat(name, ' is not in the given catalogue.'));
                disp(dispInfo);
                return;
            else
                locationIndex = location(1);
                extractedGlass = GlassArray(locationIndex);
                clear GlassArray;
                clear 'FileInfoStruct';
                dispInfo = (strcat(name, ' succefully extracted from the given catalogue.'));
            end
        end

    else
        extractedGlass = NaN;
        locationIndex = 0;
        dispInfo = ('Error: The catalogue is not valid.');
        disp(dispInfo);
    end

end

