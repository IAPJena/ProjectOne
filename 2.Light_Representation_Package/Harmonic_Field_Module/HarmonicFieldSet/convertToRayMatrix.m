function [ rayMatrix,chiefRayIndex1D ] = convertToRayMatrix( harmonicField,phaseToDirMethod, initialZ )
%convertToRayMatrix Converts the harmonic field to ray matrix
% phaseToDirMethod : method to convert phase to direction
% 1)default direction  2)LocalGradient
if nargin == 0
    disp('Error: The function harmonicFieldToRayConverter requires atleast one argument.');
    rayMatrix = [];
    chiefRayIndex1D = [];
    return;
elseif nargin == 1
    phaseToDirMethod = 2;
    initialZ = 0;
elseif nargin == 2
    initialZ = 0;
else
    
end
wavelength = harmonicField.Wavelength;
% Currently only Ex component of the field is used
[Ex,x_lin,y_lin] = computeEx(harmonicField);

% Ex = harmonicField.computeEx;
nPointsX = size(Ex,1);
nPointsY = size(Ex,2);
dx = harmonicField.SamplingDistance(1);
dy = harmonicField.SamplingDistance(2);

nPointsTotal = nPointsX*nPointsY;
[x,y] = meshgrid(x_lin,y_lin);

% Convert the mesh grid to 1D vector
xCoord = x(:);
yCoord = y(:);
initialPoints = [xCoord,yCoord,repmat(initialZ,nPointsTotal,1)]';

if phaseToDirMethod == 1
    defaultDirection = harmonicField.Direction;
    rayBundleDirections = repmat(defaultDirection,[1,nPointsTotal]);
else
    % To compute ray directions, from phase, it shuld be first unwrapped (if
    % neccessary) and then the phase computed using the method chosen
    phaseEx = angle(Ex);
    unwrappedPhaseEx = unwrap(phaseEx);
    if phaseToDirMethod > 2
        disp(['Warning: Unknown phase to direction conversion method chosen.',...
            'The default Gradient method is used insead']);
    end
    [dPdx,dPdy] = gradient(unwrappedPhaseEx,dx,dy);
    % convert to 1D and compute the z component of the direction
    dirX = dPdx(:);
    dirY = dPdy(:);
    dirZ = (wavelength/(2*pi))*(sqrt((wavelength/(2*pi)).^2 - dirX.^2 - dirY.^2));
    % normalized direction cosines
    dirVectorMatrix = [dirX';dirY';dirZ'];
    [ directionCosines ] = normalize2DMatrix( dirVectorMatrix,1 );
    rayBundleDirections = directionCosines;
end
rayBundlePositions = initialPoints;

% Initialize initial ray bundle using constructor.
pos = rayBundlePositions;
dir = rayBundleDirections;
wav = repmat(wavelength,[1,nPointsTotal]);
% construct array of Ray objects
rayArray = ScalarRay(pos,dir,wav);
% reshape the rayArray to matrix of size  nPointsX x nPointsY
rayMatrix = reshape(rayArray,nPointsX,nPointsY);

% Find cheif ray index
chiefRayIndices = find((xCoord).^2+(yCoord).^2==0);
% take first value in case of multiple ocuurances
chiefRayIndex1D = chiefRayIndices(1);

end

