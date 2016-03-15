function plotSpotDiagramPlus(optSystem,surfIndex,wavelengthIndices,...
        fieldIndices,numberOfRays1,numberOfRays2,PupSamplingType,...
        radialDependence,azimuthalDependence,...
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
    if nargin < 9
        disp('Error: The function requires atleast 6 arguments, optSystem,',...
            ' surfIndex, wavLen, fieldPointXY, numberOfRays1,numberOfRays2, PupSamplingType.');
        return;
    elseif nargin == 9
        plotPanelHandle = uipanel('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
        dispText = 0;
    elseif nargin == 10
        dispText = 0;
    elseif nargin == 11
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
    spotDiagramColorMap = 'jet';
    cla(allchild(plotPanelHandle),'reset')
    
    % polarizedRayTracerResult =  2 X nRay X nField X nWav
    endSurface = surfIndex;
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderPolarization = 0;
    rayTraceOptionStruct.ConsiderSurfaceAperture = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 0;
    
    polarizedRayTracerResult = multipleRayTracer(optSystem,wavelengthIndices,...
        fieldIndices,numberOfRays1,numberOfRays2,PupSamplingType,rayTraceOptionStruct,endSurface);
    
    % Draw the aperture
    currentSurface = getSurfaceArray(optSystem,surfIndex);
    
    % Spatial Distribution of spot diagram in a given surface
    nSurfaceResultRecorded = size(polarizedRayTracerResult,1);
    nRay = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfPupilPoints;
    nField = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfFieldPoints;
    nWav = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfWavelengths;
    pupilCoordinates = polarizedRayTracerResult(1).FixedParameters.PupilCoordinates;
    pupilNormalizationFactor = polarizedRayTracerResult(1).FixedParameters.PupilNormalizationFactor;
    [pup_theta,pup_rho] = cart2pol(pupilCoordinates(1,:),pupilCoordinates(2,:));
    % In optics positive angle is usually measured in deg from +y axis in CW
    % direction
    pup_theta = -pup_theta*180/pi;
    pup_theta = pup_theta + 90;
    pup_theta(pup_theta<0) = pup_theta(pup_theta<0) + 360;
    
    SurfaceCoordinateTM = currentSurface.SurfaceCoordinateTM;
    surfIndexWithOutDummy = surfIndex-dummySurfacesBeforeCurrentSurface;
    maxRadius_All = 0;
    spotDiagramPlusText = '';
    
    nLevels = length(pup_rho);
    smallestDotSize = 5;
    largestDotSize = 50;
    currentColorMap = spotDiagramColorMap;
    if (radialDependence == 2) ||(azimuthalDependence == 2)
        RGBtriplets = computeColorMap(currentColorMap,nLevels);
        sortedRGBtriplet = ones(length(pup_rho),3);
        if (radialDependence == 2)
            [~,sorted_Index_pup_rho] = sort(pup_rho);
            sortedRGBtriplet(sorted_Index_pup_rho,:) = RGBtriplets;
        elseif (azimuthalDependence == 2)
            [~,sorted_Index_pup_theta] = sort(pup_theta);
            sortedRGBtriplet(sorted_Index_pup_theta,:) = RGBtriplets;
        else
            sortedRGBtriplet = [0,0,1];
        end
    else
        sortedRGBtriplet = [0,0,1];
    end
    if (radialDependence == 3) ||(azimuthalDependence == 3)
        dotSizes = (linspace(smallestDotSize,largestDotSize,nLevels))';
        sortedDotSizes = ones(1,length(pup_theta));
        if (radialDependence == 3)
            [~,sorted_Index_pup_rho] = sort(pup_rho);
            sortedDotSizes(sorted_Index_pup_rho) = dotSizes;
        elseif (azimuthalDependence == 3)
            [~,sorted_Index_pup_theta] = sort(pup_theta);
            sortedDotSizes(sorted_Index_pup_theta) = dotSizes;
        else
            sortedDotSizes = 10;
        end
    else
        sortedDotSizes = 10;
    end
    for wavIndex = 1:nWav
        for fieldIndex = 1:nField
            % create panels and axes for each subplots
            subplotPanel = uipanel('Parent',plotPanelHandle,...
                'FontSize',10,'Units','Normalized',...
                'Position',[(fieldIndex-1)*1/nField,(nWav-wavIndex)*1/nWav,1/nField,1/nWav]);
            subplotAxes(wavIndex,fieldIndex) = axes('Parent',subplotPanel,...
                'Units','Normalized',...
                'Position',[0.1,0.1,0.9,0.9]);
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
            currentSpotSymbal = '.';
            
            scatter3(subplotAxes(wavIndex,fieldIndex),px_diff,py_diff,...
                [1:length(px_diff)],... % The third dimension holds the index of the current dot
                sortedDotSizes,... % Dot size changing with the angle from x axis in the pupil
                sortedRGBtriplet,currentSpotSymbal); % Dot color changing with the radius of the point in the pupil
            
            view(subplotAxes(wavIndex,fieldIndex),2);
            
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
            xlabel(subplotAxes(wavIndex,fieldIndex),['X (',lensUnitTextShort,')']);
            ylabel(subplotAxes(wavIndex,fieldIndex),['Y (',lensUnitTextShort,')']);
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
            
            % Store the dotInformationMatrix for later use
            % 4 X nRay  (delX, delY, pupilX, pupilY for all rays)
            dotInformationMatrix = [px_diff;py_diff;...
                pupilCoordinates(1:2,:)/pupilNormalizationFactor;...
                pup_rho/pupilNormalizationFactor;pup_theta];
            setappdata(subplotAxes(wavIndex,fieldIndex),'dotInformationMatrix',dotInformationMatrix);
            
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
    
    % Enable data cursor mode so that user can click on each dot and see
    % all its information
    datacursormode on;
    axesFigure = gcbf; %Handle of figure containing object whose callback is executing
    dcm_obj = datacursormode(axesFigure);
    set(dcm_obj,'UpdateFcn',@myupdatefcn);
    
end
function txt = myupdatefcn(obj,event_obj)
    % Display the position of the data cursor
    % obj          Currently not used (empty)
    % event_obj    Handle to event object
    % output_txt   Data cursor text string (string or cell array of strings).
    
    % Get tha index of point clicked by the user. This is done using the
    % third dim of scatter3 plot to store the index.
    
    % info_struct = getCursorInfo(dcm_obj);
    dotPosition = get(event_obj,'Position');
    currentDotIndex = dotPosition(3);
    
    % Get the parent of the target object (i.e. the axes):
    hAxes = get(get(event_obj,'Target'),'Parent');
    % Get the data stored with the axes object:
    dotInformationMatrix = getappdata(hAxes,'dotInformationMatrix');
    
    txt = {['Del X: ',num2str(dotInformationMatrix(1,currentDotIndex))],...
        ['Del Y: ',num2str(dotInformationMatrix(2,currentDotIndex))],...
        ['Pupil X: ',num2str(dotInformationMatrix(3,currentDotIndex))],...
        ['Pupil Y: ',num2str(dotInformationMatrix(4,currentDotIndex))],...
        ['Pupil Radius: ',num2str(dotInformationMatrix(5,currentDotIndex))],...
        ['Pupil Theta: ',num2str(dotInformationMatrix(6,currentDotIndex))]};
    
    % Enable LATEX formating
    % set(0,'ShowHiddenHandles','on');                       % Show hidden handles
    % hText = findobj('Type','text','Tag','DataTipMarker');  % Find the data tip text
    % set(0,'ShowHiddenHandles','off');                      % Hide handles again
    % set(hText,'Interpreter','tex');                        % Change the interpreter
end