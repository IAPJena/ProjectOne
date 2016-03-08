function [U, H] = poldec(A)
    %POLDEC: Polar decomposition of square matrix A.
    %   [U, H] = POLDEC(A) computes a matrix U of the same dimension
    %   (m-by-m) as A, and a Hermitian positive semi-definite matrix H,
    %    such that A = U*H. It uses SVD of A as described in the ref.

    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %    Reference:
    %    N. J. Higham, Computing the polar decomposition---with applications,
    %    SIAM J. Sci. Stat. Comput., 7(4):1160--1174, 1986.
    
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

	% <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if ~(isnan(A(1,1)) || isnan(A(2,2)))
        %if ~(isnan(A(1,1)) || isnan(A(2,2)) || isnan(A(3,3)))

        [m, m] = size(A);
        [P, S, Q] = svd(A);  % singular value decomposition.
        U = P*Q';
        if nargout == 2
           H = Q*S*Q';
           H = (H + H')/2; % Force Hermitian by taking nearest Hermitian matrix.
        end
    else
        U = NaN;
        H = NaN;
    end

