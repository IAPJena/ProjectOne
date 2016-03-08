function newHarmonicFieldSet = HarmonicFieldSet(Ex,Ey,sampDistX,sampDistY,wavelen,center,direction,domain,referenceIndex)
    % HarmonicFieldSet Defines structure to represent set of harmonic
    % fields defined by the complex amplitudes Ex and Ey.
    % Inputes:
    %   Ex,Ey : Are 3D complex matrices of size (N1 x N2 x Nf), Nf = number of fields in the set
    %   sampDistX,sampDistY: Vector (1 x Nf) Sampling distance in x (2nd dim) and in y(1st
    %   dim) of the field.
    %   wavelen: Vector (1 x Nf) wavelength of the fields
    %   center, direction: Matrix (2 x Nf) and (3 x Nf) the center positions and the corresponding
    %                      direction of the fields
    %   domain : Vector (1 x Nf) indicating the spatial domain (1) or
    %   spatial frequency domain (2)
    %   referenceIndex: An integer indicating the refrence field in the set
    if nargin == 0
        N = 65;
        Ex = zeros(N,N);
        Ex(24:40,24:40) = 1;
        Ey = zeros(N,N);
        d = (2*10^-3)/N;
        sampDistX = d;
        sampDistY = d;
        wavelen = 0.55*10^-6;
        center = [0,0]';
        direction = [0,0,1]';
        domain = 1;% 1 for Spatial domain, and 2 for spatial frequency
        referenceIndex = 1;
    elseif nargin > 0 && nargin < 5
        disp('Error: You need to enter all input parameters (Ex,Ey,sampDistX,sampDistY,wavelen) or nothing.');
        newHarmonicFieldSet = HarmonicFieldSet;
        return;
    elseif nargin == 5
        center = [0,0]';
        direction = [0,0,1]';
        domain = 1;
        referenceIndex = 1;
    elseif nargin == 6
        direction = [0,0,1]';
        domain = 1;
        referenceIndex = 1;
    elseif nargin == 7
        domain = 1;  % spatial domain
        referenceIndex = 1;
    elseif nargin == 8
        referenceIndex = 1;
    else
        
    end
    
    % The field is usually assumed to be centered at origin
    center = [0,0]';
    
    
    if (size(Ex,1)~= size(Ey,1))||(size(Ex,2)~= size(Ey,2))
        disp('Error: Sizes of Ex and Ey must be the same');
        return;
    end
    
    % Determine the size of each inputs
    n_Ex = size(Ex,3);
    n_Ey = size(Ey,3);
    n_sampDistX = size(sampDistX,2);
    n_sampDistY = size(sampDistY,2);
    n_wavelen = size(wavelen,2);
    n_center = size(center,2);
    n_direction = size(direction,2);
    n_domain = size(domain,2);
    
    % The number of array to be initialized is maximum of all inputs
    nMax = max([n_Ex,n_Ey,n_sampDistX,n_sampDistY,n_wavelen,n_center,n_direction,n_domain]);
    
    % Fill the smaller inputs to have nMax size by repeating their
    % last element
    if n_Ex < nMax
        Ex = cat(3,Ex,repmat(Ex(:,:,end),[1,1,nMax-n_Ex]));
    else
        Ex = Ex(:,:,1:nMax);
    end
    if n_Ey < nMax
        Ey = cat(3,Ey,repmat(Ey(:,:,end),[1,1,nMax-n_Ey]));
    else
        Ey = Ey(:,:,1:nMax);
    end
    if n_sampDistX < nMax
        sampDistX = cat(2,sampDistX,repmat(sampDistX(:,end),[1,nMax-n_sampDistX]));
    else
        sampDistX = sampDistX(:,1:nMax);
    end
    if n_sampDistY < nMax
        sampDistY = cat(2,sampDistY,repmat(sampDistY(:,end),[1,nMax-n_sampDistY]));
    else
        sampDistY = sampDistY(:,1:nMax);
    end
    if n_wavelen < nMax
        wavelen = cat(2,wavelen,repmat(wavelen(:,end),[1,nMax-n_wavelen]));
    else
        wavelen = wavelen(:,1:nMax);
    end
    if n_center < nMax
        center = cat(2,center,repmat(center(:,end),[1,nMax-n_center]));
    else
        center = center(:,1:nMax);
    end
    if n_direction < nMax
        direction = cat(2,direction,repmat(direction(:,end),[1,nMax-n_direction]));
    else
        direction = direction(:,1:nMax);
    end
    if n_domain < nMax
        domain = cat(2,domain,repmat(domain(:,end),[1,nMax-n_domain]));
    else
        domain = domain(:,1:nMax);
    end
    
    nFields = nMax;
    % Make the field size odd in both side (zero padding to the
    % right and bottom of the matrices)
    nPoints1Ex = size(Ex,1);
    nPoints2Ex = size(Ex,2);
    
    
    nPoints1Ey = size(Ey,1);
    nPoints2Ey = size(Ey,2);
    
    
    if (nPoints1Ex == nPoints1Ey)&&(nPoints2Ex == nPoints2Ey)
        nPoints1 = nPoints1Ex;
        nPoints2 = nPoints2Ex;
    else
        disp('Error: Ex and Ey must be of the same size');
        return;
    end
    
    if ~mod(nPoints1,2)
        nPoints1 = nPoints1 + 1;
        Ex = cat(1,Ex,zeros(1,nPoints2,nFields));
        Ey = cat(1,Ey,zeros(1,nPoints2,nFields));
    end
    if ~mod(nPoints2,2)
        nPoints2 = nPoints2 + 1;
        Ex = cat(2,Ex,zeros(nPoints1,1,nFields));
        Ey = cat(2,Ey,zeros(nPoints1,1,nFields));
    end
    
    newHarmonicFieldSet.ReferenceFieldIndex = referenceIndex;
    
    newHarmonicFieldSet.ComplexAmplitude = cat(3,permute(Ex,[1,2,4,3]),permute(Ey,[1,2,4,3]));
    newHarmonicFieldSet.SamplingDistance = [sampDistX;sampDistY];
    newHarmonicFieldSet.Wavelength = wavelen;
    newHarmonicFieldSet.Center = center;
    newHarmonicFieldSet.Direction = direction;
    newHarmonicFieldSet.Domain = domain; % 1 for Spatial domain, and 2 for spatial frequency
    newHarmonicFieldSet.NumberOfHarmonicFields = nFields;
    
    newHarmonicFieldSet.ClassName = 'HarmonicFieldSet';
end


