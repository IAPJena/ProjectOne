function [  h ] = plotAperture( surfAperture,nPoints1,nPoints2,xyCenterPoint,axesHandle )
    %PLOTAPERTURE Plots the aperture in the given axis
    % Three regions are colored differently
    % The actual aperture region: White, The outer aperture region: gray
    % and the edge region : dark
    
    if nargin < 5
        figure;
        axesHandle = axes;
    end
    if nargin < 4
        xyCenterPoint = [0,0];
    end
    if nargin < 3
        nPoints2 = 200;
    end
    if nargin < 2
        nPoints1 = 200;
    end
    if nargin < 1
        disp('Error: The function plotAperture needs atleast one input argument');
        h = NaN;
        return;
    end
    
    [outerApertShape,maximumRadiusXY] =  getOuterAperture( surfAperture );
    % Radius of the largest circle circumscribing the aperture
    maxR = sqrt((maximumRadiusXY(1))^2+(maximumRadiusXY(2))^2);
    maxRWithEdge = (1+surfAperture.AdditionalEdge)*maxR;
    %if strcmpi(outerApertShape,'Circular')||strcmpi(outerApertShape,'Elliptical')
    if outerApertShape == 1||outerApertShape == 2 % 'Circular' or 'Elliptical'
        % Draw a circle with radiaus maxR and then cut out the part required
        % using the given X and Y ranges
        %     r = (linspace(-maxR,maxR,nPoints1))';
        
        %         r = (linspace(-maxRWithEdge,maxRWithEdge,nPoints1))';
        r = (linspace(0,maxRWithEdge,nPoints1))';
        %         meanDeltaR = maxRWithEdge/nPoints1;
        %         maxDeltaR = 2*meanDeltaR;
        %         minDeltaR = 0.5*meanDeltaR;
        %         linearlyIncreasingDeltaR = (linspace(minDeltaR,maxDeltaR,nPoints1))';
        %         r =
        phi = (linspace(0,2*pi,nPoints2));
        %         phi = (linspace(-pi,pi,nPoints2));
        xMesh = r*cos(phi);
        yMesh = r*sin(phi);
    else % rectangular
        xgv = linspace(-maxRWithEdge,maxRWithEdge,nPoints1);
        ygv = linspace(-maxRWithEdge,maxRWithEdge,nPoints2);
        [xMesh,yMesh] = meshgrid(xgv,ygv);
    end
    nRow = size(xMesh,1);
    nCol = size(xMesh,2);
    % The x and y points will be completely in unrotated and undecentered
    % aperture coordinate which is assumed by IsInsideTheOuterAperture function
    % below.
    %     xyVector = [xMesh(:),yMesh(:)];
    %     [ isInsideTheOuterAperture ] = IsInsideTheOuterAperture( surfAperture, xyVector );
    %     [ isInsideTheMainAperture ] = IsInsideTheMainAperture( surfAperture, xyVector );
    %     [ isInsideTheAdditionalEdge ] = IsInsideTheAdditionalEdge( surfAperture, xyVector );
    
    xyMesh = cat(3,xMesh,yMesh);
    [ isInsideTheOuterAperture ] = IsInsideTheOuterAperture( surfAperture, xyMesh );
    [ isInsideTheMainAperture ] = IsInsideTheMainAperture( surfAperture, xyMesh );
    [ isInsideTheAdditionalEdge ] = IsInsideTheAdditionalEdge( surfAperture, xyMesh );
    colorData = yMesh*NaN;
    % Remove those points outside aperture + edge
    isInsideTheOuterApertureWithEdge = (isInsideTheOuterAperture | isInsideTheAdditionalEdge)&(~isInsideTheMainAperture);
    colorData(isInsideTheOuterApertureWithEdge) = 1;
    %         colorData(isInsideTheMainAperture) = NaN;
    %         colorData(isInsideTheAdditionalEdge) = 0.5;
    
    %     xMesh(~isInsideTheOuterApertureWithEdge) = NaN;
    %     yMesh(~isInsideTheOuterApertureWithEdge) = NaN;
    %     colorData(~isInsideTheOuterApertureWithEdge) = NaN;
    
    % Remove the all NaN rows and columns
    %     insideDrawn = reshape(isInsideTheOuterApertureWithEdge,[nRow,nCol]);
    insideDrawn = isInsideTheOuterApertureWithEdge;
    
    %     xMesh(:,~any(insideDrawn,2)) = [];
    %     yMesh(:,~any(insideDrawn,2)) = [];
    %     colorData(:,~any(insideDrawn,2)) = [];
    %
    %     xMesh(~any(insideDrawn,1),:) = [];
    %     yMesh(~any(insideDrawn,1),:) = [];
    %     colorData(~any(insideDrawn,1),:) = [];
    
    % Replace the zeros in colorData wihth NaN so that they will be drwn
    % white
    %     colorData(colorData==0) = NaN;
    h = pcolor(axesHandle,xMesh + xyCenterPoint(1),yMesh + xyCenterPoint(2),colorData);
    set(h, 'EdgeColor', 'none');
end

