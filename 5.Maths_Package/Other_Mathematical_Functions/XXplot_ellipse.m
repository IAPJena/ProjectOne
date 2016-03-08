function plot_ellipse(axesHandle,a,b,cx,cy,angle,direc)
    % plot_ellipse: plots an ellipse on a given axes from its parameters
    % Inputs:
    %   axesHandle: handle of axes object on which to plot
    %   a: semimajor axis
    %   b: semiminor axis
    %   cx: horizontal center
    %   cy: vertical center
    %   angle: orientation ellipse in degrees from the major axis.
    %   direc: +1 or -1 determining color to differentiate the
    %          clockwise and counterclockwise roatations.
    % Outputs:
    %   No outputs

    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Parametric Equation of an Ellipse
    % Ref: http://www.mathopenref.com/coordparamellipse.html
    % An ellipse can be defined as the locus of all points that satisfy the equations
    % x = a cos t 
    % y = b sin t
    % where:
    % x,y are the coordinates of any point on the ellipse, 
    % a, b are the radius on the x and y axes respectively, ( * See radii notes below ) 
    % t is the parameter, which ranges from 0 to 2pi radians. It is the so
    % called Eccentric anomaly

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	% figure; axesH = axes;a = 5;b = 2; cx = 0; cy = 0; angle = -45; direc = 1; 
    % plot_ellipse(axesH,a,b,cx,cy,angle,direc)

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
    angle = angle/180*pi;
    t = 0:0.1:2*pi+0.1;
    
    % Valid inputs which are not NaN
    validIndices = find(~isnan(a)&~isnan(b));
    if isempty(validIndices)
        disp('Error: All of elliplse parameters are NaN.');
        return;
    else
       a = a(validIndices);
       b = b(validIndices);
    end
    hold on;
    x = arrayfun(@(ai) ai*cos(t),a,'UniformOutput',false); 
    y = arrayfun(@(bi) bi*sin(t),b,'UniformOutput',false);
    ellColor = arrayfun(@(dir) ellipseColor(dir),direc,'UniformOutput',false);
    
    xyRotated = cellfun(@(xpts,ypts,ang) ...
        [xpts',ypts']*[cos(ang), sin(ang); -sin(ang), cos(ang)],...
        x,y,num2cell(angle),'UniformOutput',false);
    cellfun(@(xyPts,centX,centY,color) patch(...
        xyPts(:,1) + repmat(centX,size(xyPts,1),1),...
        xyPts(:,2) + repmat(centY,size(xyPts,1),1),...
        'w','EdgeColor',color,'Parent', axesHandle),...
        xyRotated,num2cell(cx),num2cell(cy),ellColor);
end   
    function color = ellipseColor(dir)
        if dir == 1
            color = 'k';
        elseif dir == -1
            color = 'r';
        end 
    end