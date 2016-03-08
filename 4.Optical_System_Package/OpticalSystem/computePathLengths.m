function [ geometricalOpticalGroupPathLength ] = ...
    computePathLengths( optSystem, fieldIndex, wavelengthVectorInM)
%computePathLengthVersusWavelength Computes gemetrical path length, optical path
%length and group path length vs wavelength for given field index.

% Default values
if nargin == 0
    disp('Error: The function plotPathLengthVersusWavelength requires an optical object as argument.');
    geometricalOpticalGroupPathLength = NaN;
    return ;
elseif nargin == 1
    fieldIndex = 1;
    primaryWavelength = getPrimaryWavelength(optSystem);
    minWavelengthInM = primaryWavelength - 10*10^-9;
    maxWavelengthInM = primaryWavelength + 10*10^-9;
    nPoints = 99;    
    wavelengthVectorInM = linspace(minWavelengthInM, maxWavelengthInM,nPoints);    
elseif nargin == 2
    primaryWavelength = getPrimaryWavelength(optSystem);
    minWavelengthInM = primaryWavelength - 10*10^-9;
    maxWavelengthInM = primaryWavelength + 10*10^-9;
    nPoints = 99;    
    wavelengthVectorInM = linspace(minWavelengthInM, maxWavelengthInM,nPoints); 
    
end
centralWavelength = (max(wavelengthVectorInM)+min(wavelengthVectorInM))/2;

% centralWavelength = 0.45*10^-6;

% Construct ray objects with field index and all the wavelegnths
% Take direction of the Cheif ray
switch lower(optSystem.FieldType)
    case lower('ObjectHeight')
        % Convert the values from lens unit to meter
        fieldPointXYInSI =((optSystem.FieldPointMatrix(fieldIndex,1:2))')*...
            optSystem.getLensUnitFactor;
    case lower('Angle')
        % Leave in degrees
        fieldPointXYInSI = ((optSystem.FieldPointMatrix(fieldIndex,1:2))');
end
cheifRay = getChiefRay(optSystem,fieldPointXYInSI);
rayPosition = cheifRay.Position;
rayDirection = cheifRay.Direction;
% Central wavelength is added to determine the final transversal plane.
wavelength = [wavelengthVectorInM centralWavelength];

allRays = ScalarRay(rayPosition,rayDirection,wavelength);
considerSurfAperture = 1;
recordIntermediateResults = 0;
rayTraceResultFinal = rayTracer(optSystem,allRays,considerSurfAperture,recordIntermediateResults);

% The optical path length is calculated to the image plane ( which is not
% neccessarly perpendicular to the chief ray). But for our results to be
% meaningful we have to compute the total optical path length from the
% field point to the plane perpendicular to the chief ray with central
% frequency

% Compute the intersection of all rays with the transversal plane
linePoint = [rayTraceResultFinal.RayIntersectionPoint];
lineVector = normalize2DMatrix([rayTraceResultFinal.IncidentRayDirection]);

planePoint = [rayTraceResultFinal(1,end).RayIntersectionPoint];
planeNormalVector = [rayTraceResultFinal(1,end).IncidentRayDirection]; 
[linePlaneIntersection,distance] = computeLinePlaneIntersection(linePoint,lineVector,planePoint,planeNormalVector);

% % % Compute and add the additional optical path length
lastIndex = rayTraceResultFinal(1,end).RefractiveIndex;
lastGroupIndex = rayTraceResultFinal(1,end).GroupRefractiveIndex;

% lastDistanceInM = getLensUnitFactor(optSystem)*[rayTraceResultFinal.PathLength];
% totalPathInM = getLensUnitFactor(optSystem)*[rayTraceResultFinal.TotalPathLength] - lastDistanceInM;
% totalOpticalPathInM = getLensUnitFactor(optSystem)*[rayTraceResultFinal.TotalOpticalPathLength] - lastIndex*lastDistanceInM;
% totalGroupPathInM = getLensUnitFactor(optSystem)*[rayTraceResultFinal.TotalGroupPathLength] - lastGroupIndex*lastDistanceInM;
% 
% y1 = totalPathInM(1:end-1);
% y2 = totalOpticalPathInM(1:end-1);
% y3 = totalGroupPathInM(1:end-1);
% geometricalOpticalGroupPathLength = [y1',y2',y3'];

y1 = getLensUnitFactor(optSystem)*[[rayTraceResultFinal.TotalPathLength]+distance]';
y2 = getLensUnitFactor(optSystem)*[[rayTraceResultFinal.TotalOpticalPathLength]+distance*lastIndex]';
y3 = getLensUnitFactor(optSystem)*[[rayTraceResultFinal.TotalGroupPathLength]+distance*lastGroupIndex]';
% Don't return the centralWavelength results.
geometricalOpticalGroupPathLength = [y1(1:end-1),y2(1:end-1),y3(1:end-1)];
end

