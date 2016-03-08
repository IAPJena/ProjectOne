function transformationMatrix = ...
        computeCoordinateTransformationMatrix(Tx,Ty,Tz,Dx,Dy,Dz,orderCellArray,refCoordinateTM)
    
    % transformationMatrix: computes the coordinate transformation matrix M
    %    (which can be used to transform from global to local coordinate
    %    system after tilt and decenter operations) and given initial coordinate
    %    transfer matrix.
    
    % Inputs
    % Tx,Ty,Tz = tilt angles in degree about x,y and z axis
    % Dx,Dy,Dz = decenter in x,y and z axis. Dz is taken to be the thickness
    % Order: a string indcating the order in which the operations have to be
    % performed. Any arbitrary order is possible
    % refCoordinateTM: the cordinate transformation matrix describing the
    % initial refernce coordinate
    
    % Outputs
    % transformationMatrix: is a 4x4 matrix, the left upper 3x3 matrix represent
    % rotation matrix from global to local coordinate and the last
    % column gives the decenter of the current coordinates and the last
    % row is just for maths
    
    % Example call:
    % % Inputs
    % Tx = -45; Ty = 0; Tz = 0;
    % Dx = 0; Dy = 0; Dz = 1;
    % % order = 'TxTyTzDxDyDz';
    % order = 'DxDyDzTxTyTz';
    % transMatrixBefore = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]
    % transformationMatrix = ...
    %     computeCoordinateTransformationMatrix(Tx,Ty,Tz,Dx,Dy,Dz,order,transMatrixBefore)
    
    
    % Main function definition
    
    % convert all angles to radians
    tx = Tx*pi/180;
    ty = Ty*pi/180;
    tz = Tz*pi/180;
    
    % take the rotation matrix and decenter vector
    rotToLocal = refCoordinateTM(1:3,1:3); % global to local
    decVector = refCoordinateTM(1:3,4);
    
    for k = 1:6
        switch upper(orderCellArray{k})
            % compute the rotation matrix
            case 'TX'
                rotToLocal = [1 0 0;0 cos(tx) sin(tx);0 -sin(tx) cos(tx)]*rotToLocal;
            case 'TY'
                rotToLocal = [cos(ty) 0 -sin(ty);0 1 0;sin(ty) 0 cos(ty)]*rotToLocal;
            case 'TZ'
                rotToLocal = [cos(tz) sin(tz) 0;-sin(tz) cos(tz) 0;0 0 1]*rotToLocal;
                
                % decenters are assumed to be in the current local coordinate system
                % the decenter values in local are converted to global using
                % transMatrix' and then added to the current transMatrix.
                % Dz is thickness
            case 'DX'
                rotToGlobal = rotToLocal';
                decVector =  decVector + rotToGlobal*[Dx;0;0];
            case 'DY'
                rotToGlobal = rotToLocal';
                decVector =  decVector + rotToGlobal*[0;Dy;0];
            case 'DZ'
                rotToGlobal = rotToLocal';
                decVector =  decVector + rotToGlobal*[0;0;Dz];
        end
    end
    % assemble the rotation matrix and the decenter vector togather for 4x4
    % transformation matrix
    transMatrixSurface = [[rotToLocal;0 0 0],[decVector;1]];
    transformationMatrix = transMatrixSurface;
end
    
    
