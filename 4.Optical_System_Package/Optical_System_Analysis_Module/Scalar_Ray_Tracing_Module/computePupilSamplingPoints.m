function [ pupilSamplingPoints,pupilMeshGrid,outsidePupilIndices ] = computePupilSamplingPoints...
        (nPoints1,nPoints2,pupilSamplingType,pupilZLocation,pupilRadiusInX,pupilRadiusInY,pupilShape)
    % computePupilSamplingPoints:  Returns coordinates of pupil sampling points
    % Inputs:
    %   nPoints1,nPoints2: Number of pupil sampling points in x and y for cartesian
    %   (or in radial and angular direction for polar)
    %   pupilZLocation: Location of entrance pupil from the first lens surface
    %   pupilRadiusInX,pupilRadiusInY: The radius of the entrance pupil
    %   pupilSamplingType: Type of pupil sampling used
    %   pupilShape: Shape of the entracen pupil. Currenlty only circular is
    %   being used.
    % Outputs:
    %   pupilSamplingPoints: 3 x nRay matrix containg values of pupil sampling
    %   coordinates.
    %   pupilMeshGrid: the pupil sampling points placed in the form of mesh grid
    %   for plotting. Used in cartesian or polar coordinates
    %  outsidePupilIndices: indices of the mesh grid which are outside
    %  the pupil aperture area area
    
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
    % Nov 02, 2014  Worku, Norman G.     Added polar, sagittal+tangential
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Allowed pupilSamplingType = 'Cartesian',
    % 'Polar','Tangential','Sagittal','Cross','Random',
    if isnumeric(pupilSamplingType)
        pupilSamplingTypeString = GetSupportedPupilSamplingTypes(pupilSamplingType);
    else
        pupilSamplingTypeString = pupilSamplingType;
    end
    if ~strcmpi(pupilSamplingTypeString,'Polar')
        % Make sure that the samplign points are odd so that one f the pupil
        % sampling point will go through origin
        if ~mod(nPoints1,2)
            nPoints1 = nPoints1 + 1;
        end
        if ~mod(nPoints2,2)
            nPoints2 = nPoints2 + 1;
        end
    end
    
    switch lower(pupilSamplingTypeString)
        case lower({'Cartesian','Rectangular'})
            nPointsX = nPoints1;
            nPointsY = nPoints2;
            if nPointsX == 1
                xgv = 0;
            else
                xgv = linspace(-pupilRadiusInX,pupilRadiusInX,nPointsX);
            end
            if nPointsY == 1
                ygv = 0;
            else
                ygv = linspace(-pupilRadiusInY,pupilRadiusInY,nPointsY);
            end
            [x,y] = meshgrid(xgv,ygv);
            pupilMeshGrid = cat(3,x,y);
            
            % Convert the mesh grid to 1D vector
            xCoord = x(:);
            yCoord = y(:);
            % Remove those coordinates outside the pupil area
            switch lower(pupilShape)
                case lower('Rectangular')
                    outsidePupilIndices = (abs(xCoord)>pupilRadiusInX)|(abs(yCoord)>pupilRadiusInY);
                    xCoord(outsidePupilIndices) = [];
                    yCoord(outsidePupilIndices) = [];
                case lower({'Circular','Elliptical'})
                    outsidePupilIndices = ((xCoord.^2)/(pupilRadiusInX^2)+(yCoord.^2)/(pupilRadiusInY^2)>1);
                    xCoord(outsidePupilIndices) = [];
                    yCoord(outsidePupilIndices) = [];
            end
            pupilPoint = [xCoord,yCoord,repmat(pupilZLocation,size(xCoord,1),1)];
        case lower('Polar')
            nPointsRadial = nPoints1;
            nPointsAngular = nPoints2;
            switch lower(pupilShape)
                case lower('Rectangular')
                    % Radius of the largest circle circumscribing the aperture
                    maxR = sqrt((pupilRadiusInX)^2+(pupilRadiusInY)^2);
                case lower({'Circular','Elliptical'})
                    % Maximum of two sides of the aperture
                    maxR = max(pupilRadiusInX,pupilRadiusInY);
            end
            
            % Draw a circle with radiaus maxR and then cut out the part required
            % using the given X and Y ranges
            if nPointsRadial == 1
                r = 0;
            else
                r = (linspace(0,maxR,nPointsRadial))';
            end
            if nPointsAngular == 1
                phi = 0;
            else
                phi = linspace(0,2*pi,nPointsAngular);
                % The last angle is the same as the first so remove it
                phi = phi(1:end-1);
            end
            x = r*cos(phi);
            y = r*sin(phi);
            pupilMeshGrid =  cat(3,x,y);
            % Convert the mesh grid to 1D vector
            xCoord = x(:);
            yCoord = y(:);
            % Remove those coordinates outside the pupil area
            switch lower(pupilShape)
                case lower('Rectangular')
                    outsidePupilIndices = (abs(xCoord)>pupilRadiusInX)||(abs(yCoord)>pupilRadiusInY);
                    xCoord(outsidePupilIndices) = [];
                    yCoord(outsidePupilIndices) = [];
                case lower({'Circular','Elliptical'})
                    outsidePupilIndices = ((xCoord.^2)/(pupilRadiusInX^2)+(yCoord.^2)/(pupilRadiusInY^2)>1);
                    xCoord(outsidePupilIndices) = [];
                    yCoord(outsidePupilIndices) = [];
                    % There will be multiple vectors for aperture center as
                    % so shall be removed except one
                    centerOfApertureIndices = ((xCoord.^2)/(pupilRadiusInX^2)+(yCoord.^2)/(pupilRadiusInY^2)==0);
                    xCoord(centerOfApertureIndices) = [];
                    yCoord(centerOfApertureIndices) = [];
                    % Add a single center point
                    xCoord = [xCoord;0];
                    yCoord = [yCoord;0];
            end
            pupilPoint = [xCoord,yCoord,repmat(pupilZLocation,size(xCoord,1),1)];
        case lower('Tangential')
            nPointsX = 1;
            nPointsY = nPoints2;
            xgv = 0;
            if nPointsY == 1
                ygv = 0;
            else
                ygv = linspace(-pupilRadiusInY,pupilRadiusInY,nPointsY);
            end
            pupilPoint = [zeros(nPointsY,1) ygv' repmat(pupilZLocation,nPointsY,1)];
            pupilMeshGrid(:,:,2) = pupilPoint(:,2);
            pupilMeshGrid(:,:,1) = pupilPoint(:,1);
            outsidePupilIndices = [];
        case lower('Sagittal')
            nPointsX = nPoints1;
            nPointsY = 1;
            if nPointsX == 1
                xgv = 0;
            else
                xgv = linspace(-pupilRadiusInX,pupilRadiusInX,nPointsX);
            end
            ygv = 0;
            pupilPoint = [xgv' zeros(nPointsX,1) repmat(pupilZLocation,nPointsX,1)];
            pupilMeshGrid(:,:,2) = pupilPoint(:,2);
            pupilMeshGrid(:,:,1) = pupilPoint(:,1);
            
            outsidePupilIndices = [];
        case lower('Cross')
            nPointsX = nPoints1;
            nPointsY = nPoints2;
            nPointsTotal = nPoints1*nPoints2;
            if nPointsX == 1
                xgv = 0;
            else
                xgv = linspace(-pupilRadiusInX,pupilRadiusInX,nPointsX);
            end
            if nPointsY == 1
                ygv = 0;
            else
                ygv = linspace(-pupilRadiusInY,pupilRadiusInY,nPointsY);
            end
            pupilPoint = [[xgv';zeros(nPointsY,1)] [zeros(nPointsX,1);ygv'] repmat(pupilZLocation,nPointsX+nPointsY,1)];
            
            pupilMeshGrid(:,:,2) = pupilPoint(:,2);
            pupilMeshGrid(:,:,1) = pupilPoint(:,1);
            
            outsidePupilIndices = [];
        case lower('Random')
            nPointsTotal = nPoints1*nPoints2;
            theta = rand(nPointsTotal,1)*(2*pi);
            pupilRadius = max(pupilRadiusInX,pupilRadiusInY);
            
            r = sqrt(rand(nPointsTotal,1))*pupilRadius;
            randX = r.*cos(theta);
            randY = r.*sin(theta);
            pupilPoint = [randX randY repmat(pupilZLocation,nPointsTotal,1)];
            % Replace the first ray with a cheif ray
            pupilPoint(1,:) = [0,0,pupilZLocation];
            pupilMeshGrid = NaN;
            outsidePupilIndices = NaN;
    end
    
    % Make the output in 3xnRay size
    pupilSamplingPoints = pupilPoint';
end

