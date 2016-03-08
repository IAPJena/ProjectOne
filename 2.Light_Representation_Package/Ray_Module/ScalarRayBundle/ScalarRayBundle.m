function [ newScalarRayBundle ] = ScalarRayBundle( position,direction,wavelength,nPupilPoints,nFieldPoints,nWavelengths )
    %ScalarRayBundle Used to define ray bundles which can be traced through
    %optical systems.
    % Inputs:
    %   position,direction: 3 x N matrix of ray position and direction
    %   wavelength: 1 x N vector of wavelengths corresponding to the rays
    %   nRays: Optional argument specifying the number of rays to
    %   construct. By defualt the the number of rays will be determined by
    %   the maximum number of 2nd dimensions of the inputs matrices and
    %   vector. If the 2nd dimension of an input argument is less than the
    %   number of rays to be constructed, then the values for the last 
    %   ray will be simply repeated for all unspacified values. But if the
    %   input argument size is greater than the number of rays, then the
    %   extra values are just discarded. 
    % Output:
    %   newScalarRayBundle: A scalalr ray bundle structure.
    
    if nargin == 0
        % Empty constructor
        newScalarRayBundle.Position = [0;0;0]; % default position
        newScalarRayBundle.Direction = [0;0;1]; % default dirction
        newScalarRayBundle.Wavelength = 0.55*10^-6; % default
        newScalarRayBundle.FixedParameters.TotalNumberOfPupilPoints = 1;
        newScalarRayBundle.FixedParameters.TotalNumberOfFieldPoints = 1;
        newScalarRayBundle.FixedParameters.TotalNumberOfWavelengths = 1;
        newScalarRayBundle.ClassName = 'ScalarRayBundle';
    else
        if nargin == 1
            direction = [0;0;1]; % default dirction
            wavelength = 0.55*10^-6;  % default
        elseif nargin == 2
            wavelength = 0.55*10^-6; % default
        else
        end
        
        % If the inputs are arrays the newRay becomes object array
        % That is when dir, pos  = 3 X N matrix
        
        % Determine the size of each inputs
        nPos = size(position,2);
        nDir = size(direction,2);
        nWav = size(wavelength,2);
        
        % The number of array to be initialized is maximum of all inputs
        nMax = max([nPos,nDir,nWav]);
        
        if nargin < 4
            nPupilPoints = nMax;
            nFieldPoints = 1;
            nWavelengths = 1;
        end
        if nargin == 4
            nFieldPoints = 1;
            nWavelengths = 1;
        end
        if nargin == 5
            nWavelengths = 1;
        end
        % limit nMax to the nRays
        nMax = nPupilPoints*nFieldPoints*nWavelengths;
        
        
        % Fill the smaller inputs to have nMax size by repeating their
        % last element
        if nPos < nMax
            position = cat(2,position,repmat(position(:,end),[1,nMax-nPos]));
        else
            position = position(:,1:nMax);
        end
        if nDir < nMax
            direction = cat(2,direction,repmat(direction(:,end),[1,nMax-nDir]));
        else
            direction = direction(:,1:nMax);
        end
        if nWav < nMax
            wavelength = cat(2,wavelength,repmat(wavelength(end),[1,nMax-nWav]));
        else
            wavelength = wavelength(:,1:nMax);
        end
        
        newScalarRayBundle = ScalarRayBundle;
        newScalarRayBundle.Position = position;
        newScalarRayBundle.Direction = direction;
        newScalarRayBundle.Wavelength = wavelength;

        newScalarRayBundle.FixedParameters.TotalNumberOfPupilPoints = nPupilPoints;
        newScalarRayBundle.FixedParameters.TotalNumberOfFieldPoints = nFieldPoints;
        newScalarRayBundle.FixedParameters.TotalNumberOfWavelengths = nWavelengths;
        
        newScalarRayBundle.ClassName = 'ScalarRayBundle';
    end
end

