function draw = plotSystemLayout( optSystem,rayPathMatrix,...
        plotIn2D,axesHandle,nPoints1,nPoints2)
    % plotSystemLayout: Drwas a 3D or 2D layout diagram
    % Inputs
    %   opticalSystem: the optical system object
    %   rayPathMatrix:  3 dimensional matrix of dimensions(nNonDummySurface X 3 X nRay)
    %                   Matrix of ray itersection points to be drwan.
    %   axesHandle: axes on to plot the layout
    %   plotIn2D: Plot the YZ cross section in 2D layout
    %   nPoints1,nPoints2: Number of sampling points to plot each surface
    % Output
    %   draw: indicate success (1) or failure (0) of the function plotSystemLayout
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %
    
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
    % Oct 14,2015   Worku, Norman G.     Allowed to specify number of points 
    %                                    to use for surface plots
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    drawEdge = 1;
    % Check for inputs deafualt inputs
    if nargin < 1
        disp(['Error: The function needs atleast the optical system.']);
        return;
    end
    if nargin < 2
        % No rays paths are given
         rayPathMatrix = NaN;
    end
    if nargin < 3
        plotIn2D = 1;
    end
    if nargin < 4
        axesHandle = axes('Parent',figure,'Units','normalized',...
            'Position',[0.05,0,0.95,1]);
    end
    if nargin < 5
%         nPoints1 = 30;
        nPoints1 = 150;
    end
    if nargin < 6
%         nPoints2 = 30; % Small number of sampling points create some
%         probelms in system layout drawing
        nPoints2 = 150;
    end
    
    NonDummySurfaceArray =  getNonDummySurfaceArray (optSystem);
    drawSurfaceArray(NonDummySurfaceArray,plotIn2D,nPoints1,nPoints2,...
        axesHandle,drawEdge);
    hold on;

    % Draw rays over the system layout
    if nargin>1 && length(rayPathMatrix)~=1  % NaN is double and its length is 1
        % Use different color for diffrent wavelengths and different line style for
        % different field points.
        nRay = size(rayPathMatrix,3);
        nField = size(rayPathMatrix,4);
        nWav = size(rayPathMatrix,5);
        
        availableLineColors = repmat({'b','g','r','c','m','y'},1,20); % 7*20 = 140
        lineColors = availableLineColors(1:nWav*nField);
        
        for wavIndex = 1:nWav
            for fieldIndex = 1:nField
                lineColor = char(lineColors((fieldIndex-1)*nWav + wavIndex));
                
                XPointsMatrix = permute(rayPathMatrix(1,:,:,fieldIndex,wavIndex),[2,3,1]);
                YPointsMatrix = permute(rayPathMatrix(2,:,:,fieldIndex,wavIndex),[2,3,1]);
                ZPointsMatrix = permute(rayPathMatrix(3,:,:,fieldIndex,wavIndex),[2,3,1]);
                if plotIn2D
                    plot(axesHandle,ZPointsMatrix,YPointsMatrix,lineColor); hold on;
                else
                    plot3(axesHandle,XPointsMatrix,ZPointsMatrix,YPointsMatrix,lineColor); hold on;
                end
            end
        end
    end
    
    if plotIn2D
        % draw optical axis
        hold on;
        xlabel(axesHandle,'Z-axis','fontweight','bold','Color','k');
        ylabel(axesHandle,'Y-axis','fontweight','bold','Color','k');
        title(axesHandle,'System 2D Layout in YZ plane','Color','k');
        set(axesHandle, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k');
        grid(axesHandle,'on');
        view([0, 90]);
        box(axesHandle,'On')
        axis equal
        hold off;
    else
        % draw optical axis
        hold on;
        set(axesHandle, 'YDir','reverse');
        xlabel(axesHandle,'X-axis','fontweight','bold','Color','k');
        ylabel(axesHandle,'Z-axis','fontweight','bold','Color','k');
        zlabel(axesHandle,'Y-axis','fontweight','bold','Color','k');
        view([-110, 30]);
        title(axesHandle,'System 3D Shaded Model','Color','k');
        set(axesHandle, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k');
        grid(axesHandle,'on');
        box(axesHandle,'On')
        hold off;
%         camlight
        lighting gouraud
    end
    
    axis equal
    draw = 1;
    hold off;

end