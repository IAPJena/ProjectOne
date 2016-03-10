function [ isInsideTheMainAperture ] = IsInsideTheMainAperture( surfAperture, xyVectorOrMesh )
    % IsInsideTheMainAperture: Returns 1 if the xyVector is insied the main aperture and
    % 0 otherwise.
    % Inputs:
    %   ( surfAperture, xyVectorOrMesh )
    %       NB. xyVector is Nx2
    % Outputs:
    %    [isInsideTheMainAperture]
    
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
        initial_angleInRad = atan2(xyMesh_Decenter(:,:,2),xyMesh_Decenter(:,:,1));
        % For case of xyVector_Decenter(:,:,1) == 0, add small number in the
        % denominator to avoid NaN
        nanCaseIndices = abs(xyMesh_Decenter(:,:,1)) < eps;
        xMesh_Decenter = xyMesh_Decenter(:,:,1);
        yMesh_Decenter = xyMesh_Decenter(:,:,2);
        initial_angleInRad(nanCaseIndices) = atan(yMesh_Decenter(nanCaseIndices)./(xMesh_Decenter(nanCaseIndices) + eps));
        
        new_angleInRad = initial_angleInRad - apertRotInDeg*pi/180;
        
        xyMesh_final = cat(3,initial_r.*cos(new_angleInRad), initial_r.*sin(new_angleInRad));
        
        % Now connect to the aperture defintion function and compute the
        % isInnsidefunction
        apertureDefinitionHandle = str2func(GetSupportedSurfaceApertureTypes(apertureType));
        returnFlag = 3; % isInsideTheMainAperture
        apertureParameters = surfAperture.UniqueParameters;
        inputDataStruct.xyVector = xyMesh_final; % The aperture definition files shall be updated to handle the xyMesh input
        
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters,inputDataStruct);
        isInsideTheMainAperture = returnDataStruct.IsInsideTheMainAperture;

    elseif ismatrix(xyVectorOrMesh)
        % Given Nx2 matrix of xy values
        xyVector = xyVectorOrMesh;
        % First decenter and then rotate the given points
        xyVector_Decenter = [xyVector(:,1) - apertDecX , xyVector(:,2) - apertDecY];
        
        initial_r = computeNormOfMatrix( xyVector_Decenter, 2 );
        initial_angleInRad = atan2(xyVector_Decenter(:,2),(xyVector_Decenter(:,1) + eps));
        % For case of xyVector_Decenter(:,1) == 0, add small number in the
        % denominator to avoid NaN
        nanCaseIndices = abs(xyVector_Decenter(:,1)) < eps;
        initial_angleInRad(nanCaseIndices) = atan(xyVector_Decenter(nanCaseIndices,2)./(xyVector_Decenter(nanCaseIndices,1) + eps));
        
        new_angleInRad = initial_angleInRad - apertRotInDeg*pi/180;
        
        xyVector_final = [initial_r.*cos(new_angleInRad), initial_r.*sin(new_angleInRad)];
        
        % Now connect to the aperture defintion function and compute the
        % isInnsidefunction
        apertureDefinitionHandle = str2func(GetSupportedSurfaceApertureTypes(apertureType));
        returnFlag = 3; % isInsideTheMainAperture
        apertureParameters = surfAperture.UniqueParameters;
        inputDataStruct.xyVector = xyVector_final;
        
        [ returnDataStruct] = apertureDefinitionHandle(returnFlag,apertureParameters,inputDataStruct);
        isInsideTheMainAperture = returnDataStruct.IsInsideTheMainAperture;
    end
end

