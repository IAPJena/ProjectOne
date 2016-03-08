function [ drawn ] = plotCircle( x,y,r,axesHandle )
%PLOTCIRCLE Plots a circle with given center and radius on the axes handle 

% Default arguments
if nargin < 3
    disp('Error: The function needs atleast x,y and r as input arguments.');
    return;
elseif nargin == 3
    axesHandle = gca;
end

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
plot(axesHandle,xunit, yunit);
end

