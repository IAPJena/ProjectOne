function [edgeSmootheningFunction] = getEdgeSmootheningFunction(...
        xlin,ylin,boarderShape,absouteEdgeValue,actualFieldDiameter)
    %getEdgeSmootheningFunction As sharp edge doesn't exist in physical fields,
    % this function returns a matrix with smooth edge following gaussian curve.
    
    [x,y] = meshgrid(xlin,ylin);
    innerRadiusX = actualFieldDiameter(1)/2;
    innerRadiusY = actualFieldDiameter(2)/2;
    
    % compute the waist radius of gaussian function so that the
    % edge smoothening function falls to zero in the last
    % pixels
    HWHM = ((absouteEdgeValue))/2;
    edgeWaist = HWHM/sqrt(log(2));
    % To make the boarder is smooth lets reduce the edge waist used by half
    %
    edgeWaistUsed =  edgeWaist/2;

    if edgeWaistUsed == 0
        % Avoid division by zero
        edgeWaistUsed = 10^-16;
    end
    a = innerRadiusX;
    b = innerRadiusY;
    switch (boarderShape)
        case 1 % lower('Elliptical')
            % Distance from a point to ellipse along the line
            % connectinf the center with the point
            % = (1-(a*b)/sqrt(xp^2*b^2+yp^2*a^2))*sqrt(xp^2+yp^2)
             distanceFromEllipse = (1-(a*b)./sqrt((x).^2*b^2+(y).^2*a^2)).*sqrt((x).^2+(y).^2);
            distanceFromEllipse((((x).^2)/a^2 + ((y).^2)/b^2) < 1) = 0;
            edgeSmootheningFunction = exp(-(distanceFromEllipse.^2)/edgeWaistUsed^2);
        case 2 % lower('Rectangular')
            distanceFromRectangle = sqrt((((abs((x))-a).^2).*(abs((x))>a))+(((abs((y))-b).^2).*(abs((y))>b)));
            distanceFromRectangle(abs((x))<a & abs((y))<b) = 0;
            edgeSmootheningFunction = exp(-(distanceFromRectangle.^2)/edgeWaistUsed^2);
    end
end

