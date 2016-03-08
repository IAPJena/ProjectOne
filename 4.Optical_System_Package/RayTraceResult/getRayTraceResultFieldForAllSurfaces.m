function [ rayTraceResultFieldForAllSurfaces ] = getRayTraceResultFieldForAllSurfaces...
        (allSurfaceRayTraceResult,requestedResultFieldName,requestedFieldFirstDims,...
        rayPupilIndices,rayFieldIndices,rayWavelengthIndices)
    % getRayTraceResultFieldForAllSurfaces: A function used to extract a
    % given field for all the surfaces from the array of ray trace result struct.
    % This simplifies the extraction of ray trace results.
    % Inputs:
    %   allSurfaceRayTraceResult: Array of raytraceresult struct for each
    %                             surface.
    %   requestedResultFieldName: The requested field name (it should be
    %                             valid field of the raytrace result struct).
    %   requestedFieldFirstDims: The dimensions of a single field value.
    %                            Eg. For intersection points it is 3 and
    %                                for polarization matrices it is [3,3]
    %   [rayPupilIndices,rayFieldIndices,rayWavelengthIndices]: the indices
    %                            specifying the ray (group of rays) for which
    %                            we want extract the ray trace result field.
    % Output:
    %   rayTraceResultFieldForAllSurfaces: Dim1 X Dim2 X nSurf X nPupilPoints X nField X nWav
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    % Oct 22,2014   Worku, Norman G.     Avoid recording of intermediate surface
    %                                    results if not neccessary or stated
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    nSurfaceTotal = length(allSurfaceRayTraceResult);
    
    nPupilPointsTotal = (allSurfaceRayTraceResult(1).FixedParameters.TotalNumberOfPupilPoints);
    nFieldTotal = (allSurfaceRayTraceResult(1).FixedParameters.TotalNumberOfFieldPoints);
    nWavelengthTotal = (allSurfaceRayTraceResult(1).FixedParameters.TotalNumberOfWavelengths);
    
    
    % Get the result field for all fields
    rayTraceResultForAllRays = [allSurfaceRayTraceResult.(requestedResultFieldName)];
    
    % Reshape to (nPupilPointsTotal X nFieldTotal X nWavelengthTotal)
    rayTraceResultForAllRaysReshaped = reshape(rayTraceResultForAllRays,...
        [requestedFieldFirstDims,nPupilPointsTotal,nFieldTotal,nWavelengthTotal,nSurfaceTotal]);
    
    % Extract and return the requested values
    if rayPupilIndices == 0
        rayPupilIndices = [1:nPupilPointsTotal];
    end
    if rayFieldIndices == 0
        rayFieldIndices = [1:nFieldTotal];
    end
    if rayWavelengthIndices == 0
        rayWavelengthIndices = [1:nWavelengthTotal];
    end
    % The resulting 5D matrices so that its dimensions would be (FirstDims X
    % nPupilPoints X nField X nWav X nSurf)
    
    if length(requestedFieldFirstDims) == 1
        % If the dimension of single value is 1D like IntersectionPoints,...
        rayTraceResultFieldForAllSurfaces = rayTraceResultForAllRaysReshaped...
            (:,rayPupilIndices,rayFieldIndices,rayWavelengthIndices,:);
        % Rearrange the 5D matrices so that its dimensions would be (FirstDim X
        % nSurf X nPupilPoints X nField X nWav)
        rayTraceResultFieldForAllSurfaces = ...
            permute(rayTraceResultFieldForAllSurfaces,[1,5,2,3,4]);
    elseif length(requestedFieldFirstDims) == 2
        % If the dimension of single value is 2D like PolarizationMatrix,...
        rayTraceResultFieldForAllSurfaces = rayTraceResultForAllRaysReshaped...
            (:,:,rayPupilIndices,rayFieldIndices,rayWavelengthIndices,:);
        % Rearrange the 6D matrices so that its dimensions would be (FirstDim1 X
        % FirstDim2 X nSurf X nPupilPoints X nField X nWav)
        rayTraceResultFieldForAllSurfaces = ...
            permute(rayTraceResultFieldForAllSurfaces,[1,2,6,3,4,5]);
    else
        % Single dimens > 2D are not usual case
        disp('Error: The requestedFieldFirstDims can not be greater than 2D.');
        rayTraceResultFieldForAllSurfaces = NaN;
        return;
    end
end

