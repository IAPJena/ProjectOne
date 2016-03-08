function plotFootprintDiagram(optSystem,surfIndex,wavelengthIndices,...
        fieldIndices,numberOfRays1,numberOfRays2,PupSamplingType,...
        axesHandle)
    % Displays the footprint of the beam superimposed on any surface. Used for
    % showing the effects of vignetting and for checking surface apertures.
    % The graph will be in the local cooordinate of the surface.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Default Inputs
    if nargin < 7
        disp('Error: The function requires atleast 6 arguments, optSystem,',...
            ' surfIndex, wavLen, fieldPointXY, numberOfRays1,numberOfRays2, PupSamplingType.');
        return;
    elseif nargin == 7
        axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.1,0.1,0.8,0.8]);
    else
        
    end
    lensUnitFactor = getLensUnitFactor(optSystem);
    NonDummySurfaceIndices = getNonDummySurfaceIndices(optSystem);
    if ~find(ismember(NonDummySurfaceIndices,surfIndex))
        disp('Error:No ray trace data for Dummy surfaces');
        return;
    end
    nonDummySurfacesBeforeCurrentSurface = sum(NonDummySurfaceIndices<=surfIndex);
    dummySurfacesBeforeCurrentSurface = surfIndex - nonDummySurfacesBeforeCurrentSurface;
    % Assign different symbals and colors for spots of d/t wavelengths
    % and feild points respectively
    % availableSpotSymbal = repmat(['*','o','v','x','s','+','.','d','^','<','>'],1,9); % 11*9 = 99
    availableSpotColor = repmat(['b','k','r','g','c','m'],1,20); % 7*20 = 140
    % spotSymbal = availableSpotSymbal(1:size(fieldPointXY,2));
    spotColorList = availableSpotColor(1:length(wavelengthIndices)*length(fieldIndices));
    
    cla(axesHandle,'reset')
    
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
    surfAperture = currentSurface.Aperture;
    nPoints1 = 200;
    nPoints2 = 200;
    xyCenterPoint = [0,0];
    plotAperture( surfAperture,nPoints1,nPoints2,xyCenterPoint,axesHandle );
    hold on
    
    % Spatial Distribution of spot diagram in a given surface
    % Use different color for diffrent wavelengths and different symbal for
    % different field points.
    %     entrancePupilRadius = (getEntrancePupilDiameter(optSystem))/2;
    nSurfaceResultRecorded = size(polarizedRayTracerResult,1);
    nRay = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfPupilPoints;
    nField = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfFieldPoints;
    nWav = polarizedRayTracerResult(1).FixedParameters.TotalNumberOfWavelengths;
    SurfaceCoordinateTM = currentSurface.SurfaceCoordinateTM;
    
    surfIndexWithOutDummy = surfIndex-dummySurfacesBeforeCurrentSurface;
    
    for wavIndex = 1:nWav
        for fieldIndex = 1:nField
            [ globalIntersectionPoints ] = squeeze(...
                getAllSurfaceRayIntersectionPoint( polarizedRayTracerResult(2),...
                0,fieldIndex,wavIndex));
            % convert from global to local coordinate of the surface
            localIntersectionPoints = globalToLocalPosition...
                (globalIntersectionPoints, SurfaceCoordinateTM);
            % Covert from meter to lens unit
            px = localIntersectionPoints(1,:); 
            py = localIntersectionPoints(2,:);
            
            currentSpotColor = spotColorList(fieldIndex + (wavIndex-1)*nField);
            currentSpotSymbal = '.';
            plot(axesHandle,px,py,[currentSpotColor,currentSpotSymbal]);
            hold on;
        end
    end
    
    axis equal;
    xlabel(axesHandle,'X Coordinate','FontSize',12);
    ylabel(axesHandle,'Y Coordinate','FontSize',12);
    title(axesHandle,['Footprint Diagram at surface : ',num2str(surfIndex)],'FontSize',12)
    
end