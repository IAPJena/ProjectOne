function updateSystemConfigurationWindow( parentWindow )
    %UPDATESYSTEMCONFIGURATIONWINDOW Updates the system configuration
    %window
    
    aodHandles = parentWindow.ParentHandles;
    [ currentOpticalSystem,saved] = getCurrentOpticalSystem (parentWindow);
    
    %aperture data
    if isnumeric(currentOpticalSystem.SystemApertureType)
        systemApertureTypeIndex = currentOpticalSystem.SystemApertureType;
    else
        switch upper(currentOpticalSystem.SystemApertureType)
            case 'ENPD'
                systemApertureTypeIndex = 1;
            case 'OBNA'
                systemApertureTypeIndex = 2;
            case  'OBFN'
                systemApertureTypeIndex = 3;
            case 'IMNA'
                systemApertureTypeIndex = 4;
            case 'IMFN'
                systemApertureTypeIndex = 5;
        end
    end
    set(aodHandles.popApertureType,'Value',systemApertureTypeIndex);
    set(aodHandles.txtApertureValue,'String',currentOpticalSystem.SystemApertureValue);
    
    %general data
    set(aodHandles.txtLensName,'String',currentOpticalSystem.LensName);
    set(aodHandles.txtLensNote,'String',currentOpticalSystem.LensNote);

    lensUnitIndex = currentOpticalSystem.LensUnit;
    set(aodHandles.popLensUnit,'Value',lensUnitIndex);
    
    wavelengthUnitIndex = currentOpticalSystem.WavelengthUnit;
    set(aodHandles.popWavelengthUnit,'Value',wavelengthUnitIndex);

    systemDefinitionTypeIndex = currentOpticalSystem.SystemDefinitionType;
    set(aodHandles.popSystemDefinitionType,'Value',systemDefinitionTypeIndex);
    
    %wavelength data
    set(aodHandles.txtTotalWavelengthsSelected,'String',getNumberOfWavelengths(currentOpticalSystem))
    set(aodHandles.popPrimaryWavlenIndex,'String',num2cell(1:getNumberOfWavelengths(currentOpticalSystem)));
    set(aodHandles.popPrimaryWavlenIndex,'Value',currentOpticalSystem.PrimaryWavelengthIndex);
    
    newTable1 = currentOpticalSystem.WavelengthMatrix;
    % add a column for 'selected' and last row which is not selected (if
    % not already there in the WavelengthMatrix)
    if size(newTable1,2) < 3
        newTable1 =  [ones(size(newTable1,1),1),newTable1];
    end
    if newTable1(end,1) == 1
        newTable1 = [newTable1;0,0.55,1];
    end
    newTable1 = mat2cell(newTable1,[ones(1,size(newTable1,1))],[ones(1,size(newTable1,2))]);
    for p = 1:size(newTable1,1)
        newTable1{p,1} = logical(newTable1{p,1});
    end
    set(aodHandles.tblWavelengths, 'Data', newTable1);
    
    % field data
    set(aodHandles.txtTotalFieldPointsSelected,'String',getNumberOfFieldPoints(currentOpticalSystem));
    set(aodHandles.popFieldType,'Value',currentOpticalSystem.FieldType);
    
    %
    fieldNormalizationIndex = currentOpticalSystem.FieldNormalization;
    
    if fieldNormalizationIndex > 2
                disp(['Error: Unsupported Field Normalization ',...
            only 2 field normalization types are supported currently.']);
        return;
    end
    set(aodHandles.popFieldNormalization,'Value',fieldNormalizationIndex);
  
    newTable2 = currentOpticalSystem.FieldPointMatrix;
    % add a column for 'selected' and last row which is not selected (if
    % not already there in the WavelengthMatrix)
    if size(newTable2,2) < 4
        newTable2 =  [ones(size(newTable2,1),1),newTable2];
    end
    if newTable2(end,1) == 1
        newTable2 = [newTable2;0,0,0,1];
    end
    newTable2 = mat2cell(newTable2,[ones(1,size(newTable2,1))],[ones(1,size(newTable2,2))]);
    for p = 1:size(newTable2,1)
        newTable2{p,1} = logical(newTable2{p,1});
    end
    set(aodHandles.tblFieldPoints, 'Data', newTable2);
    
    if isprop(currentOpticalSystem,'CoatingCataloguesList')
        % Coating Catalogue
        newTable3 = currentOpticalSystem.CoatingCataloguesList;
        if isempty(newTable3)
            newTable3 = getAllObjectCatalogues('coating');
        end
        % update the path name of each catalogues
        for k = 1: size(newTable3,1)
            catalofueFullFileName = newTable3{k,:};
            addCoatingCatalogue(parentWindow,catalofueFullFileName);
        end
    end
    
    if isprop(currentOpticalSystem,'GlassCataloguesList')
        % glass Catalogue
        newTable3 = currentOpticalSystem.GlassCataloguesList;
        if isempty(newTable3)
            newTable3 = getAllObjectCatalogues('glass');
        end
        % update the path name of each catalogues
        for k = 1: size(newTable3,1)
            catalofueFullFileName = newTable3{k,:};
            addGlassCatalogue(parentWindow,catalofueFullFileName);
        end
    end
    
    % Pupil Apodization data
    apodTypeIndex = currentOpticalSystem.ApodizationType;
    set(aodHandles.popApodizationType,'Value',apodTypeIndex);
            switch apodTypeIndex
            case 1 % ('None')
                set(aodHandles.panelSuperGaussParameters,'Visible','off');
                set(get(aodHandles.panelSuperGaussParameters,'Children'),'Visible','off');
                set(aodHandles.popApodizationType,'Value',1);
            case 2 %('Super Gaussian')
                set(aodHandles.panelSuperGaussParameters,'Visible','on');
                set(get(aodHandles.panelSuperGaussParameters,'Children'),'Visible','on');
                set(aodHandles.popApodizationType,'Value',2);
                
                apodParam = currentOpticalSystem.ApodizationParameters;
                set(aodHandles.txtApodMaximumIntensity,'String',...
                    num2str(apodParam.MaximumIntensity));
                set(aodHandles.txtApodOrder,'String',num2str(apodParam.Order));
                set(aodHandles.txtApodBeamRadius,'String',num2str(apodParam.BeamRadius));
            end
    aodHandles.OpticalSystem = currentOpticalSystem;
    parentWindow.ParentHandles = aodHandles;
end

