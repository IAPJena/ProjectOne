function plotPhaseMap(optSystem,surfIndex,wavelengthIndices,...
        fieldIndices,sampleGridSize,plotPanelHandle)
    % Displays the phase map of the system (or subsystem before a particular
    % surface in the system) over the pupil area for a given field point and
    % wavelength.
    
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
    % Feb 18,2014   Worku, Norman G.     Vectorized version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Default Inputs
    if nargin < 5
        disp('Error: The function requires atleast 6 arguments, optSystem,',...
            ' surfIndex, wavLen, fieldPointXY, sampleGridSize.');
        return;
    elseif nargin == 5
        plotPanelHandle = uipanel('Parent',figure('Name','Phase Map'),'Units','normalized',...
            'Position',[0,0,1,1]);
    end
    
    
    numberOfRays = (sampleGridSize)^2;
    samplingType = 'Cartesian';
    
    % polarizedRayTracerResult =  nSurf X nRay X nField X nWav
    endSurface = surfIndex;
    
    rayTraceOptionStruct = RayTraceOptionStruct();
    rayTraceOptionStruct.ConsiderSurfAperture = 1;
    rayTraceOptionStruct.ConsiderPolarization = 1;
    rayTraceOptionStruct.RecordIntermediateResults = 0;
    
    [polarizedRayTracerResult,pupilMeshGrid,outsidePupilIndices] = multipleRayTracer(optSystem,wavelengthIndices,...
        fieldIndices,sampleGridSize,sampleGridSize,samplingType,rayTraceOptionStruct,endSurface);
    
    % Spatial Distribution of Amplitude transmission of the system
    % in pupil coordinate
    nRay = size(polarizedRayTracerResult,2);
    nField = size(polarizedRayTracerResult,3);
    nWav = size(polarizedRayTracerResult,4);
    X = pupilMeshGrid(:,:,1);
    Y = pupilMeshGrid(:,:,2);
    
    % Generate a new panel for each field and wavelength combination to displa
    % ay the phase map in the subplots.
    for wavIndex = 1:nWav
        for fieldIndex = 1:nField
            % totalPMatrix = 3 x 3 x nRay matrix of total P matrix
            totalPMatrix = squeeze(getAllSurfaceTotalPMatrix(...
                polarizedRayTracerResult(2),0,fieldIndex,wavIndex));
            
            % create pannel for each wavelength-field points
            subplotPanel = uipanel('Parent',plotPanelHandle,...
                'Units','Normalized',...
                'Position',[(wavIndex-1)/nWav,(nField-fieldIndex)/nField,...
                min([1/nWav,1/nField]),min([1/nWav,1/nField])],...
                'Title',['WaveLen Index : ', num2str(wavIndex), ...
                ' & Field Index : ',num2str(fieldIndex)]);
            
            for k1=1:1:3
                for k2=1:1:3
                    % create panels and axes for each subplots
                    subsubplotPanel = uipanel('Parent',subplotPanel,...
                        'Units','Normalized',...
                        'Position',[0.05+(k2-1)*0.3,0.05+(3-k1)*0.3,0.3,0.3]);
                    subsubplotAxes = axes('Parent',subsubplotPanel,...
                        'Units','Normalized',...
                        'Position',[0,0,1,1]);
                    
                    % Initialize all values to zero
                    argP = X.*0;
                    argP(~outsidePupilIndices) = (squeeze(angle(totalPMatrix(k1,k2,:))))';
                    surf(subsubplotAxes,X, Y, argP*180/pi,'EdgeColor', 'None', 'facecolor', 'interp');
                    view(2);
                    axis ('off');
                end
            end
            hold on;
        end
    end
    set(gcf,'Name',['Phase Map at surface : ',num2str(surfIndex)]);
end
