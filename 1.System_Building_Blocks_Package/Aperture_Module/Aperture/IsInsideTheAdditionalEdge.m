function [ isInsideTheAdditionalEdge ] = IsInsideTheAdditionalEdge( surfAperture, xyVectorOrMesh )
    % IsInsideTheOuterAperture Returns 1 if the xyVector is insied the outer aperture and
    % 0 otherwise.
    % Inputs:
    %   ( surfAperture, xyVectorOrMesh )
    % Outputs:
    %    [isInsideTheAdditionalEdge]
    
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
        returnFlag = 2;
        apertureParameters = surfAperture.UniqueParameters;
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters);
        maximumRadiusXY = returnDataStruct.MaximumRadiusXY;
        
        maximumRadiusXYWithEdge = maximumRadiusXY*(1+surfAperture.AdditionalEdge);
        switch (surfAperture.OuterShape)
            case {[1],[2]}%{'elliptical','circular'}
                semiDiamX1 = maximumRadiusXY(1);
                semiDiamY1 = maximumRadiusXY(2);
                
                semiDiamX2 = maximumRadiusXYWithEdge(1);
                semiDiamY2 = maximumRadiusXYWithEdge(2);
                
                pointX = xyMesh_final(:,:,1);
                pointY = xyMesh_final(:,:,2);
                umInsideTheInnerEllipse = ((((pointX).^2)/semiDiamX1^2) + (((pointY).^2)/semiDiamY1^2) <= 1 + my_eps);
                umInsideTheOuterEllipse  = ((((pointX).^2)/semiDiamX2^2) + (((pointY).^2)/semiDiamY2^2) <= 1 + my_eps);
                isInsideTheAdditionalEdge = umInsideTheOuterEllipse & ~umInsideTheInnerEllipse ;
                
            case 3 %'rectangular'
                semiDiamX1 = maximumRadiusXY(1);
                semiDiamY1 = maximumRadiusXY(2);
                
                semiDiamX2 = maximumRadiusXYWithEdge(1);
                semiDiamY2 = maximumRadiusXYWithEdge(2);
                
                pointX = xyMesh_final(:,:,1);
                pointY = xyMesh_final(:,:,2);
                umInsideTheInnerRectangle = (abs(pointX) <= semiDiamX1 + my_eps & abs(pointY) <= semiDiamY1 + my_eps);
                umInsideTheOuterRectangle = (abs(pointX) <= semiDiamX2 + my_eps & abs(pointY) <= semiDiamY2 + my_eps);
                isInsideTheAdditionalEdge = umInsideTheOuterRectangle & ~umInsideTheInnerRectangle;
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
        returnFlag = 2;
        apertureParameters = surfAperture.UniqueParameters;
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters);
        maximumRadiusXY = returnDataStruct.MaximumRadiusXY;
        
        maximumRadiusXYWithEdge = maximumRadiusXY*(1+surfAperture.AdditionalEdge);
        switch (surfAperture.OuterShape)
            case {[1],[2]}%{'elliptical','circular'}
                semiDiamX1 = maximumRadiusXY(1);
                semiDiamY1 = maximumRadiusXY(2);
                
                semiDiamX2 = maximumRadiusXYWithEdge(1);
                semiDiamY2 = maximumRadiusXYWithEdge(2);
                
                pointX = xyVector(:,1);
                pointY = xyVector(:,2);
                umInsideTheInnerEllipse = ((((pointX).^2)/semiDiamX1^2) + (((pointY).^2)/semiDiamY1^2) <= 1 + my_eps);
                umInsideTheOuterEllipse  = ((((pointX).^2)/semiDiamX2^2) + (((pointY).^2)/semiDiamY2^2) <= 1 + my_eps);
                isInsideTheAdditionalEdge = umInsideTheOuterEllipse & ~umInsideTheInnerEllipse ;
                
            case 2 %'rectangular'
                semiDiamX1 = maximumRadiusXY(1);
                semiDiamY1 = maximumRadiusXY(2);
                
                semiDiamX2 = maximumRadiusXYWithEdge(1);
                semiDiamY2 = maximumRadiusXYWithEdge(2);
                
                pointX = xyVector(:,1);
                pointY = xyVector(:,2);
                umInsideTheInnerRectangle = (abs(pointX) <= semiDiamX1 + my_eps & abs(pointY) <= semiDiamY1 + my_eps);
                umInsideTheOuterRectangle = (abs(pointX) <= semiDiamX2 + my_eps & abs(pointY) <= semiDiamY2 + my_eps);
                isInsideTheAdditionalEdge = umInsideTheOuterRectangle & ~umInsideTheInnerRectangle;
            otherwise
        end
    end
end

