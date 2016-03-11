function plotSpotDiagramPlus(optSystem,surfIndex,wavelengthIndices,...
        fieldIndices,numberOfRays1,numberOfRays2,PupSamplingType,...
        plotPanelHandle,textHandle)
    % Displays the spot diagram of the beam on any surface. It shows the
    % pupil coordinates of each point in the spot diagram using color.
    % Currently the graph will be with respect to the centroid
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Mar 10,2016   Worku, Norman G.     Original Version       Version 3.0
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Default Inputs
    if nargin < 7
        disp('Error: The function requires atleast 6 arguments, optSystem,',...
            ' surfIndex, wavLen, fieldPointXY, numberOfRays1,numberOfRays2, PupSamplingType.');
        return;
    elseif nargin == 7
        plotPanelHandle = uipanel('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
        dispText = 0;
    elseif nargin == 8
        dispText = 0;
    elseif nargin == 9
        dispText = 1;
    end
    [ lensUnitFactor,~,lensUnitTextShort ] = getLensUnitFactor(optSystem);
    [~,~, wavUnitTextShort] = getWavelengthUnitFactor(optSystem);
    [ ~,~, fieldUnitTextShort] = getFieldPointUnitFactor( optSystem );
    wavelengthMatrix = optSystem.WavelengthMatrix;
    fieldPointMatrix = optSystem.FieldPointMatrix;
    
    
    NonDummySurfaceIndices = getNonDummySurfaceIndices(optSystem);
    if ~find(ismember(NonDummySurfaceIndices,surfIndex))
        disp('Error:No ray trace data for Dummy surfaces');
        return;
    end
    nonDummySurfacesBeforeCurrentSurface = sum(NonDummySurfaceIndices<=surfIndex);
    dummySurfacesBeforeCurrentSurface = surfIndex - nonDummySurfacesBeforeCurrentSurface;
    
    %     spotColorMapList = repmat({ 'jet', 'parula','hsv', 'hot', 'cool', 'spring', 'summer',...
    %         'autumn', 'winter', 'copper'},[1,5]); % 10x5 = 50
    spotColorMapList = repmat({ 'jet'},[1,50]); % 1x50 = 50
    cla(allchild(plotPanelHandle),'reset')
    
    % polarizedRayTracerResult =  2 X nRay X nField X nWav
    endSurface = surfIndex;
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.ConsiderSurfaceAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 0;
    
    polarizedRayTracerResult = multipleRayTracer(optSystem,wavelengthIndices,...
        fieldIndices,numberOfRays1,numberOfRays2,PupSamplingType,rayTraceOptionStruct,endSurface);
    
    %     % Draw the aperture
    currentSurface = getSurfaceArray(optSystem,surfIndex);
    
    % Spatial Distribution of spot diagram in a given surface
    % Use different color for diffrent wavelengths and different symbal for
    % different field points.
    %     entrancePupilRadius = (getEntrancePupilDiameter(optSystem))/2;
    nSurfaceResultRecorded = size(polarizedRayTracerResult,1);
    nRay = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfPupilPoints;
    nField = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfFieldPoints;
    nWav = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfWavelengths;
    pupilCoordinates = polarizedRayTracerResult(1).FixedParameters.PupilCoordinates;
    SurfaceCoordinateTM = currentSurface.SurfaceCoordinateTM;
    surfIndexWithOutDummy = surfIndex-dummySurfacesBeforeCurrentSurface;
    maxRadius_All = 0;
    spotDiagramPlusText = '';
    
    for wavIndex = 1:nWav
        for fieldIndex = 1:nField
            % create panels and axes for each subplots
            subplotPanel = uipanel('Parent',plotPanelHandle,...
                'FontSize',10,'Units','Normalized',...
                'Position',[(fieldIndex-1)*1/nField,(nWav-wavIndex)*1/nWav,1/nField,1/nWav]);
            subplotAxes(wavIndex,fieldIndex) = axes('Parent',subplotPanel,...
                'Units','Normalized',...
                'Position',[0,0,1,1]);
            
            [ globalIntersectionPoints ] = squeeze(...
                getAllSurfaceRayIntersectionPoint( polarizedRayTracerResult(2),...
                0,fieldIndex,wavIndex));
            % convert from global to local coordinate of the surface
            localIntersectionPoints = globalToLocalPosition...
                (globalIntersectionPoints, SurfaceCoordinateTM);
            % Covert from meter to lens unit
            px = localIntersectionPoints(1,:);
            py = localIntersectionPoints(2,:);
            
            % NaN should not be used
            nanIndices = (isnan(px)|isnan(py));
            
            % Compute the centroid The centroid is defined by the average
            % position of the rays traced.
            xCentroid = mean(px(~nanIndices));
            yCentroid = mean(py(~nanIndices));
            
            px_diff = px - xCentroid;
            py_diff = py - yCentroid;
            
            currentColorMap = spotColorMapList{fieldIndex + (wavIndex-1)*nField};
            nLevels = length(px_diff);
            RGBtriplet = computeColorMap(currentColorMap,nLevels);
            % Sort the color based on the pupil radius
            pupilRad = sqrt(sum(pupilCoordinates(1:2,:).^2,1));
            [~,sortedIndex] = sort(pupilRad);
            sortedRGBtriplet(sortedIndex,:) = RGBtriplet;
            currentSpotSymbal = '.';
            scatter(subplotAxes(wavIndex,fieldIndex),px_diff,py_diff,10,sortedRGBtriplet,currentSpotSymbal);
            
            wav = wavelengthMatrix(wavIndex,1);
            fieldX = fieldPointMatrix(fieldIndex,1);
            fieldY = fieldPointMatrix(fieldIndex,2);

            rmsRadius = rms(sqrt(px_diff(~nanIndices).^2 + py_diff(~nanIndices).^2));
            maxRadius = max(sqrt(px_diff(~nanIndices).^2 + py_diff(~nanIndices).^2));
            
            rmsRadius_um = rmsRadius*lensUnitFactor/(10^-6);
            maxRadius_um = maxRadius*lensUnitFactor/(10^-6);
            if maxRadius > maxRadius_All
                maxRadius_All = maxRadius;
            end
            set(subplotPanel,'Title',...
                ['Field: [',num2str(fieldX),',',num2str(fieldY),'] ',fieldUnitTextShort,...
                ', Wav: ',num2str(wav),' ', wavUnitTextShort,...
                ', RMS Radius: ',num2str(rmsRadius_um),' ', 'um',...
                ', Max Radius: ',num2str(maxRadius_um),' ', 'um']);
            
            % Plot airy disc
            colormap(subplotAxes(wavIndex,fieldIndex),currentColorMap);
            axis(subplotAxes(wavIndex,fieldIndex) ,'equal');
            hold on;
            
            % Write the text output
            spotDiagramPlusText = char(spotDiagramPlusText,...
                            ['-------------------------------------',...
                            '--------------------------------------'],...
                            ['Field point index : ',num2str(fieldIndex),'([',num2str(fieldX),',',num2str(fieldY),'] ',fieldUnitTextShort,')'],...
                            ['Wavelength index : ',num2str(wavIndex),'(',num2str(wav),' ',wavUnitTextShort,')'],...
                            ['Centriod (X,Y) : [',num2str(xCentroid),',',num2str(yCentroid),'] ',lensUnitTextShort,')'],...
                            ['RMS Spot radius : ',num2str(rmsRadius_um), ' um'],...
                            ['Maximum geometrical spot radius : ',num2str(maxRadius_um), ' um']);
                        
                        
        end
    end
    if maxRadius_All
        for wavIndex = 1:nWav
            for fieldIndex = 1:nField
                hold(subplotAxes(wavIndex,fieldIndex), 'on');
                xlim(subplotAxes(wavIndex,fieldIndex),[-maxRadius_All*1.1, maxRadius_All*1.1]);
                ylim(subplotAxes(wavIndex,fieldIndex),[-maxRadius_All*1.1, maxRadius_All*1.1]);
            end
        end
    end
    
    if dispText
        set(textHandle,'String',spotDiagramPlusText);
    end

end