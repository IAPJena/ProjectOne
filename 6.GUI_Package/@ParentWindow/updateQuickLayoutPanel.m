function  updateQuickLayoutPanel(parentWindow,selectedElementIndex)
    % Updates the quick system layout and the paraxial parameters in task
    % bar.
    
    % Quick system layout
    aodHandles = parentWindow.ParentHandles;
    updatedSystem = aodHandles.OpticalSystem;
    set(aodHandles.popQuickWavelengthIndex,...
        'String', ['All',num2cell([1:1:getNumberOfWavelengths(updatedSystem)])]);
    set(aodHandles.popQuickFieldIndex,...
        'String', ['All',num2cell([1:1:getNumberOfFieldPoints(updatedSystem)])]);
    if get(aodHandles.popQuickWavelengthIndex,'Value') > getNumberOfWavelengths(updatedSystem)+1
        set(aodHandles.popQuickWavelengthIndex,'Value',getNumberOfWavelengths(updatedSystem)+1)
    end
    if get(aodHandles.popQuickFieldIndex,'Value') > getNumberOfFieldPoints(updatedSystem)+1
        set(aodHandles.popQuickFieldIndex,'Value',getNumberOfFieldPoints(updatedSystem)+1)
    end
    layoutType = get(aodHandles.popQuickLayoutType,'Value'); % 1 : None, 2: System 3: system or component
    layoutDim = get(aodHandles.popQuickLayoutDimension,'Value'); % 1 : 2D, 2: 3D
    plotIn2D = 0;
    axesHandle = aodHandles.axesQuickLayout;
    cla(axesHandle,'reset');
    [ updatedSystem,saved] = getCurrentOpticalSystem (parentWindow);
    switch layoutType
        case 1
            % Do nothing just disable setting controls
            handleArray1 = [aodHandles.popQuickLayoutDimension,...
                aodHandles.popQuickPupilSamplingType,...
                aodHandles.popQuickNumberOfRay1,...
                aodHandles.popQuickNumberOfRay2,...
                aodHandles.popQuickWavelengthIndex,...
                aodHandles.popQuickFieldIndex];
            % Set them all disabled.
            set(handleArray1, 'Enable', 'off');
            set(axesHandle, 'Visible', 'off');
            
            
        case 2
            % Enable setting controls
            handleArray1 = [aodHandles.popQuickLayoutDimension,...
                aodHandles.popQuickPupilSamplingType,...
                aodHandles.popQuickNumberOfRay1,...
                aodHandles.popQuickNumberOfRay2,...
                aodHandles.popQuickWavelengthIndex,...
                aodHandles.popQuickFieldIndex];
            % Set them all disabled.
            set(handleArray1, 'Enable', 'on');
            % plot the system layout
            set(axesHandle,'Visible','on');
            if layoutDim == 1 % 2D
                plotIn2D = 1;
                set(aodHandles.popQuickNumberOfRay1,'value',1,'enable','off');
                [~,tangentialSamplingIndex] = ismember('Tangential',GetSupportedPupilSamplingTypes);
                set(aodHandles.popQuickPupilSamplingType,'value',tangentialSamplingIndex,'enable','off');
            else
                
            end
            % To Plot rays over the layout
            wavLengthIndexList = (get(aodHandles.popQuickWavelengthIndex,'String'));
            wavLengthIndexString = (wavLengthIndexList(get(aodHandles.popQuickWavelengthIndex,'Value'),:));
            if strcmpi(wavLengthIndexString,'New Wavelength')
            elseif strcmpi(wavLengthIndexString,'All')
                wavelengthIndices = 1:1:getNumberOfWavelengths(updatedSystem);
            else
                wavelengthIndices = str2double(wavLengthIndexString);
            end
            
            fldIndexList = (get(aodHandles.popQuickFieldIndex,'String'));
            fldIndexString = (fldIndexList(get(aodHandles.popQuickFieldIndex,'Value'),:));
            if strcmpi(fldIndexString,'All')
                fieldIndices = 1:1:getNumberOfFieldPoints(updatedSystem);
            else
                fieldIndices = str2double(fldIndexString);
            end
            
            PupSamplingType = get(aodHandles.popQuickPupilSamplingType,'Value');
            nRay1List = (get(aodHandles.popQuickNumberOfRay1,'String'));
            nRay1 = str2double(nRay1List{get(aodHandles.popQuickNumberOfRay1,'Value')});
            nRay2List = (get(aodHandles.popQuickNumberOfRay2,'String'));
            nRay2 = str2double(nRay2List{get(aodHandles.popQuickNumberOfRay2,'Value')});
            
            rayPathMatrix = computeRayPathMatrix(updatedSystem,...
                wavelengthIndices,fieldIndices,PupSamplingType,nRay1,nRay2);
            % Plot sytem lyout
            plotSystemLayout( updatedSystem,rayPathMatrix,...
                plotIn2D,axesHandle);
        case 3
            % Enable setting controls
            handleArray1 = [aodHandles.popQuickLayoutDimension,...
                aodHandles.popQuickPupilSamplingType,...
                aodHandles.popQuickNumberOfRay1,...
                aodHandles.popQuickNumberOfRay2,...
                aodHandles.popQuickWavelengthIndex,...
                aodHandles.popQuickFieldIndex];
            % Set them all disabled.
            set(handleArray1, 'Enable', 'on');
            % plot the system layout
            set(axesHandle,'Visible','on');
            % plot the component or surface layout
            if layoutDim == 1
                plotIn2D = 1;
                set(aodHandles.popQuickNumberOfRay1,'value',1,'enable','off');
                [~,tangentialSamplingIndex] = ismember('Tangential',GetSupportedPupilSamplingTypes);
                set(aodHandles.popQuickPupilSamplingType,'value',tangentialSamplingIndex,'enable','off');
            end
            nPoints1 = 'default';
            nPoints2 = 'default';
            drawEdge = 1;
            
            surfaceArrayIndices = updatedSystem.ElementToSurfaceMap{selectedElementIndex};
            surfaceArray = updatedSystem.SurfaceArray(surfaceArrayIndices);
            
            if ~isempty(surfaceArray)
                drawSurfaceArray...
                    (surfaceArray,plotIn2D,nPoints1,nPoints2,...
                    axesHandle,drawEdge);
            end
            axis equal;
    end
    
    % Quick system paraxial properties
    totalTrack = getTotalTrack(updatedSystem);
    effl = getEffectiveFocalLength(updatedSystem);
    angMag = getAngularMagnification(updatedSystem);
    objNA = getObjectNA(updatedSystem);
    imageNA = getImageNA(updatedSystem);
    
    set(aodHandles.lblTaskBar(1),'String',['System Total Track : ',num2str(totalTrack)]);
    set(aodHandles.lblTaskBar(2),'String',['Effective Focal Length : ',num2str(effl)]);
    set(aodHandles.lblTaskBar(3),'String',['Angular Magnification : ',num2str(angMag)]);
    set(aodHandles.lblTaskBar(4),'String',['Object Space NA : ',num2str(objNA)]);
    set(aodHandles.lblTaskBar(5),'String',['Image Space NA : ',num2str(imageNA)]);
end

