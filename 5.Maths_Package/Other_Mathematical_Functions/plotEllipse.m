function plotEllipse(semiMajorAxis,semiMinorAxis,centerX,centerY,orientationAngleInDeg,direction,axesHandle)
    % plotEllipse: plots an ellipse on a given axes from its parameters
    % Inputs: (All should be N x 1 vector
    %   [semiMajorAxis,semiMinorAxis,centerX,centerY,orientationAngleInDeg,direction,axesHandle]
    %   direc: +1 or -1 determining color to differentiate the
    %          clockwise and counterclockwise roatations.
    % Outputs:
    %   No outputs
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Parametric Equation of an Ellipse with semiMajor = a, and semiMinor = b
    % (generally rotated by angle d, and shifted by (cx,cy))
    % Parameter t = [0:2*pi]
    % x = a*cos(t)*cos(d) - b*sin(t)*sin(d) + cx
    % y = a*cos(t)*sin(d) + b*sin(t)*cos(d) + cy
    % Modified version of Ref: http://www.mathopenref.com/coordparamellipse.html
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % figure; axesH = axes;a = 5;b = 2; cx = 0; cy = 0; angle = -45; direc = 1;
    % plotEllipse(a,b,cx,cy,angle,direc,axesH)
    
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
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if nargin < 1
        semiMajorAxis = 2;
    end
    if nargin < 2
        semiMinorAxis = 1;
    end
    if nargin < 3
        centerX = 0;
    end
    if nargin < 4
        centerY = 0;
    end
    if nargin < 5
        orientationAngleInDeg = 0;
    end
    if nargin < 6
        direction = 1;
    end
    if nargin < 7
        figure;
        axesHandle = axes;
    end
    
    % Determine the size of each inputs
    nsemiMajorAxis = size(semiMajorAxis,1);
    nsemiMinorAxis = size(semiMinorAxis,1);
    ncenterX = size(centerX,1);
    ncenterY = size(centerY,1);
    norientationAngleInDeg = size(orientationAngleInDeg,1);
    ndirection = size(direction,1);
    % The number of array to be initialized is maximum of all inputs
    nMax = max([nsemiMajorAxis,nsemiMinorAxis,ncenterX,ncenterY,norientationAngleInDeg,ndirection]);
    
    % Fill the smaller inputs to have nMax size by repeating their
    % last element
    if nsemiMajorAxis < nMax
        semiMajorAxis = cat(1,semiMajorAxis,repmat(semiMajorAxis(end,:),[nMax-nsemiMajorAxis,1]));
    else
        semiMajorAxis = semiMajorAxis(1:nMax,:);
    end
    
    if nsemiMinorAxis < nMax
        semiMinorAxis = cat(1,semiMinorAxis,repmat(semiMinorAxis(end,:),[nMax-nCent_x,1]));
    else
        semiMinorAxis = semiMinorAxis(1:nMax,:);
    end
    if ncenterX < nMax
        centerX = cat(1,centerX,repmat(centerX(end,:),[nMax-nCent_y,1]));
    else
        centerX = centerX(1:nMax,:);
    end
    if ncenterY < nMax
        centerY = cat(1,centerY,repmat(centerY(end,:),[nMax-nWaist_x,1]));
    else
        centerY = centerY(1:nMax,:);
    end
    if norientationAngleInDeg < nMax
        orientationAngleInDeg = cat(1,orientationAngleInDeg,repmat(orientationAngleInDeg(end,:),[nMax-nWaist_y,1]));
    else
        orientationAngleInDeg = orientationAngleInDeg(1:nMax,:);
    end
    if ndirection < nMax
        direction = cat(1,direction,repmat(direction(end,:),[nMax-nAngle,1]));
    else
        direction = direction(1:nMax,:);
    end
    
    angInRad = orientationAngleInDeg/180*pi;
    nPoints = 100;
    t = (linspace(0,2*pi,nPoints))';%0:0.1:2*pi+0.1;
    
    % Valid inputs which are not NaN
    validIndices = (~isnan(semiMajorAxis)&~isnan(semiMinorAxis));
    if sum(double(validIndices)) == 0
        disp('Error: All of elliplse parameters are NaN.');
        return;
    else
        semiMajorAxis(~validIndices) = [];
        semiMinorAxis(~validIndices) = [];
        centerX(~validIndices) = [];
        centerY(~validIndices) = [];
        angInRad(~validIndices) = [];
        direction(~validIndices) = [];
    end
    x = cos(t)*(semiMajorAxis.*cos(angInRad))' - sin(t)*(semiMinorAxis.*sin(angInRad))' + ones(nPoints,1)*centerX';
    y = cos(t)*(semiMajorAxis.*sin(angInRad))' + sin(t)*(semiMinorAxis.*cos(angInRad))' + ones(nPoints,1)*centerY';
    
    % Plot the CCW and CW ellipses separately
    isCW = (direction==1);
    plot(axesHandle,x(:,isCW),y(:,isCW),'k');
    hold on
    plot(axesHandle,x(:,~isCW),y(:,~isCW),'r');
end
