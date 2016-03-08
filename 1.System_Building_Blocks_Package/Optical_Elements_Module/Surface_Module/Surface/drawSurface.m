function [xyzPoints] = drawSurface(surface,plotIn2D,nPoints1,nPoints2,...
        axesHandle,surfColor,drawnApertureDiameterXY,sectionDrawn)
    % drawSurface: Drwas a single surface in 3D/2D layout diagram
    % Inputs
    %   (surface,plotIn2D,nPoints1,nPoints2,...
    %    axesHandle,surfColor,drawnAperture,sectionDrawn)
    %   NB 1: A negative number can be passed as axes handle to supress
    %   the graphical output.
    %   NB 2: nPoints1,nPoints2: nRadialPoints,nAngularPoints or nPointsX,nPointsY
    % Output
    %   [xyzPoints] : (nPoints1 x nPoints2 x 3) a 3D matrix of points for
    %   the surface
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jun 17,2015   Worku, Norman G.     Make Aperture as objects
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if nargin > 0
        gridType = getGridType(surface);
        if strcmpi(gridType,'Polar')
            nPoints1Default = 64;
            nPoints2Default = 64;
            % nPoints1Default = 44;
            %             nPoints2Default = 44;
        else
            nPoints1Default = 64;
            nPoints2Default = 64;
        end
        [outerApertShape,maximumRadiusXY] = ...
            getOuterAperture( surface.Aperture );
        defaultDrawnApertureDiameterXY = 2*maximumRadiusXY;
    end
    
    if nargin == 0
        disp('Error: The function drawSurface requires the surface object.');
        xyzPoints = NaN;
        return;
    elseif nargin == 1
        plotIn2D = 0;
        nPoints1 = nPoints1Default;
        nPoints2 = nPoints2Default;
        figure;
        axesHandle = axes;
        surfColor = 'interp';
        sectionDrawn = 1;
    elseif nargin == 2
        nPoints1 = nPoints1Default;
        nPoints2 = nPoints2Default;
        figure;
        axesHandle = axes;
        surfColor = 'interp';
        drawnApertureDiameterXY = defaultDrawnApertureDiameterXY;
        sectionDrawn = 1;
    elseif nargin == 3
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        nPoints2 = nPoints2Default;
        figure;
        axesHandle = axes;
        surfColor = 'interp';
        drawnApertureDiameterXY = defaultDrawnApertureDiameterXY;
        sectionDrawn = 1;
    elseif nargin == 4
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        if strcmpi(nPoints2,'default')
            nPoints2 = nPoints2Default;
        end
        figure;
        axesHandle = axes;
        surfColor = 'interp';
        drawnApertureDiameterXY = defaultDrawnApertureDiameterXY;
        sectionDrawn = 1;
    elseif nargin == 5
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        if strcmpi(nPoints2,'default')
            nPoints2 = nPoints2Default;
        end
        surfColor = 'interp';
        drawnApertureDiameterXY = defaultDrawnApertureDiameterXY;
        sectionDrawn = 1;
    elseif nargin == 6
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        if strcmpi(nPoints2,'default')
            nPoints2 = nPoints2Default;
        end
        drawnApertureDiameterXY = defaultDrawnApertureDiameterXY;
        sectionDrawn = 1;
    elseif nargin == 7
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        if strcmpi(nPoints2,'default')
            nPoints2 = nPoints2Default;
        end
        sectionDrawn = 1;
    else
        if strcmpi(nPoints1,'default')
            nPoints1 = nPoints1Default;
        end
        if strcmpi(nPoints2,'default')
            nPoints2 = nPoints2Default;
        end
    end
    
    drawnApertureShape = surface.Aperture.OuterShape;
    if drawnApertureDiameterXY(1) == 0 || drawnApertureDiameterXY(2) == 0
        zLocation = surface.SurfaceCoordinateTM(3,4);
        if plotIn2D
            xyzPoints(1:nPoints1,1,1:2) = 0;
            xyzPoints(1:nPoints1,1,3) = zLocation;
        else
            xyzPoints(1:nPoints1,1:nPoints2,1:2) = 0;
            xyzPoints(1:nPoints1,1:nPoints2,3) = zLocation;
        end
        % Dont draw the surface
        return;
    end
    surfCoordinateTM = surface.SurfaceCoordinateTM();
    surfApert = surface.Aperture;
    apartRadiusXDrawn = 0.5*drawnApertureDiameterXY(1);
    apartRadiusYDrawn = 0.5*drawnApertureDiameterXY(2);
    % In order to allow rotation of apertures about z axis the maximum
    % aperture radius is computed as
    maxR = sqrt((apartRadiusXDrawn)^2+(apartRadiusYDrawn)^2);
    
    
    if strcmpi(gridType,'Polar')
        % Radius of the largest circle circumscribing the aperture
        maxR = sqrt((apartRadiusXDrawn)^2+(apartRadiusYDrawn)^2);
        % Draw a circle with radiaus maxR and then cut out the part required
        % using the given X and Y ranges
        %     r = (linspace(-maxR,maxR,nPoints1))';
        r = (linspace(-maxR,maxR,nPoints1))';
        if plotIn2D
            phi = pi/2;
            xMesh = r*0;
            yMesh = r*1;
        else
            % Any section size can be plotted.
            phi = (linspace(-pi,sectionDrawn*pi,nPoints2));
            xMesh = r*cos(phi);
            yMesh = r*sin(phi);
        end
    else
        if plotIn2D
            yMesh = linspace(-maxR,maxR,nPoints2);
            xMesh = 0*yMesh;
        else
            xgv = linspace(-maxR,maxR,nPoints1);
            ygv = linspace(-maxR,maxR,nPoints2);
            [xMesh,yMesh] = meshgrid(xgv,ygv);
        end        
    end
    
    nRow = size(xMesh,1);
    nCol = size(xMesh,2);
    
    % The x and y points will be completely in unrotated and undecentered
    % aperture coordinate which is assumed by IsInsideTheOuterAperture function
    % below.
    
    xyVector = [xMesh(:),yMesh(:)];
    
    
    [ isInsideTheOuterAperture ] = IsInsideTheOuterAperture( surfApert, xyVector );
    [ isInsideTheDrawnAperture ] = IsInsideTheDrawnAperture( drawnApertureShape,drawnApertureDiameterXY, xyVector );
    
    actualSurfacePointIndices = isInsideTheOuterAperture;
    surfPosition = surfCoordinateTM(1:3,4);
    surfRotation = (surfCoordinateTM(1:3,1:3)); % from local to global
    % Comput the z coordinates using the sag function surface definition file
    apertDecX = surfApert.Decenter(1);
    apertDecY = surfApert.Decenter(2);
    apertRotInrad = (surfApert.Rotation)*pi/180;
    
    % First decenter and then rotate the given points
    xyVector_Decenter = [xyVector(:,1) + apertDecX , xyVector(:,2) + apertDecY];
    rotationMatrix = [cos(apertRotInrad), -sin(apertRotInrad);sin(apertRotInrad), cos(apertRotInrad)];
    

    if isequal(rotationMatrix,eye(2))
        xyVector_final1 = (xyVector)';
    else
        xyVector_final1 = rotationMatrix*(xyVector)';
    end
    xfMesh = reshape(xyVector_final1(1,:),[nRow,nCol]);
    yfMesh = reshape(xyVector_final1(2,:),[nRow,nCol]);
    
    xyCoordinateMeshGrid = cat(3,xfMesh,yfMesh);
    [ surfaceSag1,surfaceSag2 ] = getSurfaceSag(surface,xyCoordinateMeshGrid,...
        actualSurfacePointIndices);
    % At then moment the second sag is not considered
    zfMesh = surfaceSag1;
    
    % Remove those points outside aperture + edge
    xfMesh(~isInsideTheDrawnAperture) = NaN;
    yfMesh(~isInsideTheDrawnAperture) = NaN;
    zfMesh(~isInsideTheDrawnAperture) = NaN;
    
    % Remove the all NaN rows and columns
    insideSurf = reshape(isInsideTheDrawnAperture,[nRow,nCol]);
    xfMesh(:,~any(insideSurf,1)) = [];
    yfMesh(:,~any(insideSurf,1)) = [];
    zfMesh(:,~any(insideSurf,1)) = [];
    
    xfMesh(~any(insideSurf,2),:) = [];
    yfMesh(~any(insideSurf,2),:) = [];
    zfMesh(~any(insideSurf,2),:) = [];
    
    % nRay x 3 matrix
    if isequal(surfRotation,eye(3))
        xyzPointsRotated  = cat(3,xfMesh,yfMesh,zfMesh);
    else
        dim1 = size(xfMesh,1);
        dim2 = size(xfMesh,2);
        xyzPointsLocal = cat(2,xfMesh(:),yfMesh(:),zfMesh(:));
        xyzPointsRotated_temp = xyzPointsLocal *surfRotation;
        xyzPointsRotated = reshape(xyzPointsRotated_temp,[dim1,dim2,3]);
    end
    
    
    xyzPointsTranslated(:,:,1) = xyzPointsRotated(:,:,1) + surfPosition(1);
    xyzPointsTranslated(:,:,2) = xyzPointsRotated(:,:,2) + surfPosition(2);
    xyzPointsTranslated(:,:,3) = xyzPointsRotated(:,:,3) + surfPosition(3);
    xyzPoints = xyzPointsTranslated;
    % Plot the surface on the axes handle
    if (isnumeric(axesHandle) && axesHandle == -1) || isempty(xyzPoints)
        % negative value can be used to supress the output
        
    else
        % now take only Z-Y coordinates for 2D plot
        xfMesh = xyzPoints(:,:,1);
        yfMesh = xyzPoints(:,:,2);
        zfMesh = xyzPoints(:,:,3);
        if plotIn2D
            % No surface drawn
        else %surfColor
            surf(axesHandle,xfMesh,zfMesh,yfMesh,zfMesh,'facecolor','interp' ,...
                'edgecolor','none','facelighting','gouraud',...
                'FaceAlpha', 0.6,'AmbientStrength', 1.0, 'SpecularStrength', 1.0);
        end
        axis equal;
        camlight
        lighting gouraud
    end
    
end

