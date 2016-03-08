function [ isInsideTheDrawnAperture ] = IsInsideTheDrawnAperture...
        ( drawnApertureShape,drawnApertureDiameterXY, xyVector )
    %ISINSIDETHEDRAWNAPERTURE Determines weather the given poitns are
    %inside the drawn apperture
    
    switch (drawnApertureShape)
        case {[1],[2]}%{'elliptical','circular'}
            semiDiamX = 0.5*drawnApertureDiameterXY(1);
            semiDiamY = 0.5*drawnApertureDiameterXY(2);
            pointX = xyVector(:,1);
            pointY = xyVector(:,2);
            isInsideTheDrawnAperture = (((pointX).^2)/semiDiamX^2) + (((pointY).^2)/semiDiamY^2) < 1  ;
        case 3 %'rectangular'
            semiDiamX = 0.5*drawnApertureDiameterXY(1);
            semiDiamY = 0.5*drawnApertureDiameterXY(2);
            pointX = xyVector(:,1);
            pointY = xyVector(:,2);
            isInsideTheDrawnAperture = abs(pointX) < semiDiamX &...
                abs(pointY) < semiDiamY;
        otherwise
    end
    
    
end

