function [ isInsideTheOuterAperture ] = IsInsideTheOuterAperture( surfAperture, xyVectorOrMesh )
    % IsInsideTheOuterAperture Returns 1 if the xyVector is insied the outer aperture and
    % 0 otherwise.
    % Inputs:
    %   ( surfAperture, xyVectorOrMesh )
    % Outputs:
    %    [isInsideTheOuterAperture]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    
    apertureType = surfAperture.Type;
    apertDecX = surfAperture.Decenter(1);
    apertDecY = surfAperture.Decenter(2);
    apertRotInDeg = surfAperture.Rotation;
    
    if ndims(xyVectorOrMesh) == 3
        % Given Nx x Ny x 2  mesh grids of xy values
        xyMesh = xyVectorOrMesh;
        % First decenter and then rotate the given points
        xyMesh_Decenter = cat(3,xyMesh(:,:,1) - apertDecX , xyMesh(:,:,2) - apertDecY);
        
        initial_r = computeNormOfMatrix( xyMesh_Decenter, 3 );
        initial_angleInRad = atan(xyMesh_Decenter(:,:,2)./xyMesh_Decenter(:,:,1));
        new_angleInRad = initial_angleInRad - apertRotInDeg*pi/180;
        
        xyMesh_final = cat(3,initial_r.*cos(new_angleInRad), initial_r.*sin(new_angleInRad));
        
        my_eps = 0;
        
        % Now connect to the aperture defintion function and compute the
        % maximum Radius in x and y
        apertureDefinitionHandle = str2func(GetSupportedSurfaceApertureTypes(apertureType));
        returnFlag = 2; % maximumRadiusXY
        apertureParameters = surfAperture.UniqueParameters;
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters);
        maximumRadiusXY = returnDataStruct.MaximumRadiusXY;
        
        switch (surfAperture.OuterShape)
            case {[1],[2]} % Circular or elliptical
                if apertureType == 1 || apertureType == 2 ||...
                        apertureType == 3 || apertureType == 5 % If aperture shape is also circular or elliptical
                    semiDiamX = maximumRadiusXY(1);
                    semiDiamY = maximumRadiusXY(2);
                else 
                    semiDiamX = sqrt(maximumRadiusXY(1)^2+maximumRadiusXY(2)^2);
                    semiDiamY = semiDiamX;
                end
                pointX = xyMesh_final(:,:,1);
                pointY = xyMesh_final(:,:,2);
                isInsideTheOuterAperture = (((pointX).^2)/semiDiamX^2) + (((pointY).^2)/semiDiamY^2) < 1 + my_eps ;
                
                insideIndex = find(isInsideTheOuterAperture);
            case  3 %'rectangular'
                semiDiamX = maximumRadiusXY(1);
                semiDiamY = maximumRadiusXY(2);
                pointX = xyMesh_final(:,:,1);
                pointY = xyMesh_final(:,:,2);
                isInsideTheOuterAperture = abs(pointX) < semiDiamX + my_eps &...
                    abs(pointY) < semiDiamY + my_eps;
            otherwise
        end
    elseif ismatrix(xyVectorOrMesh)
        % Given Nx2 matrix of xy values
        xyVector = xyVectorOrMesh;
        % First decenter and then rotate the given points
        xyVector_Decenter = [xyVector(:,1) - apertDecX , xyVector(:,2) - apertDecY];
        
        initial_r = computeNormOfMatrix( xyVector_Decenter, 2 );
        initial_angleInRad = atan(xyVector_Decenter(:,2)./xyVector_Decenter(:,1));
        new_angleInRad = initial_angleInRad - apertRotInDeg*pi/180;
        
        xyVector_final = [initial_r.*cos(new_angleInRad), initial_r.*sin(new_angleInRad)];
        
        my_eps = 0;
        
        % Now connect to the aperture defintion function and compute the
        % maximum Radius in x and y
        apertureDefinitionHandle = str2func(GetSupportedSurfaceApertureTypes(apertureType));
        returnFlag = 2; % maximumRadiusXY
        apertureParameters = surfAperture.UniqueParameters;
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters);
        maximumRadiusXY = returnDataStruct.MaximumRadiusXY;
        
        switch (surfAperture.OuterShape)
            case {[1],[2]} % Circular or elliptical
                semiDiamX = maximumRadiusXY(1);
                semiDiamY = maximumRadiusXY(2);
                pointX = xyVector_final(:,1);
                pointY = xyVector_final(:,2);
                isInsideTheOuterAperture = (((pointX).^2)/semiDiamX^2) + (((pointY).^2)/semiDiamY^2) < 1 + my_eps ;
                
                insideIndex = find(isInsideTheOuterAperture);
            case  3 %'rectangular'
                semiDiamX = maximumRadiusXY(1);
                semiDiamY = maximumRadiusXY(2);
                pointX = xyVector_final(:,1);
                pointY = xyVector_final(:,2);
                isInsideTheOuterAperture = abs(pointX) < semiDiamX + my_eps &...
                    abs(pointY) < semiDiamY + my_eps;
            otherwise
        end
    end
end

