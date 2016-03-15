function btnOkCallback(childWindow,parentWindow)
    % btnOkCallback: Define  the callback actions associated with the button
    % click event of the OK button of the child window.
    % Click event of Ok button of all child windows is defined here in a single
    % function to avoid repeated codes for similar actions in different child
    % windows.
    % Specific actions which are unique for each child window type are
    % placed in switch case statemmtns.
    % Member of ChildWindow class
    
    figure(childWindow.ChildHandles.FigureHandle);
    % Click graph tab programatically
    set(childWindow.ChildHandles.mainTabGroup,'SelectedTab',...
        childWindow.ChildHandles.GraphTab);
    try
        cla(childWindow.ChildHandles.axesHandle);
    catch
        
    end
    % performs d/t actions based on myName
    handles = childWindow.ChildHandles;
    [ optSystem,saved] = getCurrentOpticalSystem(parentWindow,0) ;
    currentConfiguration = parentWindow.ParentHandles.CurrentConfiguration;
    % Group Similar windows
    coatingPropertyVsWavelength = ...
        {  'coatingDiattenuationVsWavelength',...
        'coatingReflectionVsWavelength',...
        'coatingRetardanceVsWavelength',...
        'coatingTransmissionVsWavelength'};
    
    coatingPropertyVsAngle = ...
        {   'coatingDiattenuationVsAngle',...
        'coatingReflectionVsAngle',...
        'coatingRetardanceVsAngle',...
        'coatingTransmissionVsAngle'};
    gridRaytraceAnalysis = ...
        {'amplitudeTransmissionMap',...
        'phaseMap',...
        'wavefrontDiattenuationMap',...
        'wavefrontRetardanceMap',...
        'wavefrontAtExitPupil',...
        'polarizationEllipseMap',...
        'FFTPSF'};
    rayTracingAnalysis = ...
        {'scalarRayTrace',...
        'polarizationRayTrace'};
    others = ...
        { 'coatingRefractiveIndexProfile',...
        'footprintDiagram',...
        'spotDiagramPlus',...
        'system2DLayoutDiagram',...
        'system3DLayoutDiagram',...
        'paraxialAnalysis',...
        'pupilApodization',...
        'transverseRayAberration',...
        'KostenbauderMatrix',...        % pulse analysis
        'GDDVsWavelength',...
        'SpatialChirpVsWavelength',...
        'AngularDispersionVsWavelength',...
        'GaussianPulsePropagation',...
        'PulseFrontEvolutionGeometric',...
        'FFTFocusedPulse'};
    
    switch lower(handles.Name)
        case lower(coatingPropertyVsWavelength)
            optSystem = optSystem(currentConfiguration);
            % Check for inputs whether to take coating from a
            % given surface or use new coating
            
            surfIndexList = (get(handles.popSurfaceIndex,'String'));
            surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'),:);
            surfIndex = str2double(surfIndexString);
            if strcmpi(surfIndexString,'New Coating')
                % Read coating object from Coating Catalogue
                name = get(handles.txtCoatingName,'String');
                catalogueList = optSystem.CoatingCataloguesList;
                caotingFound = 0;
                for k = 1:size(catalogueList,1)
                    catalogueName = catalogueList{k};
                    myCoating = extractObjectFromObjectCatalogue...
                        ('coating', name,catalogueName );
                    if strcmpi(class(myCoating),'Coating')
                        caotingFound = 1;
                        break;
                    end
                end
                if ~caotingFound
                    disp('Coating not found');
                    return;
                end
                
                % User inputs the refractive indices before and
                % after the coating
                refIndices_primWavLen = inputdlg({'Index before coating',...
                    'Index after coating','Primary Wavelength in (um)'},...
                    'Refractive Indices And Primary Wavelength');
                if ~(isempty(refIndices_primWavLen)||...
                        isempty(refIndices_primWavLen{1})||...
                        isempty(refIndices_primWavLen{2})||...
                        isempty(refIndices_primWavLen{3}))
                    indexBefore = str2double(refIndices_primWavLen{1});
                    indexAfter = str2double(refIndices_primWavLen{2});
                    primWavLenInUm = str2double(refIndices_primWavLen{3});
                    if isnan(indexBefore)||isnan(indexAfter)
                        disp('Error: Input refractive indices should be numeric.');
                        return;
                    end
                else
                    disp('Error: No refractive indices entered.');
                    return;
                end
            elseif ~isnan(surfIndex)
                % Read the coating from the surface index
                myCoating = optSystem.SurfaceArray...
                    (surfIndex).Coating;
                % Read the refractive indices for medium before and
                % after coating using the primary wavelength
                primaryWavelength = getPrimaryWavelength(optSystem);
                primWavLenInUm = primaryWavelength*10^6;
                if surfIndex > 1
                    indexBefore = getRefractiveIndex(...
                        optSystem.SurfaceArray(surfIndex-1).Glass,...
                        primaryWavelength);
                else
                    indexBefore = 1;
                end
                indexAfter = getRefractiveIndex(...
                    optSystem.SurfaceArray(surfIndex).Glass,...
                    primaryWavelength);
            else
                disp(['Error: The surface index should be either '...
                    'valid surface number of New Caoting']);
                return;
            end
            
            incAngle = str2double(get(handles.txtIncidenceAngle,'String'));
            % Replace 0 incedence angle with very small value
            % inorder to avoid numberical error of dividing by
            % zero in anycase.
            if abs(incAngle) < 10^-4
                if incAngle < 0
                    incAngle = -10^-4;
                else
                    incAngle = 10^-4;
                end
            end
            minWavelength = str2double(get(handles.txtMinWavelength,'String'));
            maxWavelength = str2double(get(handles.txtMaxWavelength,'String'));
            wavelengthStep = str2double(get(handles.txtWavelengthStep,'String'));
            
            switch lower(handles.Name)
                case lower('coatingDiattenuationVsWavelength')
                    plotCoatingDiattenuationVsWavelength(myCoating,...
                        incAngle,minWavelength, maxWavelength, wavelengthStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingReflectionVsWavelength')
                    plotCoatingReflectionVsWavelength(myCoating,...
                        incAngle,minWavelength, maxWavelength, wavelengthStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingRetardanceVsWavelength')
                    plotCoatingRetardanceVsWavelength(myCoating,...
                        incAngle,minWavelength, maxWavelength, wavelengthStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingTransmissionVsWavelength')
                    plotCoatingTransmissionVsWavelength(myCoating,...
                        incAngle,minWavelength, maxWavelength, wavelengthStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
            end
        case lower(coatingPropertyVsAngle)
            optSystem = optSystem(currentConfiguration);
            % Check for inputs whether to take coating from a
            % given surface or use new coating
            surfIndexList = (get(handles.popSurfaceIndex,'String'));
            surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'),:);
            surfIndex = str2double(surfIndexString);
            if strcmpi(surfIndexString,'New Coating')
                % Read coating object from Coating Catalogue
                name = get(handles.txtCoatingName,'String');
                catalogueList = optSystem.CoatingCataloguesList;
                caotingFound = 0;
                for k = 1:size(catalogueList,1)
                    catalogueName = catalogueList{k};
                    myCoating = extractObjectFromObjectCatalogue...
                        ('coating', name,catalogueName );
                    if strcmpi(class(myCoating),'Coating')
                        caotingFound = 1;
                        break;
                    end
                end
                if ~caotingFound
                    disp('Coating not found');
                    return;
                end
                % User inputs the refractive indices before and
                % after the coating
                refIndices_primWavLen = inputdlg({'Index before coating',...
                    'Index after coating','Primary Wavelength in (um)'},...
                    'Refractive Indices And Primary Wavelength');
                if ~(isempty(refIndices_primWavLen)||...
                        isempty(refIndices_primWavLen{1})||...
                        isempty(refIndices_primWavLen{2})||...
                        isempty(refIndices_primWavLen{3}))
                    indexBefore = str2double(refIndices_primWavLen{1});
                    indexAfter = str2double(refIndices_primWavLen{2});
                    primWavLenInUm = str2double(refIndices_primWavLen{3});
                    if isnan(indexBefore)||isnan(indexAfter)
                        disp('Error: Input refractive indices should be numeric.');
                        return;
                    end
                else
                    disp('Error: No refractive indices entered.');
                    return;
                end
            elseif ~isnan(surfIndex)
                % Read the coating from the surface index
                myCoating = optSystem.SurfaceArray...
                    (surfIndex).Coating;
                % Read the refractive indices for medium before and
                % after coating using the given wavelength
                wavLenInUm = str2double(get(handles.txtWavelength,'String'));
                primaryWavelength = getPrimaryWavelength(optSystem);
                primWavLenInUm = primaryWavelength*10^6;
                if surfIndex > 1
                    indexBefore = getRefractiveIndex(...
                        optSystem.SurfaceArray(surfIndex-1).Glass,wavLenInUm);
                else
                    indexBefore = 1;
                end
                indexAfter = getRefractiveIndex(...
                    optSystem.SurfaceArray(surfIndex).Glass,wavLenInUm);
            else
                disp(['Error: The surface index should be either '...
                    'valid surface number or New Caoting']);
                return;
            end
            
            wavLenInUm = str2double(get(handles.txtWavelength,'String'));
            minAngle = str2double(get(handles.txtMinAngle,'String'));
            maxAngle = str2double(get(handles.txtMaxAngle,'String'));
            angleStep = str2double(get(handles.txtAngleStep,'String'));
            
            switch lower(handles.Name)
                case lower('coatingDiattenuationVsAngle')
                    plotCoatingDiattenuationVsAngle(myCoating,...
                        wavLenInUm,minAngle,maxAngle,angleStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingReflectionVsAngle')
                    plotCoatingReflectionVsAngle(myCoating,...
                        wavLenInUm,minAngle,maxAngle,angleStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingRetardanceVsAngle')
                    plotCoatingRetardanceVsAngle(myCoating,...
                        wavLenInUm,minAngle,maxAngle,angleStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('coatingTransmissionVsAngle')
                    plotCoatingTransmissionVsAngle(myCoating,...
                        wavLenInUm,minAngle,maxAngle,angleStep,...
                        primWavLenInUm,indexBefore,indexAfter,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
            end
        case lower(gridRaytraceAnalysis)
            optSystem = optSystem(currentConfiguration);
            
            surfIndexList = (get(handles.popSurfaceIndex,'String'));
            surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'),:);
            surfIndex = str2double(surfIndexString);
            if isnan(surfIndex)
                disp('The surface index should be valid index number');
                return;
            end
            
            wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
            wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
            if strcmpi(wavLengthIndexString,'New Wavelength')
            elseif strcmpi(wavLengthIndexString,'All')
                wavIndex = 1:1:getNumberOfWavelengths(optSystem);
            else
                wavIndex = str2double(wavLengthIndexString);
            end
            
            fldIndexList = (get(handles.popFieldIndex,'String'));
            fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
            if strcmpi(fldIndexString,'All')
                fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
            else
                fldIndex = str2double(fldIndexString);
            end

            % 1: Cartesian 2: Polar Grid 3: Hexagonal
            % 4: Isoenergetic Circular 5: Tangential Plane 6: Sagittal Plane 7:Random
            
            % Grid size is seq of odd numbers
            gridSizeList = (get(handles.popPupilGridSize,'String'));
            gridSize = (gridSizeList{get(handles.popPupilGridSize,'Value'),:});
            
            sampleGridSizeX = str2double(gridSize(1:findstr(gridSize,'x')-1));
            sampleGridSizeY = str2double(gridSize(findstr(gridSize,'x')+1:end));
            sampleGridSize = max([sampleGridSizeX,sampleGridSizeY]);
            
            
            switch lower(handles.Name)
                case lower('amplitudeTransmissionMap')
                    plotAmplitudeTransmissionMap...
                        (optSystem,surfIndex,wavIndex,fldIndex,...
                        sampleGridSize,handles.GraphTab);
                case lower('phaseMap')
                    plotPhaseMap...
                        (optSystem,surfIndex,wavIndex,fldIndex,...
                        sampleGridSize,handles.GraphTab);
                case lower('wavefrontDiattenuationMap')
                    plotWavefrontDiattenuationMap...
                        (optSystem,surfIndex,wavIndex,fldIndex,...
                        sampleGridSize,handles.GraphTab);
                case lower('wavefrontRetardanceMap')
                    plotWavefrontRetardanceMap...
                        (optSystem,surfIndex,wavIndex,fldIndex,...
                        sampleGridSize,handles.GraphTab) ;
                    
                case lower('polarizationEllipseMap')
                    % Read initial polarization state for pupil
                    % polarization map
                    
                    % Read initial polarization state for polarization ray
                    % trace
                    [polarizationProfileType,polarizationProfileParameters] = readPolarizationProfileParameters(handles);
                    plotPupilPolarizationEllipseMap...
                        (optSystem,surfIndex,wavIndex,fldIndex,...
                        sampleGridSize,polarizationProfileType,polarizationProfileParameters,handles.GraphTab) ;
                case lower('wavefrontAtExitPupil')
                    % read zernike coefiicient number popup
                    zerCoeffList = (get(handles.popZernikeCoefficientNumber,'String'));
                    zerCoeffString = (zerCoeffList(get(handles.popZernikeCoefficientNumber,'Value'),:));
                    zerCoeff = str2double(zerCoeffString);
                    
                    plotWavefrontAtExitPupil(optSystem,wavIndex,fldIndex,...
                        sampleGridSize,zerCoeff,...
                        handles.GraphTab,handles.textHandle) ;
                case lower('FFTPSF')
                    spotPlotRadius = str2double(...
                        get(handles.txtPSFPlotRadius,'String'));
                    
                    plotFFTPointSpreadFunction(optSystem,wavIndex,fldIndex,...
                        sampleGridSize,spotPlotRadius,...
                        handles.GraphTab,handles.textHandle) ;
            end
        case lower(rayTracingAnalysis)
            optSystem = optSystem(currentConfiguration);
            
            % Read Hx,Hy,Px,Py and Wavelegth
            Hx = str2double(get(handles.txtHx,'String'));
            Hy = str2double(get(handles.txtHy,'String'));
            Px = str2double(get(handles.txtPx,'String'));
            Py = str2double(get(handles.txtPy,'String'));
            wavLen = str2double(get(handles.txtWavelength,'String'));
            showInTabular = get(handles.chkShowInTabular,'Value');
            % Compute Initial Direction and Position
            [rayPosition,rayDirection] = computeRayParametersFromNormalizedCoordiantes...
                (optSystem,Hx,Hy,Px,Py);
            rayPositionInSI = rayPosition*getLensUnitFactor(optSystem);
            
            switch lower(handles.Name)
                case lower('scalarRayTrace')
                    considerPolarization = 0;
                    jonesVector = [NaN;NaN];
                    newRay = ScalarRayBundle;
                    newRay.Direction = rayDirection;
                    newRay.Position = rayPositionInSI;
                    
                    % Wavelength should be in m for ray objects
                    wavLenInMeter = wavLen*getWavelengthUnitFactor(optSystem);
                    newRay.Wavelength = wavLenInMeter;
                case lower('polarizationRayTrace')
                    considerPolarization = 1;
                    % Read initial polarization state for polarization ray
                    % trace
                    [polarizationProfileType,polarizationProfileParameters] = readPolarizationProfileParameters(handles);
                    newRay = ScalarRayBundle;
                    newRay.Direction = rayDirection;
                    newRay.Position = rayPositionInSI;
                    
                    % Connect the polarization definition function
                    polarizationDefinitionHandle = str2func(getSupportedPolarizationProfiles(polarizationProfileType));
                    returnFlag = 2; %
                    inputDataStruct = struct;
                    inputDataStruct.xMesh = newRay.Position(1);
                    inputDataStruct.yMesh = newRay.Position(2);
                    [ returnDataStruct ] = polarizationDefinitionHandle(returnFlag,polarizationProfileParameters,inputDataStruct);
                    jonesVectorNew = squeeze(returnDataStruct.JonesVector);
                    coordinate = returnDataStruct.CoordinateSystem;
                    
                    % Convert the Jones vector to the polarizationVector in
                    % XYZ global coordinate
                    if strcmpi(coordinate,'SP')
                        jonesVectorSP = (jonesVectorNew);
                        initialPolVectorXYZ = convertJVToPolVector...
                            (jonesVectorSP,rayDirection);
                    elseif strcmpi(coordinate,'XY')
                        % From dispersion relation the Z component of field can be
                        % computed from the x and y components in linear
                        % isotropic media+
                        kx = rayDirection(1,:);
                        ky = rayDirection(2,:);
                        kz = rayDirection(3,:);
                        
                        if size(jonesVectorNew,2) == 1
                            jonesVectorNew = jonesVectorNew*ones(1,nRay);
                        end
                        fieldEx = jonesVectorNew(1,:);
                        fieldEy = jonesVectorNew(2,:);
                        
                        fieldEz = - (kx.*fieldEx + ky.*fieldEy)./(kz);
                        
                        initialPolVectorXYZ = [fieldEx;fieldEy;fieldEz];
                    else
                        
                    end
                    
                    % Wavelength should be in m for ray objects
                    wavLenInMeter = wavLen*getWavelengthUnitFactor(optSystem);
                    newRay.Wavelength = wavLenInMeter;
            end
            
            rayTraceOptionStruct = RayTraceOptionStruct();
            rayTraceOptionStruct.ConsiderPolarization = considerPolarization;
            rayTraceOptionStruct.RecordIntermediateResults = 1;
            rayTraceOptionStruct.ConsiderSurfAperture = 1;
            
            rayTracerResult = rayTracer(optSystem,newRay,rayTraceOptionStruct);
            
            % Display results based on the type of raytrace
            nSurf = getNumberOfNonDummySurfaces(optSystem);
            [ lensUnitFactor,lensUnitText ] = getLensUnitFactor(optSystem);
            [ wavUnitFactor, wavUnitText] = getWavelengthUnitFactor(optSystem);
            %             stopIndex = getStopSurfaceIndex(optSystem);
            
            switch lower(handles.Name)
                case lower('scalarRayTrace')
                    if isempty(rayTracerResult)
                        msgbox 'Ray trace failed. Look the command window for detail error.';
                        return;
                    else
                        rayTraceResultText = ...
                            ['-------------------------------------',...
                            '--------------------------------------'];
                        rayTraceResultText = char(rayTraceResultText,...
                            ['<<<<<<<<<<<<<<<<<<<<<<<< ',...
                            'Scalar Ray Trace Results ',...
                            '>>>>>>>>>>>>>>>>>>>>>>>>>']);
                        rayTraceResultText = char(rayTraceResultText,...
                            ['-------------------------------------',...
                            '--------------------------------------'],...
                            ['Normalized X Field Coord(Hx) = ',num2str(Hx)],...
                            ['Normalized Y Field Coord(Hy) = ',num2str(Hy)],...
                            ['Normalized X Pupil Coord(Px) = ',num2str(Px)],...
                            ['Normalized Y Pupil Coord(Py) = ',num2str(Py)],...
                            ['Wavelength = ',num2str(wavLen)],...
                            ['Wavelength Unit = ',wavUnitText],...
                            ['Lens Unit = ',lensUnitText],...
                            ['Reference coordinate is the first surface of the optical system.'],...
                            ['Direction cosines are after refraction or reflection on the given surface.']);
                        
                        % Now Make the output in tabular and
                        % surface-by-surface sequential format
                        rayTraceResultTabularText = rayTraceResultText;
                        rayTraceResultSeqText = rayTraceResultText;
                        
                        if showInTabular
                            rayTraceResultTabularText = char(rayTraceResultTabularText,...
                                ['--------------------------------------------',...
                                '---------------------------------------------',...
                                '--------------------------------------------',...
                                '-----------------------------------------------'],...
                                ['Surf    X-Coord         Y-Coord         Z-Coord         ',...
                                'X-Cos           Y-Cos           Z-Cos           ',...
                                'X-Norm          Y-Norm         Z-Norm          ',...
                                'Angle In     Geo Path Length'],...
                                ['--------------------------------------------',...
                                '---------------------------------------------',...
                                '-----------------------------------------------',...
                                '--------------------------------------------']);
                            result = [[1:nSurf]',...
                                [rayTracerResult.RayIntersectionPoint]',...
                                [rayTracerResult.ExitRayDirection]',...
                                [rayTracerResult.SurfaceNormal]',...
                                [getAllSurfaceIncidenceAngle(rayTracerResult)]'*180/pi,...
                                [rayTracerResult.GeometricalPathLength]'];
                            % Convert double to cell matrix
                            resultCellArray = cellstr(num2str(result,...
                                '%5d %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e %15.5e'));
                            rayTraceResultTabularText = char(rayTraceResultTabularText,char(resultCellArray));
                            set(handles.textHandle,...
                                'String',rayTraceResultTabularText,...
                                'FontSize',9);
                        else
                            % Now build surface by surface output
                            for kk = 1:1:nSurf
                                noIntersection = rayTracerResult(kk).NoIntersectionPoint;
                                outOfApert = rayTracerResult(kk).OutOfAperture;
                                totInternalRef = rayTracerResult(kk).TotalInternalReflection;
                                
                                rayPos = rayTracerResult(kk).RayIntersectionPoint;
                                rayDir = rayTracerResult(kk).ExitRayDirection;
                                surfNorm = rayTracerResult(kk).SurfaceNormal;
                                incAngle = getAllSurfaceIncidenceAngle(rayTracerResult(kk))* 180/pi;
                                %                             incAngle = (rayTracerResult(kk).IncidenceAngle) * 180/pi;
                                pathLen = rayTracerResult(kk).GeometricalPathLength;
                                
                                rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                    ['---------------------------------------',...
                                    '--------------------------------------'],...
                                    ['Tracing Ray to Surface : ', num2str(kk)],...
                                    ['---------------------------------------',...
                                    '--------------------------------------'],...
                                    ['No Intersection (1 True, 0 False) : ', num2str(noIntersection)],...
                                    ['Out Of Aperture (1 True, 0 False) : ', num2str(outOfApert)],...
                                    ['TIR (1 True, 0 False)             : ', num2str(totInternalRef)],...
                                    ['Ray Intersection Point (Px,Py,Pz) : (', num2str(rayPos','%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Exit Ray Direction (Dx,Dy,Dz)     : (', num2str(rayDir','%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Surface Normal(Nx,Ny,Nz)          : (', num2str(surfNorm','%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Incidence Angle (degree)           : ', num2str(incAngle,'%+12.4e')],...
                                    ['Geometrical Path Length                       : ', num2str(pathLen,'%+12.4e')]);
                            end
                            
                            
                            set(handles.textHandle,...
                                'String',rayTraceResultSeqText,...
                                'FontSize',9);
                        end
                        
                        
                        % disp(rayTraceResultTabularText);
                        % disp(rayTraceResultSeqText);
                        
                        % Click text tab programatically
                        set(childWindow.ChildHandles.mainTabGroup,'SelectedTab',...
                            childWindow.ChildHandles.TextTab);
                    end
                case lower('polarizationRayTrace')
                    if isempty(rayTracerResult)
                        msgbox 'Ray trace failed. Look the command window for detail error.';
                        return;
                    else
                        rayTraceResultText = ...
                            ['-------------------------------------',...
                            '--------------------------------------'];
                        rayTraceResultText = char(rayTraceResultText,...
                            ['<<<<<<<<<<<<<<<<<<<<<<<< ',...
                            'Polarized Ray Trace Results ',...
                            '>>>>>>>>>>>>>>>>>>>>>>>>>']);
                        rayTraceResultText = char(rayTraceResultText,...
                            ['---------------------------------------',...
                            '----------------------------------------'],...
                            ['Normalized X Field Coord(Hx) = ',num2str(Hx)],...
                            ['Normalized Y Field Coord(Hy) = ',num2str(Hy)],...
                            ['Normalized X Pupil Coord(Px) = ',num2str(Px)],...
                            ['Normalized Y Pupil Coord(Py) = ',num2str(Py)],...
                            ['Wavelength = ',num2str(wavLen)],...
                            ['Polarization Specification Coordinate = ',upper(coordinate)],...
                            ['Initial Jones Vector = [ ',num2str(jonesVectorNew(1,:)),...
                            ' ; ',num2str(jonesVectorNew(2,:)),' ]'],...
                            ['Initial Polarization Vector (XYZ) = [ ',num2str(initialPolVectorXYZ(1,:)),...
                            ' ; ',num2str(initialPolVectorXYZ(2,:)),' ; ',num2str(initialPolVectorXYZ(3,:)),' ]'],...
                            ['Wavelength Unit = ',wavUnitText],...
                            ['Lens Unit = ',lensUnitText],...
                            ['Reference coordinate is the first surface of the optical system.'],...
                            ['All results are computed after refraction or reflection on the given surface.']);
                        
                        % Now Make the output in tabular and
                        % surface-by-surface sequential format
                        rayTraceResultTabularText = rayTraceResultText;
                        rayTraceResultSeqText = rayTraceResultText;
                        
                        % Result view options
                        dispFailureInfo = 1;
                        dispPolVector = 1;
                        dispPolMatrix = 1;
                        
                        % Construct tabular output
                        % rayTraceResultTabularText
                        
                        % Now build surface by surface output
                        for kk = 1:1:nSurf
                            noIntersection = rayTracerResult(kk).NoIntersectionPoint;
                            outOfApert = rayTracerResult(kk).OutOfAperture;
                            totInternalRef = rayTracerResult(kk).TotalInternalReflection;
                            
                            incRayDir = rayTracerResult(kk).IncidentRayDirection;
                            refRayDir = rayTracerResult(kk).ExitRayDirection;
                            surfNorm = rayTracerResult(kk).SurfaceNormal;
                            pathLen = rayTracerResult(kk).GeometricalPathLength;
                            
                            jonesMatrix = rayTracerResult(kk).CoatingJonesMatrix;
                            polMatrix =  rayTracerResult(kk).CoatingPMatrix;
                            qMatrix =  rayTracerResult(kk).CoatingQMatrix;
                            totalPMatrix =  rayTracerResult(kk).TotalPMatrix;
                            totalQMatrix =  rayTracerResult(kk).TotalQMatrix;
                            %                             [ellBefore,ellAfter] = rayTracerResult(kk).getPolarizationEllipseParameters;
                            
                            rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                ['-----------------------------------------',...
                                '----------------------------------------'],...
                                ['Tracing Ray to Surface : ', num2str(kk)],...
                                ['-----------------------------------------',...
                                '----------------------------------------']);
                            if dispFailureInfo
                                rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                    ['No Intersection (1 True, 0 False)       : ', num2str(noIntersection)],...
                                    ['Out Of Aperture (1 True, 0 False)       : ', num2str(outOfApert)],...
                                    ['TIR (1 True, 0 False)                   : ', num2str(totInternalRef)]);
                            end
                            rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                ['Incident Ray Direction (Kpx,Kpy,Kpz)    : (', num2str(incRayDir','%+12.4e %+12.4e %+12.4e'),')'],...
                                ['Exit Ray Direction (Kp1x,Kp1y,Kp1z)     : (', num2str(refRayDir','%+12.4e %+12.4e %+12.4e'),')'],...
                                ['Surface Normal(Nx,Ny,Nz)                : (', num2str(surfNorm','%+12.4e %+12.4e %+12.4e'),')'],...
                                ['Path Length (theta)                     : ', num2str(pathLen,'%+12.4e')]);
                            if dispPolVector
                                % Compute polVector after surf from initial
                                % polarization vector
                                polVector = computeFinalPolarizationVector(rayTracerResult(kk),initialPolVectorXYZ, wavLen);
                                ellipseParameter = computeEllipseParameters( polVector);
                                
                                rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                    ['Polarization Vector (E0x,E0y,E0z): (', num2str(real(polVector'),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                + i*(E0x,E0y,E0z): (', num2str(imag(polVector'),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Semi axis of XY Ellipse (EM,Em)   : (', num2str((ellipseParameter(1:2))','%+12.4e %+12.4e'),')'],...
                                    ['Angle of XY Ellipse (theta)       : (', num2str(ellipseParameter(4),'%+12.4e'),')']);
                            end
                            if dispPolMatrix
                                rayTraceResultSeqText = char(rayTraceResultSeqText,...
                                    ['Coating Jones Matrix(J11,J12)           : (', num2str(real(jonesMatrix(1,:)),'%+12.4e %+12.4e'),')'],...
                                    ['                    (J21,J22)             (', num2str(real(jonesMatrix(2,:)),'%+12.4e %+12.4e'),')'],...
                                    ['                 1i*(J11,J12)           : (', num2str(imag(jonesMatrix(1,:)),'%+12.4e %+12.4e'),')'],...
                                    ['                 1i*(J21,J22)             (', num2str(imag(jonesMatrix(2,:)),'%+12.4e %+12.4e'),')'],...
                                    ['3D Polarization Matrix(P11,P12,P13)     : (', num2str(real(polMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (P21,P22,P23)       (', num2str(real(polMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (P31,P32,P33)       (', num2str(real(polMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P11,P12,P13)     : (', num2str(imag(polMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P21,P22,P23)       (', num2str(imag(polMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P31,P32,P33)       (', num2str(imag(polMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Coord. Trans. Q Matrix(Q11,Q12,Q13)     : (', num2str(real(qMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (Q21,Q22,Q23)       (', num2str(real(qMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (Q31,Q32,Q33)       (', num2str(real(qMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q11,Q12,Q13)     : (', num2str(imag(qMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q21,Q22,Q23)       (', num2str(imag(qMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q31,Q32,Q33)       (', num2str(imag(qMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Cumulative P Matrix   (P11,P12,P13)     : (', num2str(real(totalPMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (P21,P22,P23)       (', num2str(real(totalPMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (P31,P32,P33)       (', num2str(real(totalPMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P11,P12,P13)     : (', num2str(imag(totalPMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P21,P22,P23)       (', num2str(imag(totalPMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(P31,P32,P33)       (', num2str(imag(totalPMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['Cumulative Q Matrix   (Q11,Q12,Q13)     : (', num2str(real(totalQMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (Q21,Q22,Q23)       (', num2str(real(totalQMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                      (Q31,Q32,Q33)       (', num2str(real(totalQMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q11,Q12,Q13)     : (', num2str(imag(totalQMatrix(1,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q21,Q22,Q23)       (', num2str(imag(totalQMatrix(2,:)),'%+12.4e %+12.4e %+12.4e'),')'],...
                                    ['                   1i*(Q31,Q32,Q33)       (', num2str(imag(totalQMatrix(3,:)),'%+12.4e %+12.4e %+12.4e'),')']);
                            end
                        end
                        if showInTabular
                            msgbox('Tabular output is not currently available for polarization ray tracing');
                            % set(handles.textHandle,'String',rayTraceResultTabularText);
                            set(handles.textHandle,...
                                'String',rayTraceResultSeqText,...
                                'FontSize',9);
                        else
                            set(handles.textHandle,...
                                'String',rayTraceResultSeqText,...
                                'FontSize',9);
                        end
                        % disp(rayTraceResultTabularText);
                        % disp(rayTraceResultSeqText);
                        
                        % Click text tab programatically
                        set(childWindow.ChildHandles.mainTabGroup,'SelectedTab',...
                            childWindow.ChildHandles.TextTab);
                    end
            end
            
        case lower(others)
            switch lower(handles.Name)
                case lower('coatingRefractiveIndexProfile')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Check for inputs whether to take coating from a given surface or use new
                    % coating
                    surfIndexList = (get(handles.popSurfaceIndex,'String'));
                    surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'),:);
                    surfIndex = str2double(surfIndexString);
                    if strcmpi(surfIndexString,'New Coating')
                        % Read coating object from Coating Catalogue
                        name = get(handles.txtCoatingName,'String');
                        catalogueList = optSystem.CoatingCataloguesList;
                        caotingFound = 0;
                        for k = 1:size(catalogueList,1)
                            catalogueName = catalogueList{k};
                            myCoating = extractObjectFromObjectCatalogue...
                                ('coating', name,catalogueName );
                            if strcmpi(class(myCoating),'Coating')
                                caotingFound = 1;
                                break;
                            end
                        end
                        if ~caotingFound
                            disp('Coating not found');
                            return;
                        end
                    elseif ~isnan(surfIndex)
                        % Read the coating from the surface index
                        myCoating = optSystem.SurfaceArray...
                            (surfIndex).Coating;
                    else
                        disp(['Error: The surface index should be either '...
                            'valid surface number or it should be New Caoting']);
                        return;
                    end
                    plotCoatingRefractiveIndexProfile...
                        (myCoating,handles.axesHandle,handles.tableHandle,handles.textHandle);
                    
                case lower('footprintDiagram')
                    optSystem = optSystem(currentConfiguration);
                    
                    surfIndexList = (get(handles.popSurfaceIndex,'String'));
                    surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'));
                    surfIndex = str2double(surfIndexString);
                    if isnan(surfIndex)
                        disp('The surface index should be valid index number');
                        return;
                    end
                    numberOfRays1 = str2double(get(handles.txtNumberOfRay1,'String'));
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    if strcmpi(wavLengthIndexString,'New Wavelength')
                    elseif strcmpi(wavLengthIndexString,'All')
                        wavIndex = 1:1:getNumberOfWavelengths(optSystem);
                    else
                        wavIndex = str2double(wavLengthIndexString);
                    end
                    
                    fldIndexList = (get(handles.popFieldIndex,'String'));
                    fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                    if strcmpi(fldIndexString,'All')
                        fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
                    else
                        fldIndex = str2double(fldIndexString);
                    end

                    pupSamplingTypeList = (get(handles.popPupilSamplingType,'String'));
                    PupSamplingType = (pupSamplingTypeList{get(handles.popPupilSamplingType,'Value'),:});
                    
                    plotFootprintDiagram(optSystem,surfIndex,wavIndex,...
                        fldIndex,numberOfRays1,numberOfRays2,PupSamplingType,...
                        handles.axesHandle);
                 case lower('spotDiagramPlus')
                    optSystem = optSystem(currentConfiguration);
                    
                    surfIndexList = (get(handles.popSurfaceIndex,'String'));
                    surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'));
                    surfIndex = str2double(surfIndexString);
                    if isnan(surfIndex)
                        disp('The surface index should be valid index number');
                        return;
                    end
                    numberOfRays1 = str2double(get(handles.txtNumberOfRay1,'String'));
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    if strcmpi(wavLengthIndexString,'New Wavelength')
                    elseif strcmpi(wavLengthIndexString,'All')
                        wavIndex = 1:1:getNumberOfWavelengths(optSystem);
                    else
                        wavIndex = str2double(wavLengthIndexString);
                    end
                    
                    fldIndexList = (get(handles.popFieldIndex,'String'));
                    fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                    if strcmpi(fldIndexString,'All')
                        fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
                    else
                        fldIndex = str2double(fldIndexString);
                    end

                    pupSamplingTypeList = (get(handles.popPupilSamplingType,'String'));
                    PupSamplingType = (pupSamplingTypeList{get(handles.popPupilSamplingType,'Value'),:});
                    
                    azimuthalDependence = get(handles.popShowPupilAzimuthalDependence,'Value');
                    radialDependence = get(handles.popShowPupilRadialDependence,'Value');
                    
                    plotSpotDiagramPlus(optSystem,surfIndex,wavIndex,...
                        fldIndex,numberOfRays1,numberOfRays2,PupSamplingType,...
                        radialDependence,azimuthalDependence,...
                        handles.GraphTab,handles.textHandle);
                                       
                case lower('system2DLayoutDiagram')
                    % Programmed to handle multiple configurations
                    plotIn2D = 1;
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    numberOfRays1 = numberOfRays2;
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    
                    nConfig = length(optSystem);
                    selectedConfigIndex = get(handles.popMulticonfigurationIndex,'value');
                    
                    if selectedConfigIndex < nConfig
                        optSystem = optSystem(selectedConfigIndex);
                    end
                    cla(handles.axesHandle,'reset');
                    for cc = 1:length(optSystem)
                        if strcmpi(wavLengthIndexString,'New Wavelength')
                        elseif strcmpi(wavLengthIndexString,'All')
                            wavIndex = 1:1:getNumberOfWavelengths(optSystem(cc));
                        else
                            wavIndex = str2double(wavLengthIndexString);
                        end
                        
                        fldIndexList = (get(handles.popFieldIndex,'String'));
                        fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                        if strcmpi(fldIndexString,'All')
                            fldIndex = 1:1:getNumberOfFieldPoints(optSystem(cc));
                        else
                            fldIndex = str2double(fldIndexString);
                        end
                                          
                        pupSampling = 'Tangential';
                        
                        % compute totalRayPathMatrix = 3 X nSurf X nTotalRay
                        totalRayPathMatrix = computeRayPathMatrix(optSystem(cc),wavIndex,...
                            fldIndex,pupSampling,numberOfRays1,numberOfRays2);
                        
                        plotSystemLayout(optSystem(cc),totalRayPathMatrix,...
                            plotIn2D,handles.axesHandle);
                        hold on;
                    end
                case lower('system3DLayoutDiagram')
                    optSystem = optSystem(currentConfiguration);
                    
                    plotIn2D = 0;
                    numberOfRays1 = str2double(get(handles.txtNumberOfRay1,'String'));
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    if strcmpi(wavLengthIndexString,'New Wavelength')
                    elseif strcmpi(wavLengthIndexString,'All')
                        wavIndex = 1:1:getNumberOfWavelengths(optSystem);
                    else
                        wavIndex = str2double(wavLengthIndexString);
                    end
                    
                    fldIndexList = (get(handles.popFieldIndex,'String'));
                    fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                    if strcmpi(fldIndexString,'All')
                        fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
                    else
                        fldIndex = str2double(fldIndexString);
                    end
 
                    pupSamplingTypeList = (get(handles.popPupilSamplingType,'String'));
                    pupSamplingType = (pupSamplingTypeList{get(handles.popPupilSamplingType,'Value'),:});
                    
                    % compute totalRayPathMatrix = 3 X nSurf X nTotalRay
                    totalRayPathMatrix = computeRayPathMatrix(optSystem,wavIndex,...
                        fldIndex,pupSamplingType,numberOfRays1,numberOfRays2);
                    plotSystemLayout(optSystem,totalRayPathMatrix,...
                        plotIn2D,handles.axesHandle);
                case lower('paraxialAnalysis')
                    optSystem = optSystem(currentConfiguration);
                    
                    showOptions = struct();
                    showOptions.TotalNumberOfSurfaces = get(handles.chkShowTotalNumberOfSurfaces,'Value');
                    showOptions.StopSurfaceIndex = get(handles.chkShowStopSurfaceIndex,'Value');
                    showOptions.SystemTotalTrack = get(handles.chkShowSystemTotalTrack,'Value');
                    showOptions.EffectiveFocalLength = get(handles.chkShowEffectiveFocalLength,'Value');
                    showOptions.BackFocalLength = get(handles.chkShowBackFocalLength,'Value');
                    showOptions.AngularMagnification = get(handles.chkShowAngularMagnification,'Value');
                    showOptions.EntrancePupilDiameter = get(handles.chkShowEntrancePupilDiameter,'Value');
                    showOptions.EntrancePupilLocation = get(handles.chkShowEntrancePupilLocation,'Value');
                    showOptions.ExitPupilDiameter = get(handles.chkShowExitPupilDiameter,'Value');
                    showOptions.ExitPupilLocation = get(handles.chkShowExitPupilLocation,'Value');
                    showOptions.ObjectSpaceNA = get(handles.chkShowObjectSpaceNA,'Value');
                    showOptions.ImageSpaceNA = get(handles.chkShowImageSpaceNA,'Value');
                    
                    primaryWavLen = getPrimaryWavelength(optSystem);
                    performParaxialAnalysis(optSystem,primaryWavLen,showOptions,handles.textHandle);
                    % Click text tab programatically
                    set(childWindow.ChildHandles.mainTabGroup,'SelectedTab',...
                        childWindow.ChildHandles.TextTab);
                case lower('pupilApodization')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Pupil Apodization
                    apodizationTypeList =  (get(handles.popApodizationType,'String'));
                    apodizationType = char...
                        (apodizationTypeList(get(handles.popApodizationType,'Value'),:));
                    apodizationParameters = struct();
                    switch lower(apodizationType)
                        case lower('None')
                            apodizationParameters = '';
                        case lower('Super Gaussian')
                            apodizationParameters.MaximumIntensity =...
                                str2double(get(handles.txtApodMaximumIntensity,'String'));
                            apodizationParameters.Order = ...
                                str2double(get(handles.txtApodOrder,'String'));
                            apodizationParameters.BeamRadius = ...
                                str2double(get(handles.txtApodBeamRadius,'String'));
                    end
                    % Grid size is seq of odd numbers
                    gridSizeList = (get(handles.popPupilGridSize,'String'));
                    gridSize = (gridSizeList{get(handles.popPupilGridSize,'Value'),:});
                    
                    sampleGridSizeX = str2double(gridSize(1:findstr(gridSize,'x')-1));
                    sampleGridSizeY = str2double(gridSize(findstr(gridSize,'x')+1:end));
                    sampleGridSize = max([sampleGridSizeX,sampleGridSizeY]);
                    
                    plotPupilApodization...
                        (optSystem,apodizationType,apodizationParameters,...
                        sampleGridSize,handles.axesHandle);
                    
                case lower('transverseRayAberration')
                    optSystem = optSystem(currentConfiguration);
                    
                    surfIndexList = (get(handles.popSurfaceIndex,'String'));
                    surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'));
                    surfIndex = str2double(surfIndexString);
                    if isnan(surfIndex)
                        disp('The surface index should be valid index number');
                        return;
                    end
                    numberOfRays1 = str2double(get(handles.txtNumberOfRay1,'String'));
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    if strcmpi(wavLengthIndexString,'New Wavelength')
                    elseif strcmpi(wavLengthIndexString,'All')
                        wavIndex = 1:1:getNumberOfWavelengths(optSystem);
                    else
                        wavIndex = str2double(wavLengthIndexString);
                    end
                    
                    fldIndexList = (get(handles.popFieldIndex,'String'));
                    fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                    if strcmpi(fldIndexString,'All')
                        fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
                    else
                        fldIndex = str2double(fldIndexString);
                    end
                    
                    % Check condition that both field index and wavelength are
                    % not multiple at the same time. To avoid having multiple
                    % graphs, All fiedls can be analysed with specific
                    % wavelength and vice versa.
                    if strcmpi(fldIndexString,'All') && strcmpi(wavLengthIndexString,'All')
                        disp('Warning: Many number of lines, the graph could be complex.');
                    end

                    % Sagittal and tangetial aberration components
                    sagAberrCompList = (get(handles.popSagittalAberration,'String'));
                    sagittalAberrComp = sagAberrCompList(get(handles.popSagittalAberration,'Value'));
                    tanAberrCompList = (get(handles.popTangentialAberration,'String'));
                    tangentialAberrComp = tanAberrCompList(get(handles.popTangentialAberration,'Value'));
                    
                    % Since two graphs will be drawn (sagittal and tangential),
                    % handles.GraphTab is passed instead of the axes
                    % handle.
                    plotTransverseRayAberration(optSystem,surfIndex,wavIndex,...
                        fldIndex,numberOfRays1,numberOfRays2,sagittalAberrComp,tangentialAberrComp,...
                        handles.GraphTab);
                    
                case lower('KostenbauderMatrix')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Read pilot ray parameters
                    % Read Hx,Hy,Px,Py and Wavelegth
                    Hx = str2double(get(handles.txtHx,'String'));
                    Hy = str2double(get(handles.txtHy,'String'));
                    Px = str2double(get(handles.txtPx,'String'));
                    Py = str2double(get(handles.txtPy,'String'));
                    wavLen = str2double(get(handles.txtWavelength,'String'));
                    wavLenInM = wavLen * getWavelengthUnitFactor(optSystem);
                    % Compute Initial Direction and Position
                    [rayPosition,rayDirection] = computeRayParametersFromNormalizedCoordiantes...
                        (optSystem,Hx,Hy,Px,Py);
                    pilotRay = ScalarRayBundle(rayPosition,rayDirection,wavLenInM) ;
                    
                    % Read start and end surface indices
                    startSurfIndexList = (get(handles.popStartSurfaceIndex,'String'));
                    startSurfIndexString = startSurfIndexList(get(handles.popStartSurfaceIndex,'Value'),:);
                    startSurfIndex = str2double(startSurfIndexString);
                    startSurfInclusive = get(handles.chkStartSurfaceInclusive,'Value');
                    
                    endSurfIndexList = (get(handles.popEndSurfaceIndex,'String'));
                    endSurfIndexString = endSurfIndexList(get(handles.popEndSurfaceIndex,'Value'),:);
                    endSurfIndex = str2double(endSurfIndexString);
                    endSurfInclusive = get(handles.chkEndSurfaceInclusive,'Value');
                    
                    % Compute Kostenbauder matrix
                    [ finalKostenbauderMatrix, interfaceKostenbauderMatrices,...
                        mediumKostenbauderMatrices ] = computeKostenbauderMatrix(...
                        optSystem,startSurfIndex,startSurfInclusive,...
                        endSurfIndex, endSurfInclusive,pilotRay );
                    
                    % Display the Kostenbauder matrix elements in text
                    % display window with some expanation and units
                    
                    textA = sprintf('%+.4e', finalKostenbauderMatrix(1,1));
                    textB = sprintf('%+.4e', finalKostenbauderMatrix(1,2));
                    textC = sprintf('%+.4e', finalKostenbauderMatrix(2,1));
                    textD = sprintf('%+.4e', finalKostenbauderMatrix(2,2));
                    textE = sprintf('%+.4e', finalKostenbauderMatrix(1,4));
                    textF = sprintf('%+.4e', finalKostenbauderMatrix(2,4));
                    textG = sprintf('%+.4e', finalKostenbauderMatrix(3,1));
                    textH = sprintf('%+.4e', finalKostenbauderMatrix(3,2));
                    textI = sprintf('%+.4e', finalKostenbauderMatrix(3,4));
                    
                    
                    KostenbauderMatrixText = char(...
                        ['---------------------------------------',...
                        '--------------------------------------'],...
                        ['---------------------------The Kostenba',...
                        'uder Matrix---------------------------'],...
                        ['---------------------------------------',...
                        '--------------------------------------'],...
                        ['                           | A     B   ',...
                        '  0     E |                           '],...
                        ['                           | C     D   ',...
                        '  0     F |                           '],...
                        ['                           | G     H   ',...
                        '  1     I |                           '],...
                        ['                           | 0     0   ',...
                        '  0     1 |                           '],...
                        ['---------------------------------------',...
                        '--------------------------------------'],...
                        ['|Element|      Value       |   Unit   |',...
                        '       Physical Interpretation       |'],...
                        ['---------------------------------------',...
                        '--------------------------------------'],...
                        ['|   E   |   ',textE,'    |   m/Hz   |',...
                        ' Spacial chirp                       |'],...
                        ['|   F   |   ',textF,'    |  rad/Hz  |',...
                        ' Angular diapersion                  |'],...
                        ['|   G   |   ',textG,'    |   s/m    |',...
                        ' ----                                |'],...
                        ['|   H   |   ',textH,'    |  s/rad   |',...
                        ' ----                                |'],...
                        ['|   I   |   ',textI,'    |   s/Hz   |',...
                        ' Group delay disparsion              |'],...
                        ['---------------------------------------',...
                        '--------------------------------------']);
                    
                    set(handles.textHandle,...
                        'String',KostenbauderMatrixText,...
                        'FontSize',10);
                    % Click text tab programatically
                    set(childWindow.ChildHandles.mainTabGroup,'SelectedTab',...
                        childWindow.ChildHandles.TextTab);
                case lower('GDDVsWavelength')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Read pilot ray parameters
                    % Read Hx,Hy,Px,Py and Wavelegth
                    Hx = str2double(get(handles.txtHx,'String'));
                    Hy = str2double(get(handles.txtHy,'String'));
                    Px = str2double(get(handles.txtPx,'String'));
                    Py = str2double(get(handles.txtPy,'String'));
                    
                    minWavelength = str2double(get(handles.txtMinWavelength,'String'));
                    maxWavelength = str2double(get(handles.txtMaxWavelength,'String'));
                    wavelengthStep = str2double(get(handles.txtWavelengthStep,'String'));
                    
                    wavUnitFactor = 10^-6;
                    minWavelengthInM = minWavelength*wavUnitFactor;
                    maxWavelengthInM = maxWavelength*wavUnitFactor;
                    wavelengthStepInM = wavelengthStep*wavUnitFactor;
                    
                    % Compute Initial Direction and Position
                    [pilotRayPosition,pilotRayDirection] = computeRayParametersFromNormalizedCoordiantes...
                        (optSystem,Hx,Hy,Px,Py);
                    
                    % Read start and end surface indices
                    startSurfIndexList = (get(handles.popStartSurfaceIndex,'String'));
                    startSurfIndexString = startSurfIndexList(get(handles.popStartSurfaceIndex,'Value'),:);
                    startSurfIndex = str2double(startSurfIndexString);
                    startSurfInclusive = get(handles.chkStartSurfaceInclusive,'Value');
                    
                    endSurfIndexList = (get(handles.popEndSurfaceIndex,'String'));
                    endSurfIndexString = endSurfIndexList(get(handles.popEndSurfaceIndex,'Value'),:);
                    endSurfIndex = str2double(endSurfIndexString);
                    endSurfInclusive = get(handles.chkEndSurfaceInclusive,'Value');
                    
                    plotGDDVsWavelength(optSystem,startSurfIndex,...
                        startSurfInclusive,endSurfIndex, endSurfInclusive,...
                        pilotRayPosition,pilotRayDirection,...
                        minWavelengthInM ,maxWavelengthInM ,wavelengthStepInM ,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                    
                case lower('SpatialChirpVsWavelength')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Read pilot ray parameters
                    % Read Hx,Hy,Px,Py and Wavelegth
                    Hx = str2double(get(handles.txtHx,'String'));
                    Hy = str2double(get(handles.txtHy,'String'));
                    Px = str2double(get(handles.txtPx,'String'));
                    Py = str2double(get(handles.txtPy,'String'));
                    
                    minWavelength = str2double(get(handles.txtMinWavelength,'String'));
                    maxWavelength = str2double(get(handles.txtMaxWavelength,'String'));
                    wavelengthStep = str2double(get(handles.txtWavelengthStep,'String'));
                    
                    wavUnitFactor = 10^-6;
                    minWavelengthInM = minWavelength*wavUnitFactor;
                    maxWavelengthInM = maxWavelength*wavUnitFactor;
                    wavelengthStepInM = wavelengthStep*wavUnitFactor;
                    
                    % Compute Initial Direction and Position
                    [pilotRayPosition,pilotRayDirection] = computeRayParametersFromNormalizedCoordiantes...
                        (optSystem,Hx,Hy,Px,Py);
                    
                    % Read start and end surface indices
                    startSurfIndexList = (get(handles.popStartSurfaceIndex,'String'));
                    startSurfIndexString = startSurfIndexList(get(handles.popStartSurfaceIndex,'Value'),:);
                    startSurfIndex = str2double(startSurfIndexString);
                    startSurfInclusive = get(handles.chkStartSurfaceInclusive,'Value');
                    
                    endSurfIndexList = (get(handles.popEndSurfaceIndex,'String'));
                    endSurfIndexString = endSurfIndexList(get(handles.popEndSurfaceIndex,'Value'),:);
                    endSurfIndex = str2double(endSurfIndexString);
                    endSurfInclusive = get(handles.chkEndSurfaceInclusive,'Value');
                    
                    plotSpatialChirpVsWavelength(optSystem,startSurfIndex,...
                        startSurfInclusive,endSurfIndex, endSurfInclusive,...
                        pilotRayPosition,pilotRayDirection,...
                        minWavelengthInM ,maxWavelengthInM ,wavelengthStepInM ,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                case lower('AngularDispersionVsWavelength')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Read pilot ray parameters
                    % Read Hx,Hy,Px,Py and Wavelegth
                    Hx = str2double(get(handles.txtHx,'String'));
                    Hy = str2double(get(handles.txtHy,'String'));
                    Px = str2double(get(handles.txtPx,'String'));
                    Py = str2double(get(handles.txtPy,'String'));
                    
                    minWavelength = str2double(get(handles.txtMinWavelength,'String'));
                    maxWavelength = str2double(get(handles.txtMaxWavelength,'String'));
                    wavelengthStep = str2double(get(handles.txtWavelengthStep,'String'));
                    
                    wavUnitFactor = 10^-6;
                    minWavelengthInM = minWavelength*wavUnitFactor;
                    maxWavelengthInM = maxWavelength*wavUnitFactor;
                    wavelengthStepInM = wavelengthStep*wavUnitFactor;
                    
                    % Compute Initial Direction and Position
                    [pilotRayPosition,pilotRayDirection] = computeRayParametersFromNormalizedCoordiantes...
                        (optSystem,Hx,Hy,Px,Py);
                    
                    % Read start and end surface indices
                    startSurfIndexList = (get(handles.popStartSurfaceIndex,'String'));
                    startSurfIndexString = startSurfIndexList(get(handles.popStartSurfaceIndex,'Value'),:);
                    startSurfIndex = str2double(startSurfIndexString);
                    startSurfInclusive = get(handles.chkStartSurfaceInclusive,'Value');
                    
                    endSurfIndexList = (get(handles.popEndSurfaceIndex,'String'));
                    endSurfIndexString = endSurfIndexList(get(handles.popEndSurfaceIndex,'Value'),:);
                    endSurfIndex = str2double(endSurfIndexString);
                    endSurfInclusive = get(handles.chkEndSurfaceInclusive,'Value');
                    
                    plotAngularDispersionVsWavelength(optSystem,startSurfIndex,...
                        startSurfInclusive,endSurfIndex, endSurfInclusive,...
                        pilotRayPosition,pilotRayDirection,...
                        minWavelengthInM ,maxWavelengthInM ,wavelengthStepInM ,...
                        handles.axesHandle, handles.tableHandle,handles.textHandle);
                case lower('GaussianPulsePropagation')
                    optSystem = optSystem(currentConfiguration);
                    
                    % Read pilot ray parameters
                    % Read Hx,Hy,Px,Py and Wavelegth
                    Hx = str2double(get(handles.txtHx,'String'));
                    Hy = str2double(get(handles.txtHy,'String'));
                    Px = str2double(get(handles.txtPx,'String'));
                    Py = str2double(get(handles.txtPy,'String'));
                    wavLen = str2double(get(handles.txtWavelength,'String'));
                    wavLenInM = wavLen * getWavelengthUnitFactor(optSystem);
                    % Compute Initial Direction and Position
                    [rayPosition,rayDirection] = computeRayParametersFromNormalizedCoordiantes...
                        (optSystem,Hx,Hy,Px,Py);
                    pilotRay = ScalarRayBundle(rayPosition,rayDirection,wavLenInM) ;
                    
                    % Read start and end surface indices
                    startSurfIndexList = (get(handles.popStartSurfaceIndex,'String'));
                    startSurfIndexString = startSurfIndexList(get(handles.popStartSurfaceIndex,'Value'),:);
                    startSurfIndex = str2double(startSurfIndexString);
                    startSurfInclusive = get(handles.chkStartSurfaceInclusive,'Value');
                    
                    endSurfIndexList = (get(handles.popEndSurfaceIndex,'String'));
                    endSurfIndexString = endSurfIndexList(get(handles.popEndSurfaceIndex,'Value'),:);
                    endSurfIndex = str2double(endSurfIndexString);
                    endSurfInclusive = get(handles.chkEndSurfaceInclusive,'Value');
                    
                    % Read gausian beam parameter
                    lensUnitFactor = getLensUnitFactor(optSystem);
                    spatialWidthInSI = lensUnitFactor*str2double(get(handles.txtGaussianPulseSpatialWidth,'String'));
                    radiusOfCurvatureInSI = lensUnitFactor*str2double(get(handles.txtGaussianPulseRadiusOfCurvature,'String'));
                    temporalWidthInSI = str2double(get(handles.txtGaussianPulseTemporalWidth,'String'));
                    initialChirpInSI = str2double(get(handles.txtGaussianPulseTemporalChirp,'String'));
                    
                    % Read output window size parameters
                    outputSpatialWindowInSI = lensUnitFactor*str2double(get(handles.txtOutputSpatialWindow,'String'));
                    outputTemporalWindowInSI = str2double(get(handles.txtOutputTemporalWindow,'String'));
                    
                    % compute Gaussian pulse and propagate using
                    % Kostenabuder matrix
                    gaussianPulsedBeamParameter = [spatialWidthInSI,...
                        radiusOfCurvatureInSI,temporalWidthInSI,initialChirpInSI]';
                    inputGaussianPulse = GaussianPulsedBeam(gaussianPulsedBeamParameter,wavLenInM);
                    
                    [ outputGaussianPulse ] = propagateGaussianPulsedBeam( optSystem,...
                        inputGaussianPulse,startSurfIndex,startSurfInclusive,...
                        endSurfIndex, endSurfInclusive,pilotRay );
                    
                    tMax = outputTemporalWindowInSI/2;
                    tlin = linspace(-tMax,tMax,200);
                    xMax = outputSpatialWindowInSI/2;
                    xlin = linspace(-xMax,xMax,200);
                    [ tlinInSI,xlinInSI,amplitude,pusedBeamParametersTxt ] = ...
                        plotGaussianPulsedBeam(outputGaussianPulse,tlin,xlin,handles.axesHandle);
                    textWindowDisp = char(['-----------------------',...
                        '--------------------'],...
                        ['-----------Pulsed Beam ',...
                        'Parameters----------'],...
                        ['-----------------------',...
                        '--------------------'],...
                        pusedBeamParametersTxt,....
                        ['-----------------------',...
                        '--------------------']);
                    set(handles.textHandle,...
                        'String',textWindowDisp,...
                        'FontSize',10);
                    
                case lower('PulseFrontEvolutionGeometric')
                    optSystem = optSystem(currentConfiguration);
                    
                    surfIndexList = (get(handles.popSurfaceIndex,'String'));
                    surfIndexString = surfIndexList(get(handles.popSurfaceIndex,'Value'));
                    surfIndex = str2double(surfIndexString);
                    if isnan(surfIndex)
                        disp('The surface index should be valid index number');
                        return;
                    end
                    numberOfRays1 = str2double(get(handles.txtNumberOfRay1,'String'));
                    numberOfRays2 = str2double(get(handles.txtNumberOfRay2,'String'));
                    wavLengthIndexList = (get(handles.popWavelengthIndex,'String'));
                    wavLengthIndexString = (wavLengthIndexList(get(handles.popWavelengthIndex,'Value'),:));
                    if strcmpi(wavLengthIndexString,'New Wavelength')
                    elseif strcmpi(wavLengthIndexString,'All')
                        wavIndex = 1:1:getNumberOfWavelengths(optSystem);
                    else
                        wavIndex = str2double(wavLengthIndexString);
                    end
                    
                    fldIndexList = (get(handles.popFieldIndex,'String'));
                    fldIndexString = (fldIndexList(get(handles.popFieldIndex,'Value'),:));
                    if strcmpi(fldIndexString,'All')
                        fldIndex = 1:1:getNumberOfFieldPoints(optSystem);
                    else
                        fldIndex = str2double(fldIndexString);
                    end

                    pupSamplingTypeList = (get(handles.popPupilSamplingType,'String'));
                    PupSamplingType = (pupSamplingTypeList{get(handles.popPupilSamplingType,'Value'),:});
                    plotIn2D = (get(handles.chk2DCrossSection,'Value'));
                    
                    % Extract the time sampling parameters
                    stepVariable = get(handles.popStepVariable,'Value');% 1:Z(in lens unit) and 2:Time(in sec)
                    
                    stepSize = str2double(get(handles.txtStepSize,'String'));
                    numberOfSteps = str2double(get(handles.txtNumberOfSteps,'String'));
                    % convert the Z distance to time
                    if stepVariable == 1
                        c =  299792458;
                        deltaTime = (stepSize*getLensUnitFactor(optSystem))/c;
                    elseif stepVariable == 2
                        deltaTime = stepSize;
                    else
                    end
                    numberOfTimeSamples =    numberOfSteps;
                    
                    plotPhaseAndPulseFrontEvolution(optSystem, wavIndex,fldIndex, ...
                        surfIndex, deltaTime,numberOfTimeSamples,numberOfRays1,...
                        numberOfRays2,PupSamplingType,plotIn2D,handles.axesHandle )
                    
                case lower('FFTFocusedPulse')
                    optSystem = optSystem(currentConfiguration);
            end
    end
    
    
    %% Local function
    function [polarizationType,polarizationParameters] =  readPolarizationProfileParameters(handles)
        
        polarizationType = get(handles.popPolarizationProfile,'Value');
        polarizationParameterTable = get(handles.tblPolarizationParameters,'Data');
        
        % get the Polarization profile parameters from the corresponding
        % Polarization profile function
        [ polarizationParameterFields, polarizationParameterFormats,polarizationParameterStruct ] = getHFSourcePolarizationProfileParameters( (polarizationType) );
        
        % Calculate the size of panelSpatialParameters based on the number of
        % parameters
        nPar = length(polarizationParameterFields);
        for pp = 1:nPar
            % Read the parameter value from text boxes or popup menu
            parFormat = polarizationParameterFormats{pp};
            paramName = polarizationParameterFields{pp};
            parValue = polarizationParameterTable{pp,2};
            if iscell(parFormat)
                % Multiple choice values
                parValueDisplay = parValue;
                [isMemeber,foundAtIndex] = ismember(parValue,parFormat);
                polarizationParameterStruct.(paramName) = foundAtIndex;
            else
                if strcmpi(parFormat,'logical')
                    if strcmpi(parValue,'1') || strcmpi(parValue,'true')
                        newParameter = 1;
                    elseif strcmpi(parValue,'0') || strcmpi(parValue,'false')
                        newParameter = 0;
                    else
                        newParameter = 0;
                    end
                    polarizationParameterStruct.(paramName) = newParameter;
                elseif strcmpi(parFormat,'char')
                    newParameter = parValue;
                    polarizationParameterStruct.(paramName) = newParameter;
                elseif strcmpi(parFormat,'numeric')
                    if isnumeric(parValue)
                        newParameter = (parValue);
                    else
                        newParameter = str2num(parValue);
                    end
                    
                    if isempty(newParameter)
                        newParameter = 0;
                    end
                    polarizationParameterStruct.(paramName) = newParameter;
                else
                    newParameter = parValue;
                    polarizationParameterStruct.(paramName) = newParameter;
                end
            end
        end
        polarizationParameters = polarizationParameterStruct;
    end
end

