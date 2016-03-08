function [newLocalRayDirection,TIR] = computeGeneralRefractionReflection ...
        (incidentDirection,surfaceNormal,indexBefore,indexAfter,...
        wavelengthInMicrometer,diffractionOrder,gratingVector,...
        gratingLinesPerMicrometer)
    % computeGeneralRefractionReflection to calculate the new direction
    % after refraction or reflection and diffraction by grating
    % The function is vectorized so it can work on multiple sets of
    % inputs once at the same time.
    % NB: if diffractionOrder = 0 , then the diffraction effects are ignored
    % and the simplified equation will be used
    % NB: The indexBefore = indexAfter and sign of surfNormal shall be inverted
    % for the case of reflection. (That shall be done before ccalling this
    % function).
    
    % <<<<<<<<<<<<<<<<<<<<<<< Algorithm Section>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Ref: General Ray-Tracing Proceduret G. H. SPENCER* AND M. V. R. K. MURTY
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Example Usage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Sep 18,2015  Worku, Norman G.     Vectorized inputs and outputs
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    s1 = incidentDirection;
    N1 = indexBefore;
    N2 = indexAfter;
    e = surfaceNormal;
    T = gratingLinesPerMicrometer;
    m = diffractionOrder;
    wavInUM = wavelengthInMicrometer;
    
    nRay = size(s1,2);
    TIR = zeros([1,nRay]);
    
    e_dot_s1 = compute3dDot(e,s1);
    u = (N1./N2); % scalar
    if diffractionOrder
        % Useful replacements
        p = gratingVector;
        L = (m*wavInUM/N2)*(T);
        p_dot_s1 = compute3dDot(p,s1);
        % The general refraction/reflection/diffraction equation
        s2 = (ones(3,1)*u).*s1 + (ones(3,1)*(-u.*e_dot_s1 + ...
            (sqrt(1-(u.^2).*(1-e_dot_s1.^2) - L.^2 + 2*u.*L.*p_dot_s1)))).*e - ...
            (ones(3,1)*L).*p;
    else
        % The general refraction/reflection equation
        s2 = (ones(3,1)*u).*s1 + (ones(3,1)*(-u.*e_dot_s1 + ...
            (sqrt(1-(u.^2).*(1-e_dot_s1.^2))))).*e ;
    end
    totIR = (imag(sum(s2,1))~=0);
    
    newLocalRayDirection = s2;
    newLocalRayDirection(:,totIR) = NaN ;
    TIR(totIR) = 1;
end


