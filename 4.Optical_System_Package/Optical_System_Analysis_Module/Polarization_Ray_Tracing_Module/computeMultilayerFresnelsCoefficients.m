function [T,R,tau,rho] = computeMultilayerFresnelsCoefficients...
    (refIndex,thickness,polarisation,lambda,incAngle,n_s,n_c)
    % computeMultilayerFresnelsCoefficients: Computes the reflection and 
    % transmission of a stratified media depending on the wavelength .
    % All dimensions are in µm
    % The function is vectorized so it can work on multiple sets of 
    % inputs once at the same time.
    % Inputs:
    %   refIndex: refractive index of the layers (complex vector) or 2D
    %             matrix if it is different for each wavelength
    %   thickness: Thicknesses of the layers (Vector)or 2D matrix if it 
    %              is different for each wavelength
    %   polarisation: Polarisation of the field to be computed (String: 'TE' or 'TM')
    %   lambda: Wavelength for which the computation shall be conducted (can be Vector)
    %   incAngle: Angle of incidendence in degree (can be Vector)
    %   n_s,n_c: Refractive indices of the substrate and cladding Substrat/Cladding;
    % Outputs:
    %   T: Transmitted amplitude (komplex vector) 
    %   R: Reflected amplitude (komplex vector) 
    %   tau: Transmitted energy (reel vector) 
    %   rho: Reflected energy (reel vector)

    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % This function calculates the transfer matrix of a given system of layer.
    % Basically it works as follows: 

    % 1. Compute epsilon vector from refractive index vector and Compares the length of thickness vector and epsilon vector. If they are not
    % equal, display error message and exits the function.

    % 2. Make sure valid polarisation is defined. Otherwise prompt error
    % message to the user and exit.

    % 3. Calculate the permitivity of cladding and substrate from the refractive
    % index

    % 4. Finally claculate the transmission and reflection coefficients for each
    % waveelenth in the given wave legth array.
    
	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Call [T,R,tau,rho]=computeMultilayerFresnelsCoefficients...
    %     (epsilon,thickness,polarisation,lambda,incAngle,n_s,n_c);


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

    % compute permitivity vector
    epsilon = (refIndex).^2;
    % make sure epsilon and thickness vectors are of equal size
    if size(epsilon,1) == size(thickness,1)
        nLayer = size(epsilon,1);
    else
        msgbox(['The length of epsilon vector should be equal ',...
            'to that of thickness vector.'] ,'Error');
        M = NaN;
        return
    end

    %Validate polarisation
    if ~(strcmpi(polarisation,'TE') || strcmpi(polarisation,'TM'))
        msgbox('Polarisation should be either TE or TM','Error');
        M = NaN;
        return
    end

    % calculate the permitivity of cladding and substrate from the 
    % refractive index

    epsilon_c = (n_c).^2;
    epsilon_s = (n_s).^2;

    % Wavelength and incidence angles for multiple ray inputs
    % lambda,incAngle
    nLambda = size(lambda,2);
    nIncAngle = size(incAngle,2);
    if nLambda == 1
        nRay = nIncAngle; 
        lambda = repmat(lambda,[1,nRay]);
    elseif nIncAngle == 1
        nRay = nLambda;
        incAngle = repmat(incAngle,[1,nRay]);
    elseif nIncAngle == nLambda % Both kx and lambda for all rays given
         nRay = nLambda;
    else
        disp(['Error: The size of lambda and incAngle should '...
            'be equal or one of them should be 1.']);
        return;
    end
    
    % claculate the transmission and reflection coefficients for each
    % ray with given wavelength array or incident angle array.
    
    % K vector in substrate
    ks = (2*pi./lambda).*n_s; 
    ksx = ks.*sin((incAngle));

    % x component of K vector is the same for all layer
    kx=ksx;       

    % Z components of K vector in substrate and cladding
    ksz = sqrt((2*pi./lambda).^2.*epsilon_s - (kx).^2);
    kcz = sqrt((2*pi./lambda).^2.*epsilon_c - (kx).^2);

    %Transfer matrix
    M = computeMultilayerTransfermatrix(refIndex,thickness,polarisation,lambda,kx);

    switch upper(polarisation)
        case 'TE'
        DEN = ksz.*(squeeze(M(2,2,:)))' + kcz.*(squeeze(M(1,1,:)))' + ...
            1i*((squeeze(M(2,1,:)))' - ksz.*kcz.*(squeeze(M(1,2,:)))');
        R = (ksz.*(squeeze(M(2,2,:)))' - kcz.*(squeeze(M(1,1,:)))' - ...
            1i*((squeeze(M(2,1,:)))' + ksz.*kcz.*(squeeze(M(1,2,:)))'))./DEN;
        T = (2*ksz)./DEN;

        rho =(abs(R)).^2;
        tau = (real(kcz).*(abs(T)).^2)./(real(ksz));    

        case 'TM'
        DEN = epsilon_c.*ksz.*(squeeze(M(2,2,:)))' + ...
            epsilon_s.*kcz.*(squeeze(M(1,1,:)))' + ...
            1i*(epsilon_c.*epsilon_s.*(squeeze(M(2,1,:)))' - ...
            ksz.*kcz.*(squeeze(M(1,2,:)))');
        R = (epsilon_c.*ksz.*(squeeze(M(2,2,:)))' - ...
            epsilon_s.*kcz.*(squeeze(M(1,1,:)))' - ...
            1i*(epsilon_c.*epsilon_s.*(squeeze(M(2,1,:)))' + ...
            ksz.*kcz.*(squeeze(M(1,2,:)))'))./DEN;
        T = (2*sqrt(epsilon_c.*epsilon_s).*ksz)./DEN;

        rho =(abs(R)).^2;
        tau = (real(kcz).*(abs(T)).^2)./(real(ksz));
        absorb = ones([1,size(rho,2)])-(rho+tau);
    end    
end
