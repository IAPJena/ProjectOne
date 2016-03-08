function [ xyzPoints,centerPoints] = drawSurfaceArray...
        (surfaceArray,plotIn2D,nPoints1,nPoints2,axesHandle,drawEdge)
    % drawLens: Plots the 3 dimensional lay out of alens in 3d/2d Space
    % given its two surfaces
    % Inputs
    %   surfaceArray: Array of non dummy surface objects of the lens
    %   axesHandle: axes to plot the lens
    %   plotIn2D: Plot the YZ cross section in 2D layout
    %   drawEdge: boolean indicating to draw edge
    %   nPoints1,nPoints2: nRadialPoints,nAngularPoints or nPointsX,nPointsY
    %   NB 1: A negative number can be passed as axes handle to supress
    %   the graphical output.
    % Output
    %   [xyzPoints] : 1 x nSurface cell array where each cell is a
    %                (nPoints1 x nPoints2 x 3) a 3D matrix of points for
    %                each surface
    %   centerPoints : (3 x nSurface) 2D matrix representing the center
    %                   points of each surface
    
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
    if nargin > 0 && strcmpi(getGridType(surfaceArray(1)),'Polar')
        %     nPoints1Default = 17;
        %     nPoints2Default = 33;
        nPoints1Default = 100;
        nPoints2Default = 50;
    else
        nPoints1Default = 75;
        nPoints2Default = 75;
    end
    
    if nargin < 1
        disp('Error: The function drawLens requires aleast surfaceArray object.');
        xyzPoints = NaN;
        return;
    end
    if nargin < 2
        plotIn2D = 0;
    end
    if nargin < 3
        nPoints1 = nPoints1Default;
    end
    if nargin < 4
        nPoints2 = nPoints2Default;
    end
    if nargin < 5
        figure;
        axesHandle = axes;
    end
    if nargin < 6
        drawEdge = 1;
    end
    if strcmpi(nPoints1,'default')
        nPoints1 = nPoints1Default;
    end
    if strcmpi(nPoints2,'default')
        nPoints2 = nPoints2Default;
    end
    
    %%
    nSurface = size(surfaceArray,2);
    surfEdge = zeros(nSurface,1);
    if drawEdge
        for ss = 1: nSurface
            surfEdge(ss) = surfaceArray(ss).Aperture.AdditionalEdge;
        end
    end
    
    sameApertureType = ones(nSurface,1);
    samegetGridType = ones(nSurface,1);
    IsFreeSpace = ones(nSurface,1);
    IsMirror = zeros(nSurface,1);
    
    apartSizeX = zeros(nSurface,1);
    apartSizeY = zeros(nSurface,1);
    apartDecX = zeros(nSurface,1);
    apartDecY = zeros(nSurface,1);
    for ss =  1:nSurface
        
        if ss == 1
            currentGridType = getGridType(surfaceArray(ss));
            currentApertureOuterShape = surfaceArray(ss).Aperture.OuterShape;
        else
            prevGridType = currentGridType;
            prevApertureOuterShape = currentApertureOuterShape;
            
            currentGridType = getGridType(surfaceArray(ss));
            currentApertureOuterShape = surfaceArray(ss).Aperture.OuterShape;
            
            sameApertureType(ss-1) = (prevApertureOuterShape == currentApertureOuterShape);
            samegetGridType(ss-1) = strcmpi(prevGridType,currentGridType);
        end
        IsFreeSpace(ss) = (strcmpi(surfaceArray(ss).Glass.Name,'None')||...
            strcmpi(surfaceArray(ss).Glass.Name,'Air')||...
            isempty((surfaceArray(ss).Glass.Name)));
        IsMirror(ss) = strcmpi(surfaceArray(ss).Glass.Name,'Mirror');
        [outerApertShape{ss},maximumRadiusXY] = getOuterAperture(surfaceArray(ss).Aperture);
        apartSizeX(ss) = (1+surfEdge(ss))*maximumRadiusXY(1);
        apartSizeY(ss) = (1+surfEdge(ss))*maximumRadiusXY(2);
        
        drawnApertureRadiusXY(ss,:) = (1+surfEdge(ss))*maximumRadiusXY;
        
        apartDecX(ss) = surfaceArray(ss).Aperture.Decenter(1);
        apartDecY(ss) = surfaceArray(ss).Aperture.Decenter(2);
        
    end
    
    surfacePointsComputedFlag =  zeros(nSurface,1);
    singletCounter = 0;
    singleSurfaceCounter = 0;
    mirrorCounter = 0;
    
    surfColor = zeros(nSurface,3);
    centerPoints = zeros(3,nSurface);
    for ss =  1:nSurface
        %         %         if mod(ss,4)== 0
        %         %             surfColor(ss,:) = [0,1,0.5];
        %         %         elseif mod(ss,4)== 1
        %         %             surfColor(ss,:) = [0,0.75,0.75];
        %         %         elseif mod(ss,4)== 2
        %         %             surfColor(ss,:) = [0,1,0.75];
        %         %         else
        %         %             surfColor(ss,:) = [0,0.75,1];
        %         %         end
        %         if mod(ss,2)== 0
        %             % Brown scale
        %             surfColor(ss,:) = [139,69,19]/256; % Saddle brown
        %             surfDarkerColor(ss,:) = [139,69,19]/256; % Saddle brown
        %             surfDarkerLighter(ss,:) = [210,105,30]/256; % chocolate
        %         elseif mod(ss,2)== 1
        %             % Gray scale
        %             surfColor(ss,:) = [105,105,105]/256; % dim gray / dim grey
        %             surfDarkerColor(ss,:) = [105,105,105]/256; % dim gray / dim grey
        %             surfDarkerLighter(ss,:) = [119,136,153]/256; % light slate gray
        %         end
        %
        centerPoints(:,ss) = surfaceArray(ss).SurfaceCoordinateTM(1:3,4);
        
        if IsMirror(ss) || IsFreeSpace(ss) || ~sameApertureType(ss) || ~samegetGridType(ss) || nSurface == 1
            if ~surfacePointsComputedFlag(ss)
                singleSurfaceCounter = singleSurfaceCounter + 1;
                % Just compute plot points for the surface as it is
                % Set the aperure sizes to the aperture size
                drawnAperture = [apartSizeX(ss),apartSizeY(ss)];
                %             [outerApertShape,maximumRadiusXY] = getOuterAperture(surfaceArray(ss).Aperture);
                xyzPoints1 = drawSurface(surfaceArray(ss),plotIn2D,nPoints1,nPoints2,...
                    -1,0,2*drawnApertureRadiusXY(ss,:));
                %             xyzPoints(:,:,:,ss) = xyzPoints1;
                xyzPoints{ss+mirrorCounter} = xyzPoints1;
                surfacePointsComputedFlag(ss) = 1;
                
                % Compute the single surface plot points from the xyzPoints1
                if strcmpi(getGridType(surfaceArray(ss)),'Polar')
                    if plotIn2D
                        % Only one angle so take all r for that angle
                        singleSurfaceBoarderX{singleSurfaceCounter} = [xyzPoints1(:,1,1)];
                        singleSurfaceBoarderY{singleSurfaceCounter} = [xyzPoints1(:,1,2)];
                        singleSurfaceBoarderZ{singleSurfaceCounter} = [xyzPoints1(:,1,3)];
                    else
                        % Take all R for maximum r
                        singleSurfaceBoarderX{singleSurfaceCounter} = [xyzPoints1(1,:,1)];
                        singleSurfaceBoarderY{singleSurfaceCounter} = [xyzPoints1(1,:,2)];
                        singleSurfaceBoarderZ{singleSurfaceCounter} = [xyzPoints1(1,:,3)];
                    end
                else
                    singleSurfaceBoarderX{singleSurfaceCounter} = [xyzPoints1(1,:,1),(xyzPoints1(:,end,1))',fliplr(xyzPoints1(end,:,1)),fliplr((xyzPoints1(:,1,1))')];
                    singleSurfaceBoarderY{singleSurfaceCounter}  = [xyzPoints1(1,:,2),(xyzPoints1(:,end,2))',fliplr(xyzPoints1(end,:,2)),fliplr((xyzPoints1(:,1,2))')];
                    singleSurfaceBoarderZ{singleSurfaceCounter}  = [xyzPoints1(1,:,3),(xyzPoints1(:,end,3))',fliplr(xyzPoints1(end,:,3)),fliplr((xyzPoints1(:,1,3))')];
                end
            end
            if IsMirror(ss)
                %             xyzPoints1 = xyzPoints(:,:,:,ss);
                xyzPoints1 = xyzPoints{ss+mirrorCounter};
                mirrorCounter = mirrorCounter + 1;
                % Compute the second surface points
                secondSurface = surfaceArray(ss);
                maxAperture = getMaximumApertureRadius( secondSurface.Aperture );
                
                deltaZ = -((-1)^mirrorCounter)*0.03*maxAperture;
                % Transform the deltaZ to global coordinate
                globalShift = [0,0,deltaZ]*(secondSurface.SurfaceCoordinateTM(1:3,1:3));
                secondSurface.SurfaceCoordinateTM(1:3,4) = ...
                    secondSurface.SurfaceCoordinateTM(1:3,4)+globalShift';
                xyzPoints2 = drawSurface(secondSurface,plotIn2D,nPoints1,nPoints2,...
                    -1,0,2*drawnApertureRadiusXY(ss,:));
                %                 xyzPoints{ss+1+mirrorCounter} = xyzPoints2;
                
                [xyzPoints1_New,xyzPoints2_New] = ...
                    balanceNumberOfSamplingPointsOfTwoSurfaces(xyzPoints1,xyzPoints2);
                xyzPoints1 = xyzPoints1_New;
                xyzPoints2 = xyzPoints2_New;
                
                
                xyzPoints{ss+mirrorCounter} = xyzPoints2;
                
                % Draw the second surface of the mirror now % Not too optimum solution
                % Compute the singlet boarder surface plot points from the
                % xyzPoints1 and xyzPoints2
                if strcmpi(getGridType(secondSurface),'Polar')
                    if plotIn2D
                        % Only one angle so take all r for that angle
                        mirrorBoarderX{mirrorCounter} = [xyzPoints2(:,end,1);flipud(xyzPoints1(:,end,1))];
                        mirrorBoarderY{mirrorCounter} = [xyzPoints2(:,end,2);flipud(xyzPoints1(:,end,2))];
                        mirrorBoarderZ{mirrorCounter} = [xyzPoints2(:,end,3);flipud(xyzPoints1(:,end,3))];
                    else
                        % Take all angle for maximum radius
                        mirrorBoarderX{mirrorCounter} = [xyzPoints2(end,:,1);(xyzPoints1(end,:,1))];
                        mirrorBoarderY{mirrorCounter} = [xyzPoints2(end,:,2);(xyzPoints1(end,:,2))];
                        mirrorBoarderZ{mirrorCounter} = [xyzPoints2(end,:,3);(xyzPoints1(end,:,3))];
                    end
                    
                else
                    mirrorBoarderX{mirrorCounter} = [xyzPoints2(1,:,1),(xyzPoints2(:,end,1))',fliplr(xyzPoints2(end,:,1)),fliplr((xyzPoints2(:,1,1))');...
                        xyzPoints1(1,:,1),(xyzPoints1(:,end,1))',fliplr(xyzPoints1(end,:,1)),fliplr((xyzPoints1(:,1,1))')];
                    mirrorBoarderY{mirrorCounter}  = [xyzPoints2(1,:,2),(xyzPoints2(:,end,2))',fliplr(xyzPoints2(end,:,2)),fliplr((xyzPoints2(:,1,2))');...
                        xyzPoints1(1,:,2),(xyzPoints1(:,end,2))',fliplr(xyzPoints1(end,:,2)),fliplr((xyzPoints1(:,1,2))')];
                    mirrorBoarderZ{mirrorCounter}  = [xyzPoints2(1,:,3),(xyzPoints2(:,end,3))',fliplr(xyzPoints2(end,:,3)),fliplr((xyzPoints2(:,1,3))');...
                        xyzPoints1(1,:,3),(xyzPoints1(:,end,3))',fliplr(xyzPoints1(end,:,3)),fliplr((xyzPoints1(:,1,3))')];
                end
            end
        else
            % Increment the singlet counter
            singletCounter = singletCounter + 1;
            
            % Compute the common aperture size of this surf with next surface
            % and plot both if not ploted yet
            lensXRange = [min([-apartSizeX(ss)+apartDecX(ss),-apartSizeX(ss+1)+apartDecX(ss+1)]),...
                max([apartSizeX(ss)+apartDecX(ss),apartSizeX(ss+1)+apartDecX(ss+1)])];
            lensYRange = [min([-apartSizeY(ss)+apartDecY(ss),-apartSizeY(ss+1)+apartDecY(ss+1)]),...
                max([apartSizeY(ss)+apartDecY(ss),apartSizeY(ss+1)+apartDecY(ss+1)])];
            commonApertureSizeX = (lensXRange(2)-lensXRange(1))/2;
            commonApertureSizeY = (lensYRange(2)-lensYRange(1))/2;
            
            if surfaceArray(ss).Aperture.DrawAbsolute
                
            else
                drawnApertureRadiusXY(ss,:) = [commonApertureSizeX,commonApertureSizeY]';
            end
            
            if ~surfacePointsComputedFlag(ss)
                % Compute the surface plot points and compute the singlet border
                xyzPoints1 = drawSurface(surfaceArray(ss),plotIn2D,nPoints1,nPoints2,...
                    -1,0,2*drawnApertureRadiusXY(ss,:));
                xyzPoints{ss+mirrorCounter} = xyzPoints1;
                surfacePointsComputedFlag(ss) = 1;
            else
                % Compute the surface plot points just for the computation of the singlet border
                xyzPoints1 = drawSurface(surfaceArray(ss),plotIn2D,nPoints1,nPoints2,...
                    -1,0,2*drawnApertureRadiusXY(ss,:));
            end
            if surfaceArray(ss+1).Aperture.DrawAbsolute
                
            else
                drawnApertureRadiusXY(ss+1,:) = [commonApertureSizeX,commonApertureSizeY]';
            end
            
            
            xyzPoints2 = drawSurface(surfaceArray(ss+1),plotIn2D,nPoints1,nPoints2,...
                -1,0,2*drawnApertureRadiusXY(ss+1,:));
            
            
            
            [xyzPoints1_New,xyzPoints2_New] = ...
                balanceNumberOfSamplingPointsOfTwoSurfaces(xyzPoints1,xyzPoints2);
            xyzPoints1 = xyzPoints1_New;
            xyzPoints2 = xyzPoints2_New;
            
            
            surfacePointsComputedFlag(ss+1) = 1;
            xyzPoints{ss+1+mirrorCounter} = xyzPoints2;
            
            % Compute the singlet boarder surface plot points from the
            % xyzPoints1 and xyzPoints2
            if strcmpi(getGridType(surfaceArray(ss)),'Polar')
                if plotIn2D
                    % Only one angle so take all r for that angle
                    singletBoarderX{singletCounter} = [xyzPoints2(:,end,1);flipud(xyzPoints1(:,end,1))];
                    singletBoarderY{singletCounter} = [xyzPoints2(:,end,2);flipud(xyzPoints1(:,end,2))];
                    singletBoarderZ{singletCounter} = [xyzPoints2(:,end,3);flipud(xyzPoints1(:,end,3))];
                else
                    % Take all angle for maximum radius
                    singletBoarderX{singletCounter} = [xyzPoints2(end,:,1);(xyzPoints1(end,:,1))];
                    singletBoarderY{singletCounter} = [xyzPoints2(end,:,2);(xyzPoints1(end,:,2))];
                    singletBoarderZ{singletCounter} = [xyzPoints2(end,:,3);(xyzPoints1(end,:,3))];
                end
            else
                if plotIn2D
                    % In yz plane so take all y
                    singletBoarderX{singletCounter} = ...
                        [xyzPoints2(1,:,1),fliplr(xyzPoints2(end,:,1)),...
                        xyzPoints1(1,:,1),fliplr(xyzPoints1(end,:,1))]';
                    singletBoarderY{singletCounter}  = ...
                        [xyzPoints2(1,:,2),fliplr(xyzPoints2(end,:,2)),...
                        xyzPoints1(1,:,2),fliplr(xyzPoints1(end,:,2))]';
                    singletBoarderZ{singletCounter}  = ...
                        [xyzPoints2(1,:,3),fliplr(xyzPoints2(end,:,3)),...
                        xyzPoints1(1,:,3),fliplr(xyzPoints1(end,:,3))]';
                else
                    singletBoarderX{singletCounter} = ...
                        [xyzPoints2(1,:,1),(xyzPoints2(:,end,1))',fliplr(xyzPoints2(end,:,1)),fliplr((xyzPoints2(:,1,1))');...
                        xyzPoints1(1,:,1),(xyzPoints1(:,end,1))',fliplr(xyzPoints1(end,:,1)),fliplr((xyzPoints1(:,1,1))')];
                    singletBoarderY{singletCounter}  = ...
                        [xyzPoints2(1,:,2),(xyzPoints2(:,end,2))',fliplr(xyzPoints2(end,:,2)),fliplr((xyzPoints2(:,1,2))');...
                        xyzPoints1(1,:,2),(xyzPoints1(:,end,2))',fliplr(xyzPoints1(end,:,2)),fliplr((xyzPoints1(:,1,2))')];
                    singletBoarderZ{singletCounter}  = ...
                        [xyzPoints2(1,:,3),(xyzPoints2(:,end,3))',fliplr(xyzPoints2(end,:,3)),fliplr((xyzPoints2(:,1,3))');...
                        xyzPoints1(1,:,3),(xyzPoints1(:,end,3))',fliplr(xyzPoints1(end,:,3)),fliplr((xyzPoints1(:,1,3))')];
                end
            end
        end
    end
    % Surface Colors
    surfColor = zeros(length(xyzPoints),3);
    surfDarkerColor = surfColor;
    surfDarkerLighter = surfColor;
    for ss =  1:length(xyzPoints)
        %         if mod(ss,4)== 0
        %             surfColor(ss,:) = [0,1,0.5];
        %         elseif mod(ss,4)== 1
        %             surfColor(ss,:) = [0,0.75,0.75];
        %         elseif mod(ss,4)== 2
        %             surfColor(ss,:) = [0,1,0.75];
        %         else
        %             surfColor(ss,:) = [0,0.75,1];
        %         end
        if mod(ss,2)== 0
            % Brown scale
            surfColor(ss,:) = [139,69,19]/256; % Saddle brown
            surfDarkerColor(ss,:) = [139,69,19]/256; % Saddle brown
            surfDarkerLighter(ss,:) = [210,105,30]/256; % chocolate
        elseif mod(ss,2)== 1
            % Gray scale
            surfColor(ss,:) = [105,105,105]/256; % dim gray / dim grey
            surfDarkerColor(ss,:) = [105,105,105]/256; % dim gray / dim grey
            surfDarkerLighter(ss,:) = [119,136,153]/256; % light slate gray
        end
    end
    % Plot all surfaces
    if plotIn2D
        % Plot mirrors
        for ss = 1:mirrorCounter
            patch([mirrorBoarderZ{ss}],[mirrorBoarderY{ss}],[mirrorBoarderX{ss}],'Parent',axesHandle,'FaceColor',surfColor(ss,:));
            hold(axesHandle,'on');
        end
        % Plot singlets
        for ss = 1:singletCounter
            patch([singletBoarderZ{ss}],[singletBoarderY{ss}],[singletBoarderX{ss}],'Parent',axesHandle,'FaceColor',surfColor(ss,:));
            hold(axesHandle,'on');
        end
        % Plot single surfaces
        for ss = 1:singleSurfaceCounter
            plot(axesHandle,[singleSurfaceBoarderZ{ss}],[singleSurfaceBoarderY{ss}],'Color',surfColor(ss,:));
            hold(axesHandle,'on');
        end
        view(axesHandle,[0,-1,1]);
        axis equal
        % draw optical axis
        hold on;
        xlabel(axesHandle,'Z-axis','fontweight','bold','Color','k');
        ylabel(axesHandle,'Y-axis','fontweight','bold','Color','k');
        view(axesHandle,[0, 90]);
        title(axesHandle,'System 2D Layout in YZ plane','Color','k');
        set(axesHandle, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k');
        grid(axesHandle,'on');
        box(axesHandle,'On')
        axis equal
    else
        for ss =  1:length(xyzPoints)
            xyzPointsCurrent = xyzPoints{ss};
            x = xyzPointsCurrent(:,:,1);
            y = xyzPointsCurrent(:,:,2);
            z = xyzPointsCurrent(:,:,3);
            valleyColor = surfDarkerColor(ss,:);
            peakColor = surfDarkerLighter(ss,:);
            nLevels = 100;
            [ C ] = computeSurfaceColor(z,peakColor,valleyColor,nLevels );
            
            surf(axesHandle,x,z,y,C,'Facecolor','interp',...
                'edgecolor','none','FaceAlpha', 0.6);
            hold(axesHandle,'on');
        end
        
        % Plot the edges for matching singlets with slightly darker color
        for ss = 1:singletCounter
            surf(axesHandle,[singletBoarderX{ss}],[singletBoarderZ{ss}],[singletBoarderY{ss}],...
                'facecolor',surfColor(ss,:)/1.5,'edgecolor','none','facelighting','phong','FaceAlpha', 0.5,'AmbientStrength', 0., 'SpecularStrength', 1);
            hold(axesHandle,'on');
        end
        % Plot the edges for mirrors with slightly darker color
        for ss = 1:mirrorCounter
            surf(axesHandle,[mirrorBoarderX{ss}],[mirrorBoarderZ{ss}],[mirrorBoarderY{ss}],...
                'facecolor',surfColor(ss,:)/1.5,'edgecolor','none','facelighting','phong','FaceAlpha', 0.5,'AmbientStrength', 0., 'SpecularStrength', 1);
            hold(axesHandle,'on');
        end
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
    end
    axis equal
    hold off;
    %     camlight
    lighting gouraud
end

function [xyzPoints1_New,xyzPoints2_New] = ...
        balanceNumberOfSamplingPointsOfTwoSurfaces(xyzPoints1,xyzPoints2)
    % If one of the two surfaces is tilted or has large outer
    % aperture size than the other, then the dimensions of
    % xyzPoints1 and xyzPoints2 could be differnnt so that should
    % be corrected. Simply reduce the size of the larger one to the
    % smaller one (this just reduces the sampling points, nothing
    % more).
    nSampleX1 = size(xyzPoints1,1);
    nSampleY1 = size(xyzPoints1,2);
    nSampleX2 = size(xyzPoints2,1);
    nSampleY2 = size(xyzPoints2,2);
    
    xyzPoints1_New = xyzPoints1;
    xyzPoints2_New = xyzPoints2;
    if nSampleX1 < nSampleX2
        pointsTobeRemoved = [2:floor((nSampleX2-2)/(nSampleX2-nSampleX1)):nSampleX2-1];
        xyzPoints2_New(pointsTobeRemoved(1:nSampleX2 - nSampleX1),:,:) = [];
    elseif nSampleX1 > nSampleX2
        pointsTobeRemoved = [2:floor((nSampleX1-2)/(nSampleX1-nSampleX2)):nSampleX1-1];
        xyzPoints1_New(pointsTobeRemoved(1:nSampleX1 - nSampleX2),:,:) = [];
    else
        
    end
    
    if nSampleY1 < nSampleY2
        pointsTobeRemoved = [2:floor((nSampleY2-2)/(nSampleY2-nSampleY1)):nSampleY2-1];
        xyzPoints2_New(:,pointsTobeRemoved(1:nSampleY2 - nSampleY1),:) = [];
    elseif nSampleY1 > nSampleY2
        pointsTobeRemoved = [2:floor((nSampleY1-2)/(nSampleY1-nSampleY2)):nSampleY1-1];
        xyzPoints1_New(:,pointsTobeRemoved(1:nSampleY1 - nSampleY2),:) = [];
    else
        
    end
end