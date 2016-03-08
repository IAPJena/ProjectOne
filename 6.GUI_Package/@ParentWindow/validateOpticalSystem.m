function [ validSystem,message,currentOpticalSystem ] = validateOpticalSystem(parentWindow)
    % validateOpticalSystem: Validates all input parameters of the optical system
    % Retuns invalid flag and displays the error on the command window if the inputs
    % of the system are not valid.
    % Member of ParentWindow class
    
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    aodHandles = parentWindow.ParentHandles;
    mm = 0;
    isValid = 1;
    nConfig = length(aodHandles.OpticalSystem);
    currentConfig = aodHandles.CurrentConfiguration;
    
    % Check for all configurations
    for config = 1:nConfig
        aodHandles.CurrentConfiguration  = config;
        currentOpticalSystem = aodHandles.OpticalSystem(config);
        
        % Change the current configuration index temporarly
        
        % Condition 1 & 2: If object is at infinity, object NA is not defined and
        % object height can not be used for field
        objThickness = currentOpticalSystem.SurfaceArray(1).Thickness;
        tempFieldType = currentOpticalSystem.FieldType;
        tempSystemApertureType = currentOpticalSystem.SystemApertureType;
        tempSystemApertureValue = currentOpticalSystem.SystemApertureValue;
        
        if abs(objThickness) > 10^10
            if tempFieldType == 1 %'ObjectHeight'
                mm = mm + 1;
                message{mm} = (['For objects at infinity, object height can not be',...
                    ' used as field please correct. By default the object will',...
                    ' be placed at finite distance']);
                currentOpticalSystem.SurfaceArray(1).Thickness = 10;
                currentOpticalSystem.OpticalElementArray{1}.Thickness = 10;
                isValid(mm) = 0;
            end
            if tempSystemApertureType == 2% 'OBNA'
                mm = mm + 1;
                message{mm} = (['For objects at infinity, object space NA can not',...
                    ' be used as system aperture. Please correct.By default the',...
                    ' object will be placed at finite distance']);
                currentOpticalSystem.SurfaceArray(1).Thickness = 10;
                currentOpticalSystem.OpticalElementArray{1}.Thickness = 10;
                isValid(mm) = 0;
            end
        else
            
        end
        
        % Condition 3: There should always be a stop surface
        %         [stopIndex, specified] = getStopElementIndex(aodHandles.OpticalSystem(config).OpticalElementArray);
        
        elementArray = aodHandles.OpticalSystem(config).OpticalElementArray;
        [stopElementIndex,stopSurfaceIndex,specified,nElement] = getStopElementIndex(elementArray);
        if ~specified
            % No stop defined
            mm = mm + 1;
            message{mm} = (['No stop is defined for your system. By default the ',...
                'first surface next to object will be assigned as stop.']);
                currentOpticalSystem.SurfaceArray(2).StopSurfaceIndex = 1;
                currentOpticalSystem.OpticalElementArray(2).StopSurfaceIndex = 1;
            isValid(mm) = 0;
        end
        
        
        % Condition 4: Is the system aperture is defined as float by stop then
        % the stop surface aperture can not be flaoting. Rather it should be
        % circular (fixed)
        tempSystemApertureType = currentOpticalSystem.SystemApertureType;
        [ supportedSystemApertureTypes ] = getSupportedSystemApertureTypes();
        [isMember,floatByStopSize] = ismember('FloatByStopSize',supportedSystemApertureTypes);
        
        [stopIndex, specified] = getStopSurfaceIndex(currentOpticalSystem);
        if tempSystemApertureType == floatByStopSize
            stopElement = currentOpticalSystem.OpticalElementArray{stopElementIndex};
            if ~isSurface(stopElement)
                
            elseif stopElement.Aperture.Type == 1
                mm = mm + 1;
                message{mm} = (['When the system aperture is defined as float by stop, ',...
                    'the stop surface aperture can not be flaoting. So the stop',...
                    ' surface aperture is changed to Circular aperture']);
                oldAperture = stopElement.Aperture;
                diam = oldAperture.UniqueParameters.Diameter;
                apertDecenter = oldAperture.Decenter;
                apertRotInDeg = oldAperture.Rotation;
                drawAbsolute = oldAperture.DrawAbsolute;
                outerShape = oldAperture.OuterShape;
                additionalEdge = oldAperture.AdditionalEdge;
                
                newCircularAperture = Aperture('CircularAperture');
                newCircularAperture.UniqueParameters.SmallDiameter = 0;
                newCircularAperture.UniqueParameters.LargeDiameter = diam;
                newCircularAperture.Decenter = apertDecenter;
                newCircularAperture.Rotation = apertRotInDeg;
                newCircularAperture.DrawAbsolute = drawAbsolute;
                newCircularAperture.OuterShape = outerShape;
                newCircularAperture.AdditionalEdge = additionalEdge;
                
                stopElement.Aperture = newCircularAperture;
                currentOpticalSystem.OpticalElementArray{stopElementIndex} = stopElement;
                isValid(mm) = 0;
            else
            end
        end
        
        % Condition 5 - 8: Check for existance and validity of catalogue files. Remove all
        % invalid catalogues from the catalogue list table
        
        % Coating Catalogue
        coatingCatalogueList = currentOpticalSystem.CoatingCataloguesList;
        if ~isempty(coatingCatalogueList)
            invalidCoatingCat = [];
            for cc = 1:size(coatingCatalogueList,1)
                coatingCatFullName = coatingCatalogueList{cc};
                [ valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames] = isValidObjectCatalogue('coating', coatingCatFullName);
                if ~valid && isempty(relatedCatalogueFullFileNames)
                    invalidCoatingCat = [invalidCoatingCat,cc];
                end
            end
            if isempty(invalidCoatingCat)
                
            else
                mm = mm + 1;
                message{mm} = 'Error: Some Invalid Coating catalogue found. So they are just removed.';
                isValid(mm) = 0;
                
                coatingCatalogueList(invalidCoatingCat) = [];
                currentOpticalSystem.CoatingCataloguesList = coatingCatalogueList;
            end
        else
            mm = mm + 1;
            message{mm} = 'Error: No Coating catalogue found. So an empty Coating catalogue is created.';
            isValid(mm) = 0;
            
            parentWindow.ParentHandles = aodHandles;
            addCoatingCatalogue(parentWindow);
            aodHandles = parentWindow.ParentHandles;
        end
        
        % Glass Catalogue
        glassCatalogueList = currentOpticalSystem.GlassCataloguesList;
        if ~isempty(glassCatalogueList)
            invalidGlassCat = [];
            for gg = 1:size(glassCatalogueList,1)
                glassCatFullName = glassCatalogueList{gg};
                [ valid, fileInfoStruct, dispMsg,relatedCatalogueFullFileNames] = isValidObjectCatalogue('glass', glassCatFullName);
                if ~valid && isempty(relatedCatalogueFullFileNames)
                    invalidGlassCat = [invalidGlassCat,gg];
                end
            end
            if isempty(invalidGlassCat)
                
            else
                mm = mm + 1;
                message{mm} = 'Error: Some Invalid Glass catalogue found. So they are just removed.';
                isValid(mm) = 0;
                
                glassCatalogueList(invalidGlassCat) = [];
                currentOpticalSystem.GlassCataloguesList = glassCatalogueList;
            end
        else
            mm = mm + 1;
            message{mm} = 'Error: No Glass catalogue found. So an empty Glass catalogue is created.';
            isValid(mm) = 0;
            
            parentWindow.ParentHandles = aodHandles;
            addGlassCatalogue(parentWindow);
            aodHandles = parentWindow.ParentHandles;
        end
    end
    
    aodHandles.OpticalSystem(config) = currentOpticalSystem;
    % Change the current configuration index back to the original
    aodHandles.CurrentConfiguration = currentConfig;
    
    parentWindow.ParentHandles = aodHandles;
    if sum(isValid) < mm
        validSystem = 0;
    else
        validSystem = 1;
        message = 'Success Valid System!!';
    end
end

