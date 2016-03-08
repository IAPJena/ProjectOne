function newGaussianBeamSet = GaussianBeamSet(centralRayPosition,...
        centralRayDirection,centralRayWavelength,waistRadiusInX,...
        waistRadiusInY,distanceFromWaistInX,distanceFromWaistInY,...
        peakAmplitude,localXDirection,localYDirection,nGaussian)
    % ScalarGaussianBeamSet Struct:
    %
    %   To represent all scalar (with no polarization) gaussian beam objects
    %   The class supports constructors to construct an array of gaussian beam
    %   objects from array of its properties. The properties of differertn
    %   gaussians is placed in the 2nd dimension (to agree with other part
    %   of the toolbox).
    %
    % Properties: 7 and methods: 0
    %
    % Example Calls:
    %
    % newScalarGaussianBeam = ScalarGaussianBeamSet()
    %   Returns a default scalar gaussian beam.
    %
    % newScalarGaussianBeam = ScalarGaussianBeamSet(centralRay,waistRadiusInX,...
    %            waistRadiusInY,distanceFromWaistInX,distanceFromWaistInY,...
    %            peakAmplitude,localXDirection,localYDirection)
    %   Returns a scalar gaussian beam with the given properties.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    
    if nargin < 1
        centralRayPosition = [0,0,0]';
    end
    if nargin < 2
        centralRayDirection = [0,0,1]';
    end
    if nargin < 3
        centralRayWavelength = 550*10^-9;
    end
    if nargin < 4
        waistRadiusInX = 0.25*10^-3; % Default value in meter
    end
    if nargin < 5
        waistRadiusInY = 1*10^-3;
    end
    if nargin < 6
        distanceFromWaistInX = 0;
    end
    if nargin < 7
        distanceFromWaistInY = 0;
    end
    if nargin < 8
        peakAmplitude = [1,0,-Inf,Inf]'; % Optimizable variable [value,status,min,max]
    else
        % If amplitude is given as single number then add the status ,min
        % and max
        if size(peakAmplitude,1) < 4
            peakAmplitude = [peakAmplitude(1,:);peakAmplitude(1,:)*0;...
                -abs(peakAmplitude(1,:))*Inf;abs(peakAmplitude(1,:))*Inf];
        end
    end
    if nargin < 9
        localXDirection = [1,0,0]';
    end
    if nargin < 10
        localYDirection = [0,1,0]';
    end
  
    % If the inputs are arrays the NewGaussianBeam becomes object array
    % Determine the size of each inputs
    nCentralRayPosition = size(centralRayPosition,2);
    nCentralRayDirection = size(centralRayDirection,2);
    nCentralRayWavelength = size(centralRayWavelength,2);
    nWaistRadiusInX = size(waistRadiusInX,2);
    nWaistRadiusInY = size(waistRadiusInY,2);
    nDistanceFromWaistInX = size(distanceFromWaistInX,2);
    nDistanceFromWaistInY = size(distanceFromWaistInY,2);
    nPeakAmplitude = size(peakAmplitude,2);
    nLocalXDirection = size(localXDirection,2);
    nLocalYDirection = size(localYDirection,2);
    
    % The number of array to be initialized is maximum of all inputs
    nMax = max([nCentralRayPosition,nCentralRayDirection,nCentralRayWavelength,...
        nWaistRadiusInX,nWaistRadiusInY,nDistanceFromWaistInX,...
        nPeakAmplitude,nLocalXDirection,nLocalYDirection]);
    if nargin == 11
        nMax = nGaussian;
    else
        nGaussian = nMax;
    end  
    % Fill the smaller inputs to have nMax size by repeating their
    % last element
    if nCentralRayPosition < nMax
        centralRayPosition = cat(2,centralRayPosition,repmat(centralRayPosition(:,end),...
            [nMax-nCentralRayPosition,1]));
    else
        centralRayPosition = centralRayPosition(:,1:nCentralRayPosition);
    end
    if nCentralRayDirection < nMax
        centralRayDirection = cat(2,centralRayDirection,repmat(centralRayDirection(:,end),...
            [nMax-nCentralRayDirection,1]));
    else
        centralRayDirection = centralRayDirection(:,1:nCentralRayDirection);
    end
    if nCentralRayWavelength < nMax
        centralRayWavelength = cat(2,centralRayWavelength,repmat(centralRayWavelength(end),...
            [nMax-nCentralRayWavelength,1]));
    else
        centralRayWavelength = centralRayWavelength(1:nCentralRayWavelength);
    end
    if nWaistRadiusInX < nMax
        waistRadiusInX = cat(2,waistRadiusInX,...
            repmat(waistRadiusInX(end), [1,nMax-nWaistRadiusInX]));
    else
        waistRadiusInX = waistRadiusInX(1:nWaistRadiusInX);
    end
    if nWaistRadiusInY < nMax
        waistRadiusInY = cat(2,waistRadiusInY,...
            repmat(waistRadiusInY(end),[1,nMax-nWaistRadiusInY]));
    else
        waistRadiusInY = waistRadiusInY(1:nWaistRadiusInY);
    end
    
    if nDistanceFromWaistInX < nMax
        distanceFromWaistInX = cat(2,distanceFromWaistInX,...
            repmat(distanceFromWaistInX(end),[1,nMax-nDistanceFromWaistInX]));
    else
        distanceFromWaistInX = distanceFromWaistInX(1:nDistanceFromWaistInX);
    end
    if nDistanceFromWaistInY < nMax
        distanceFromWaistInY = cat(2,distanceFromWaistInY,...
            repmat(distanceFromWaistInY(end),[1,nMax-nDistanceFromWaistInY]));
    else
        distanceFromWaistInY = distanceFromWaistInY(1:nDistanceFromWaistInY);
    end
    if nPeakAmplitude < nMax
        peakAmplitude = cat(2,peakAmplitude,...
            repmat(peakAmplitude(:,end),[1,nMax-nPeakAmplitude]));
    else
        peakAmplitude = peakAmplitude(:,1:nPeakAmplitude);
    end
    
    if nLocalXDirection < nMax
        localXDirection = cat(2,localXDirection,...
            repmat(localXDirection(end,:),[1,nMax-nLocalXDirection]));
    else
        localXDirection = localXDirection(:,1:nLocalXDirection);
    end
    if nLocalYDirection < nMax
        localYDirection = cat(2,localYDirection,...
            repmat(localYDirection(end,:),[1,nMax-nLocalYDirection]));
    else
        localYDirection = localYDirection(:,1:nLocalYDirection);
    end
    
    newGaussianBeamSet.CentralRayPosition = centralRayPosition;
    newGaussianBeamSet.CentralRayDirection = centralRayDirection;
    newGaussianBeamSet.CentralRayWavelength = centralRayWavelength;
    newGaussianBeamSet.WaistRadiusInX = waistRadiusInX;
    newGaussianBeamSet.WaistRadiusInY = waistRadiusInY;
    newGaussianBeamSet.DistanceFromWaistInX = distanceFromWaistInX;
    newGaussianBeamSet.DistanceFromWaistInY = distanceFromWaistInY;
    newGaussianBeamSet.PeakAmplitude = peakAmplitude;
    newGaussianBeamSet.LocalXDirection = localXDirection;
    newGaussianBeamSet.LocalYDirection = localYDirection;
    newGaussianBeamSet.nGaussian = nGaussian;
    
    newGaussianBeamSet.ClassName = 'GaussianBeamSet';
end

