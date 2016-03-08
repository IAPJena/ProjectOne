function transMatrix = computeMultilayerTransfermatrix ...
    (refIndex, thickness, polarisation, lambda, kx)
    % computeMultilayerTransfermatrix: Computes the transfer matrix  
    %                           for a given stratified media 
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % All dimensions are in µm
    % Inputs:
    %   refIndex: refractive index of the layers (complex vector) or 2D
    %             matrix if it is different for each wavelength
    %   thickness: Thicknesses of the layers (Vector)or 2D matrix if it 
    %              is different for each wavelength
    %   polarization: Polarisation of the field to be computed (string: 'TE' or 'TM')
    %   lambda: Wavelength of the light (scalar)
    %   kx: Component of the wavevector in transvers direction [1/µm] (scalar)
    % Output:
    %   M: Transfer matrix (matrix)

    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % This function calculates the transfer matrix of a given system of nLayer.
    % Basically it works as follows: 

    % 1. Compute permitivity vector from refIndex vector and Compares the 
    % length of thickness vector and epsilon vector. If they are not
    % equal, display error message and exits the function.

    % 2. Make sure valid polarisation is defined. Otherwise prompt error
    % message to the user and exit.

    % 3. Claculate z component of K vector for each nLayer

    % 4. Calculate alpha which is different for the two polarisations 

    % 5. Finally determine the transfer matrix of each nLayer and multiply
    % iteratively to determine the total transfer matrix of the system.	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Function call M = computeMultnLayerTransfermatrix(epsilon, thickness, ...
    %                                            polarisation, lambda, kx);

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
	%	Optical System Design and Simulation Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    
	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    % Handle Multiple ray inputs lambda, kx
        nLambda = size(lambda,2);
        nKx = size(kx,2);
        if nLambda == 1
            nRay = nKx;
            lambda = repmat(lambda,[1,nRay]);
        elseif nKx == 1
            nRay = nLambda;
            kx = repmat(kx,[1,nRay]);
        elseif nKx == nLambda % Both kx and lambda for all rays given
             nRay = nLambda;
        else
            disp(['Error: The size of lambda and kx should '...
                'be equal or one of them should be 1.']);
            return;
        end
    
    % compute permitivity vector
    epsilon = (refIndex).^2;
    % make sure epsilon and thickness vectors are of equal size
    if size(epsilon,1) == size(thickness,1)
        nLayer = size(epsilon,1);
    else
        msgbox('The length of epsilon vector should be equal to that of thickness vector.' ,'Error');
        M = repmat(NaN*eye(2),[1,nRay]);
        return
    end

    %Validate polarisation
    if ~(strcmpi(polarisation,'TE') || strcmpi(polarisation,'TM'))
        msgbox('Polarisation should be either TE or TM','Error');
        M = repmat(NaN*eye(2),[1,nRay]);
        return
    end

    % calculate alpha for two cases of polarisation
    switch upper(polarisation)
        case 'TE'
            alpha = ones([1,nLayer]); %just to make it 1
        case 'TM'
            alpha =1./epsilon;
    end

    % multiply the transfer matrix of each nLayer to get the total transfer
    % matrix
    M = repmat(eye(2),[1,1,nRay]);
    for t=1:1:nLayer
        % claculate z component of K vector for each nLayer
        kz = sqrt((2*pi./lambda).^2.* epsilon(t,:)-(kx).^2);
        % tempM = [[m11,m12,m21,m22]',...]
        m11 = cos(kz.*thickness(t,:));
        m12 = sin(kz.*thickness(t,:))./(kz.*alpha(t));
        m21 =  -sin(kz.*thickness(t,:)).*(kz.*alpha(t));
        m22 = cos(kz.*thickness(t,:));
        % Construct 2x2xnRay matrix of mi
        mi(1,1,:)= m11;
        mi(1,2,:)= m12;
        mi(2,1,:)= m21;
        mi(2,2,:)= m22;         
        M  = multiplySliced3DMatrices( mi,M );
    end
    transMatrix = M;
end