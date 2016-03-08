function [surfaceCoordinateTM,nextReferenceCoordinateTM] = TiltAndDecenter...
        (surf,refCoordinateTM,prevThickness)
    % TiltAndDecenter: Compute the coordinate transformation matrix
    % of the surface.
    % Inputs:
    %   (surf,refCoordinateTM,~,prevThickness)
    % Outputs:
    %   [surfaceCoordinateTM,nextReferenceCoordinateTM]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    
    % For detailed see the documentation of the
    % CoordinateTransformationMatrix function
    
    Tx = surf.Tilt(1);
    Ty = surf.Tilt(2);
    Tz = surf.Tilt(3);
    
    Dx = surf.Decenter(1);
    Dy = surf.Decenter(2);
    Dz = prevThickness;
    
    tiltMode = surf.TiltMode;
    orderString = GetSupportedTiltDecenterOrder(surf.TiltDecenterOrder);
    orderCellArray = {orderString(1:2),orderString(3:4),...
        orderString(5:6),orderString(7:8),orderString(9:10),orderString(11:12)};
    surfaceCoordinateTM = ...
        computeCoordinateTransformationMatrix...
        (Tx,Ty,Tz,Dx,Dy,Dz,orderCellArray,refCoordinateTM);
    
    % coordinate transformation matrix for coordinate after the surface calculations
    switch tiltMode
        case 1 %'DAR'
            % Reference axis for next surfaces starts at current
            % surface vertex and oriented in the current
            % reference axis
            nextReferenceCoordinateTM = refCoordinateTM;
            nextReferenceCoordinateTM(1:3,4) = surfaceCoordinateTM(1:3,4)-[Dx;Dy;0];
        case 2 %'NAX'
            % Reference axis for next surfaces starts at current
            % surface vertex and oriented in the current surfaces
            % local axis
            nextReferenceCoordinateTM = surfaceCoordinateTM;
        case 3 %'BEN'
            % Apply Tx and Ty again for the new axis
            % Compute Tz to readjust the new axis so that the meridional
            % plane remains meridional after BENd (OpTaLix)
            Tz = acos((cos(Tx)+cos(Ty))/(1+ cos(Tx)*cos(Ty)));
            Dx=0; Dy=0; Dz=0;
            nextReferenceCoordinateTM = computeCoordinateTransformationMatrix...
                (Tx,Ty,Tz,Dx,Dy,Dz,orderCellArray,surfaceCoordinateTM);
    end
end

