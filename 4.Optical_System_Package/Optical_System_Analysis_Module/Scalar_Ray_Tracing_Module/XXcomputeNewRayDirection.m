function [S2,TIR] = computeNewRayDirection(S1,e,n1,n2,r,wavLen,G1,o1)
% Generalized function to compute the new ray direction.
% incidentDirection S1
% normalVector e
% indexBefore n1
% indexAfter n2
% Waveength wavLen (in um) 
% gratingVector1 G1 (in 1/um) = [0,2Pi(grating_density) in Y,0];
% diffractionOrder1 O1
% reflection r 

nRay = size(S1,2);
if nargin < 5
    disp('Error: Full input for refractive/reflective/diffractive surface is required.');
    return;
elseif nargin == 5 % Minimum amount for non diffractive case
    wavLen = 0.55; 
    diffraction = 0;
elseif nargin >= 6 && nargin < 8    
    disp('Error: Full input for diffraction grating is required.');
    return;
else
    diffraction = 1;
end
% Determine the K vector before interface
k0 = 2*pi./wavLen;
K1 = repmat(k0.*n1,[3,1]).*S1;
% Decompose it to longitudinal and transversal 
longK1 = repmat(compute3dDot(K1,e),[3,1]).*e;
transK1 = K1 - longK1;

% Determine the longitudinal component of the K vector
if r 
    if diffraction
    % Decompose the transversal component to the grating vector components
     dirG1 = G1./repmat(computeNormOfMatrix(G1,1),[3,1]);
     transK1_Parallel_G1 = repmat(compute3dDot(transK1,repmat(dirG1,[1,nRay])),[3,1]).*repmat(dirG1,[1,nRay]);%
     transK1_Perpendicular_G1 = transK1 - transK1_Parallel_G1;   
    % The K component along the grating vector will be affected by the
    % grating
    transK2_Parallel_G1 = transK1_Parallel_G1 + repmat((repmat(o1,[3,1]).*G1),[1,nRay]); 
    transK2_Perpendicular_G1 = transK1_Perpendicular_G1;    
    transK2 = transK2_Perpendicular_G1 + transK2_Parallel_G1;      
    else
        % For refractive surface the transversal component of the K vector
        % remains unchanged.   
        transK2 = transK1;
    end
    % Reflection
    longK2 = repmat(-sqrt((k0.*n1).^2 - (computeNormOfMatrix(transK2,1)).^2),[3,1]).*e;
    % Replace complex numbers with NaN
    longK2(find(imag(longK2))) = NaN;
    failedIndices = ceil(find(imag(longK2))/3) ;
    TIR = zeros(1,nRay);
else
    if diffraction
    % Decompose the transversal component to the grating vector components
     dirG1 = G1./repmat(computeNormOfMatrix(G1,1),[3,1]);
     transK1_Parallel_G1 = repmat(compute3dDot(transK1,repmat(dirG1,[1,nRay])),[3,1]).*repmat(dirG1,[1,nRay]);%
     transK1_Perpendicular_G1 = transK1 - transK1_Parallel_G1; 
    % The K component along the grating vector will be affected by the
    % grating
    transK2_Parallel_G1 = transK1_Parallel_G1 + repmat((repmat(o1,[3,1]).*G1),[1,nRay]); 
    transK2_Perpendicular_G1 = transK1_Perpendicular_G1;    
    transK2 = transK2_Perpendicular_G1 + transK2_Parallel_G1; 
    else
        % For refractive surface the transversal component of the K vector
        % remains unchanged.   
        transK2 = transK1;
    end    
    % Refraction
    longK2 = repmat(sqrt((k0.*n2).^2 - (computeNormOfMatrix(transK2,1)).^2),[3,1]).*e;
    TIR = zeros(1,nRay);
    % If longK2 is complex then there is TIR 
    absLongK2 = computeNormOfMatrix(longK2,1);
    TIR(find(imag(absLongK2))) = 1;
end
K2 = transK2 + longK2;
absK2 = computeNormOfMatrix(K2,1);
S2 = K2./repmat(absK2,[3,1]);
end

