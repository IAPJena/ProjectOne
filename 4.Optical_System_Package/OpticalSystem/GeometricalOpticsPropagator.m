function [ outputHarmonicFieldSet ] = GeometricalOpticsPropagator( ...
        optSystem, inputHarmonicFieldSet, endSurfaceIndex, phaseToDirMethod, effectsToInclude )
    %GEOMETRICALOPTICSPROPAGATOR Propagate harmonic fields using geomertical
    %optics through array of surfaces
    % effectsToInclude: 1)OPL 2)OPL + Fresnel Refraction/Reflection
    if nargin < 2
        disp(['Error: The function GeometricalOpticsPropagator requires atleast',...
            'optSystem, inHarmonicFieldSet as input argument.']);
        outputHarmonicFieldSet = [];
        return;
    elseif nargin == 2
        endSurfaceIndex = optSystem.NumberOfSurfaces;
        phaseToDirMethod = 2; % use gradient method
        effectsToInclude = 1; % only OPL
    elseif nargin == 3
        phaseToDirMethod = 2; % use gradient method
        effectsToInclude = 1; % only OPL
    elseif nargin == 4
        effectsToInclude = 1; % only OPL
    else
    end
    inputHarmonicFieldArray = inputHarmonicFieldSet.HarmonicFieldArray;
    nFields = size(inputHarmonicFieldArray,2);
    
    NonDummySurfaceArray =  optSystem.NonDummySurfaceArray ;
    if abs(NonDummySurfaceArray(1).Thickness) > 10^10 % object at infinity
        objThick = 0;
    else
        objThick  = NonDummySurfaceArray(1).Thickness;
    end
    % If endSurface = 'ExP' then trace rays to image plane first and then back
    % to exit pupil sphere
    if strcmpi((endSurfaceIndex),'ExP')
        traceToExitPupil = 1;
        endSurfaceIndex = optSystem.NumberOfSurfaces;
    else
        traceToExitPupil = 0;
    end
    initialZ = -objThick;
    lensUnitFactor = getLensUnitFactor(optSystem);
    % propagate each harmonic field separately
    outputHarmonicFieldArray(nFields) = HarmonicField;
    outputHarmonicFieldSet = HarmonicFieldSet;
    
    
    %     % Ref ray cheif ray with centeral wavelength
    %     refSpectrum = ReferenceFieldIndex;
    %     referenceOPLinMeter =
    %
    % % Trace central wavelength first to use for ref
    % centralWavLenIndex = floor(nFields/2);
    % [ initialRayMatrix,chiefRayIndex1D ] = convertToRayMatrix( ...
    %     inputHarmonicFieldArray(centralWavLenIndex),phaseToDirMethod, initialZ );
    % % trace ray to end surface
    % considerPolarization = 0;
    % considerSurfAperture = 1;
    % recordIntermediateResults  = 0;
    % rayTraceResult = rayTracer(optSystem,initialRayMatrix,considerPolarization,...
    % considerSurfAperture,recordIntermediateResults,endSurfaceIndex);
    % endSurfaceRayTraceResult = rayTraceResult(end,:,:);
    % % if traceToExitPupil = 1 then trace rays back to the exit pupil and then
    % % modify the total OPL and Exit ray position to that at exit pupil
    % if traceToExitPupil
    %
    % end
    % OPLRef = -[endSurfaceRayTraceResult.TotalOpticalPathLength];
    OPLRef = 0;
    % finalRayTraceResult =
    for ff = 1:nFields
        [ initialRayMatrix,chiefRayIndex1D ] = convertToRayMatrix( ...
            inputHarmonicFieldArray(ff),phaseToDirMethod, initialZ );
        % trace ray to end surface
        considerPolarization = 0;
        considerSurfAperture = 1;
        recordIntermediateResults  = 0;
        rayTraceResult = rayTracer(optSystem,initialRayMatrix,considerPolarization,...
            considerSurfAperture,recordIntermediateResults,endSurfaceIndex);
        
        endSurfaceRayTraceResult = squeeze(rayTraceResult(end,:,:));
        finalRayTraceResult(:,:,ff) = endSurfaceRayTraceResult;
        % if traceToExitPupil = 1 then trace rays back to the exit pupil and then
        % modify the total OPL and Exit ray position to that at exit pupil
        %%
        if traceToExitPupil
            objectToImageOPLSum = [endSurfaceRayTraceResult.TotalOpticalPathLength];
            %% Trace all rays back to the exit pupil sphere
            initialPosition = [(endSurfaceRayTraceResult.RayIntersectionPoint)];
            initialDirection = -1*[(endSurfaceRayTraceResult.IncidentRayDirection)];
            % Define exit pupil sphere
            exitPupilCenter = initialPosition(:,chiefRayIndex1D);
            exitPupilRadius = - getExitPupilLocation(optSystem);
            % Line(Ray):  initialPosition + t*initialDirection  = P
            % Sphere: (P-exitPupilCenter)^2 - exitPupilRadius^2 = 0
            % To get intersection point
            % at^2+bt+c=0 where
            % a = 1,
            % b = 2*initialDirection(initialPosition-exitPupilCenter),
            % c = |initialPosition-exitPupilCenter|^2-exitPupilRadius^2
            
            N = size(endSurfaceRayTraceResult);
            N1 = N(1);
            N2 = N(2);
            nRay = N1 * N2;
            a = 1;
            b = 2*compute3dDot(initialDirection,(initialPosition-repmat(exitPupilCenter,[1,nRay])));
            c = sum((initialPosition-repmat(exitPupilCenter,[1,nRay])).^2,1)-exitPupilRadius^2;
            
            discr = b.^2 - 4*a.*c;
            if sum(discr<0,2)
                disp('Error Some rays fail to intersect the exit pupil.');
            end
            % Parameters
            root1 = (-b+sqrt(discr))./(2*a);
            root2 = (-b-sqrt(discr))./(2*a);
            % the intersection point shall be compute using the line eqation.
            intersectionPoint1 = initialPosition + repmat(root1,[3,1]).*initialDirection;
            intersectionPoint2 = initialPosition + repmat(root2,[3,1]).*initialDirection;
            % The real intersection point depends on the exit pupil location,
            % if it is to the left of image plane then the intersection point
            % with smaller z value is taken. Otherwise the other is taken.
            if exitPupilRadius > 0 % exit pupil to the left
                if intersectionPoint1(3,1) < intersectionPoint2(3,1)
                    rayExitPupilIntersection = intersectionPoint1;
                else
                    rayExitPupilIntersection = intersectionPoint2;
                end
            else
                if intersectionPoint1(3,1) < intersectionPoint2(3,1)
                    rayExitPupilIntersection = intersectionPoint2;
                else
                    rayExitPupilIntersection = intersectionPoint1;
                end
            end
            %             %% If plane exit pupil is assumed
            %             % Determine parameterr for Z of exit pupil from the global axis.
            %             % NB. Exit pupil location is measured from the image plane
            %             ExitPupilZ = optSystem.getTotalTrack + optSystem.getExitPupilLocation;
            %             % Line(Ray):  (x0,y0,z0) + t*(dx,dy,dz)  = (X,Y,Z)
            %             t = (ExitPupilZ - initialPosition(3,:))./initialDirection(3,:);
            %             intersectionPoint1 = initialPosition + repmat(t,[3,1]).*initialDirection;
            %             rayExitPupilIntersection = intersectionPoint1;
            
            additionalOpticalPath = sqrt(sum((initialPosition-rayExitPupilIntersection).^2,1));
            %         if polarized
            %             totalOPLAtExitPupil = objectToImageOPLSum;
            %         else
            %             totalOPLAtExitPupil = objectToImageOPLSum - additionalOpticalPath;
            %         end
            %         totalOPLAtExitPupil = objectToImageOPLSum - additionalOpticalPath;
            
            
            % Update the raytrace result object. Only neccessary parameters
            % Convert endSurfaceRayTraceResult to 1D
            linearizedRayTraceResult = endSurfaceRayTraceResult(:);
            
            updatedRayIntersectionPoint = rayExitPupilIntersection; % changed
            updatedExitRayPosition = rayExitPupilIntersection; % changed
            
            updatedSurfaceNormal = [linearizedRayTraceResult.SurfaceNormal];
            updatedIncidentRayDirection = -[linearizedRayTraceResult.IncidentRayDirection]; % changed
            updatedIncidenceAngle = -[linearizedRayTraceResult.IncidenceAngle]; % changed
            
            updatedExitRayDirection = [linearizedRayTraceResult.ExitAngle];
            updatedExitAngle = [linearizedRayTraceResult.ExitAngle];
            updatedNoIntersectionPoint = [linearizedRayTraceResult.NoIntersectionPoint];
            updatedOutOfAperture = [linearizedRayTraceResult.OutOfAperture];
            updatedTIR = [linearizedRayTraceResult.TotalInternalReflection ];
            
            updatedGeometricalPathLength = - additionalOpticalPath; % changed
            updatedOpticalPathLength = - additionalOpticalPath; % changed
            updatedGroupPathLength = - additionalOpticalPath; % changed
            updatedTotalPathLength = [linearizedRayTraceResult.TotalPathLength]- additionalOpticalPath; % changed
            updatedTotalOpticalPathLength = [linearizedRayTraceResult.TotalOpticalPathLength]- additionalOpticalPath; % changed
            updatedTotalGroupPathLength = [linearizedRayTraceResult.TotalGroupPathLength]- additionalOpticalPath; % changed
            
            updatedRefractiveIndex = [linearizedRayTraceResult.RefractiveIndex];
            updatedRefractiveIndexFirstDerivative = [linearizedRayTraceResult.RefractiveIndexFirstDerivative];
            updatedRefractiveIndexSecondDerivative = [linearizedRayTraceResult.RefractiveIndexSecondDerivative];
            updatedGroupRefractiveIndex = [linearizedRayTraceResult.GroupRefractiveIndex];
            
            endSurfaceRayTraceResultUpdated =...
                RayTraceResult(updatedRayIntersectionPoint,updatedExitRayPosition,updatedSurfaceNormal,...
                updatedIncidentRayDirection,updatedIncidenceAngle,...
                updatedExitRayDirection,updatedExitAngle,updatedNoIntersectionPoint,...
                updatedOutOfAperture,updatedTIR,updatedGeometricalPathLength,updatedOpticalPathLength,...
                updatedGroupPathLength,updatedTotalPathLength,updatedTotalOpticalPathLength,updatedTotalGroupPathLength,...
                updatedRefractiveIndex,updatedRefractiveIndexFirstDerivative,updatedRefractiveIndexSecondDerivative,...
                updatedGroupRefractiveIndex);
            
            exitPupilRayTraceResult = reshape(endSurfaceRayTraceResultUpdated,N1,N2);
            finalRayTraceResult(:,:,ff) = exitPupilRayTraceResult;
            
            %         [endSurfaceRayTraceResult.TotalOpticalPathLength] = num2cell(reshape(...
            %             [endSurfaceRayTraceResult.TotalOpticalPathLength] + ...
            %             - additionalOpticalPath,N1,N2));
            % %         endSurfaceRayTraceResult.RayIntersectionPoint = reshpe(...
            % %             rayExitPupilIntersection);
            %         endSurfaceRayTraceResult.ExitRayPosition = rayExitPupilIntersection;
            %
            % %         totalOPLAtExitPupilCheifRay = totalOPLAtExitPupil(cheifRayIndex);
            % %         opd = -totalOPLAtExitPupil+totalOPLAtExitPupilCheifRay;
            
            % Determine exit pupil coordinates
            
            %         from entrance coordinates and
            %         % the ratio of their diameters
            %         entPupilDiameter = getEntrancePupilDiameter(optSystem);
            %         exitPupilDiameter = getExitPupilDiameter(optSystem);
            %         exitPupilCoordinates = pupilMeshGrid * (exitPupilDiameter/entPupilDiameter);
            %
            %         % Plot the surface at exit pupil
            %         X = pupilMeshGrid(:,:,1);
            %         Y = pupilMeshGrid(:,:,2);
            
            % Initialize all values to zero
            %         OPDAtExitPupil(1:nGrid,1:nGrid) = zeros;
            %         AmplitudeTransmission(1:nGrid,1:nGrid) = zeros;
            
            % Change the pupilGridIndices (2XN matrix with 2D indices of the grid
            % corresponding to each ray) to linear index so that the values opd can be
            % linearly assigned.
            %          OPDAtExitPupil(~outsidePupilIndices) = opd;
            %         if polarized
            %             AmplitudeTransmission(~outsidePupilIndices) = ampTransCoeff;
            %         else
            %             AmplitudeTransmission(1:nGrid,1:nGrid) = ones;
            %         end
            %
            %         apodType = optSystem.ApodizationType;
            %         apodParam = optSystem.ApodizationParameters;
            %         gridSize = size(OPDAtExitPupil,1);
            %         [ ~,~,pupilApodization ] =...
            %             plotPupilApodization( optSystem,apodType,apodParam,gridSize);
            %         PupilWeightMatrix = pupilApodization;
            
            %         normalizedAmpTrans = AmplitudeTransmission/max(max(AmplitudeTransmission));
            
            %         useApodization = 0;
            %         if useApodization
            %             OPDAtExitPupil = OPDAtExitPupil.*PupilWeightMatrix;
            %         end
        end
        
        %%
        %     outputHarmonicFieldArray(ff) = computeFinalHarmonicField(finalRayTraceResult,...
        %         inputHarmonicFieldArray(ff),effectsToInclude,lensUnitFactor,OPLRef);
        
    end
    
    % Determine the reference OPL
    centralWavelengthIndex = inputHarmonicFieldSet.ReferenceFieldIndex;
    [chiefRayIndex1, chiefRayIndex2] = inputHarmonicFieldArray(ff).getReferencePointIndices;
    referenceOPL = finalRayTraceResult(chiefRayIndex1, chiefRayIndex2,centralWavelengthIndex).TotalOpticalPathLength;
    OPLRef = referenceOPL;
    for ff2 = 1:nFields
        outputHarmonicFieldArray(ff2) = computeFinalHarmonicField(finalRayTraceResult(:,:,ff2),...
            inputHarmonicFieldArray(ff2),effectsToInclude,lensUnitFactor,OPLRef);
    end
    outputHarmonicFieldSet.HarmonicFieldArray = outputHarmonicFieldArray;
end

