function diattenuation = computeDiattenuation( PorJ )
    % computeDiatteunation: computes the diatteunation related to the
    % Polarization matrix using singular value  or the Jones matrix using eigen
    % value decomposisiton. The function can accept multiple
    % Jones/polarization matrices as 3x3xN or 2x2xN matrix and gives out 
    % 1xN vector of diattenuation values.
    % Input:
    %   PorJ: Either the polarization matrix or the Jones matrix. They can be
    %   identified by their sizes.
    % Output:
    %   diattenuation: diattenuation related to the polarization matrix or the
    %   jones matrix 
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%	

	% <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%

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
    % Mar 07,2014   Worku, Norman G.     Vectorial input/output
    
	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    % Check for the size of the input matrix to determine whether 2x2 Jones matrix
    % or 3x3 Polarization ray tracing matrix
    matDim = size(PorJ);
    diattenuation = zeros(1,matDim(3));
    % As matlab functions such as eigs don't support 3d matrix input loop
    % is used to compute for multiple inputs.
    for k = 1:matDim(3)
        if matDim(1) == 2 % PorJ is a 2X2 jones matrix
            J = PorJ(:,:,k);
            if ~(isnan(J(1,1)) || isnan(J(2,2)))
                %eigenValues = eig(abs(J));
                %diattenuation = abs((eigenValues(1)-eigenValues(2))/(eigenValues(1)+eigenValues(2)));
                eigenValues = eigs(abs(J)); % Sorted eigen values (decending)
                diattenuation(k) = ...
                    (((eigenValues(1)))^2-((eigenValues(2)))^2)/...
                    (((eigenValues(1)))^2+((eigenValues(2)))^2);
            else
                diattenuation(k) = NaN;
            end
        elseif matDim(1) == 3 % PorJ is a 3X3 polarization matrix
            P = PorJ(:,:,k);
            if ~(isnan(P(1,1)) || isnan(P(2,2)) || isnan(P(3,3)))
                [U,S,V] = svd(P);
                noneUnityDiag = extractNoneUnityDiagonal(S);
                diattenuation(k) = ...
                    ((max(noneUnityDiag))^2-(min(noneUnityDiag))^2)/...
                    ((max(noneUnityDiag))^2+(min(noneUnityDiag))^2);
            else
                diattenuation(k) = NaN;
            end
        else
            
        end
    end
    % Replace very small numbers < 10^-8 with 0
    diattenuation(diattenuation<10^-8) = 0;
end

