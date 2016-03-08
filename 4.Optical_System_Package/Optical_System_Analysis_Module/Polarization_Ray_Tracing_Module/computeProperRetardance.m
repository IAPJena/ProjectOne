function allRetardance = computeProperRetardance( PorJ,QorR )
    % computeProperRetardance:  computes proper retardance associated with a
    % given P matrix or Jones matrix. 
    % The function can accept multiple Jones/polarization matrices as 3x3xN
    % or 2x2xN matrix and gives out 1xN vector of retardance values.
    % Input:
    %   PorJ: Either the polarization matrix (3x3xN) or the Jones matrix (2x2xN).
    %         They can be identified by their sizes.
    %   QorR: For P matrix ,QorR will be  the parallel transport matrix Q 
    %         and for jones vector it will be flag for reflection R.
    % Output:
    %   retardance: (1xN) Proper retardance related to the polarization matrix 
    %   or the jones matrix 

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
    firstDim = size(PorJ,1);
    secondDim = size(PorJ,2);
    if ndims(PorJ) > 2
        thirdDim = size(PorJ,3);
    else
        thirdDim = 1;
    end
    
    retardance = zeros(1,thirdDim);
    for k = 1:thirdDim
        if firstDim == 2 % PorJ is a 2X2 jones matrix
            J = PorJ(:,:,k);
            R = QorR(k);
            if ~(isnan(J(1,1)) || isnan(J(2,2)))
                %[JR,JD] = poldec(J);
                %[V,D] = eig(JR);
                
                % For reflection, the retardance is the phase of the P polarization
                % minus the phase of the S polarization plus
                if R == 1
                    % For reflection, the retardance is the phase of the P
                    % polarization minus the phase of the S polarization plus pi
                    
                    % But now just take the difference to make it comparable with
                    % Zemax plot
                    %  retard = angle(J(1,1))-angle(J(2,2)) + pi;
                     retard = angle(J(1,1))-angle(J(2,2));
                else
                    % For transmission, the retardance is the phase of the P
                    % polarization minus the phase of the S polarization
                    
                    % But now just take the difference to make it comparable with
                    % Zemax plot
                    retard = angle(J(1,1))-angle(J(2,2));
                end
                while retard > pi
                    retard = retard - 2*pi;
                end
                while retard < -pi
                    retard = retard + 2*pi;
                end
                retardance(k) = retard;
            else
                retardance(k) = NaN;
            end
        elseif firstDim == 3 && secondDim  == 3 % PorJ is a 3X3 P matrix
            P = PorJ(:,:,k);
            Q = QorR(:,:,k);
            if ~(isnan(P(1,1)) || isnan(P(2,2)) || isnan(P(3,3)) || isnan(Q(1,1)) || isnan(Q(2,2)) || isnan(Q(3,3)))
                M = inv(Q)*P;
                [MR,MD] = poldec(M);
                [V,D] = eig(MR);
                % difference between phases of non unity eigen values
                noneUnityDiag = extractNoneUnityDiagonal(D);
                retard = angle(noneUnityDiag(1))-angle(noneUnityDiag(2));
                
                %retard = angle(D(2,2))-angle(D(3,3));
                %         while retard > pi
                %             retard = retard - 2*pi;
                %         end
                %         while retard < -pi
                %             retard = retard + 2*pi;
                %         end
            else
                retard = NaN;
            end
        else
            
        end
        retardance(k) = (retard);
    end
    % Replace very small numbers < 10^-8 with 0
    retardance(retardance<10^-8) = 0;
    
    allRetardance = retardance;
end

