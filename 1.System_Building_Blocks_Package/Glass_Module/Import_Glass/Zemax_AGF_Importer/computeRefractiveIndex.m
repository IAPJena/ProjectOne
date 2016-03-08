function [n] = computeRefractiveIndex(glass,wavLen)
    % computeRefractiveIndex: Returns the refractive index of the glass
    % It supports vector inputs of wavlengths and gives vector output of n
    % Inputs:
    %   (glass,wavLen)
    % Outputs:
    %   [abbeNumber]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % July 28,2014   Worku, Norman G.     Original Version
    
    % for a given wavelength. Uses sellmeir1 equation.
    glassParameters = glass.CoefficientData;
    nRay = size(wavLen,2);
    format long;
    
    % all the coeffifints are in sq. µm and the wavelength in um
    % First convert Wavelength to um as all sellmeir coefficients
    % are in sq um.
    wavLen = wavLen*10^6;
    
    switch lower(strtrim(glass.GlassType))
        case lower('FixedIndex')
            n = repmat(glassParameters(1),[1,nRay]);
        case  lower('Schott')
            A0 = glassParameters(1);
            A1 = glassParameters(2);
            A2 = glassParameters(3);
            A3 = glassParameters(4);
            A4 = glassParameters(5);
            A5 = glassParameters(6);
            n = sqrt(A0 + A1*(wavLen.^2) + ...
                A2*(wavLen.^-2)+ A3*(wavLen.^-4) + ...
                A4*(wavLen.^-6)+ A5*(wavLen.^-8));
        case  lower('Sellmeier1')
            
            K1 = glassParameters(1);
            L1 = glassParameters(2);
            K2 = glassParameters(3);
            L2 = glassParameters(4);
            K3 = glassParameters(5);
            L3 = glassParameters(6);
            n = sqrt(1 + ...
                ((K1*wavLen.^2)./(wavLen.^2 - L1)) + ...
                ((K2*wavLen.^2)./(wavLen.^2 - L2)) + ...
                ((K3*wavLen.^2)./(wavLen.^2 - L3)));
        case  lower('Sellmeier2')
            
            A = glassParameters(1);
            B1 = glassParameters(2);
            L1 = glassParameters(3);
            B2 = glassParameters(4);
            L2 = glassParameters(5);
            n = sqrt(1 + A + ...
                ((B1*wavLen.^2)./(wavLen.^2 - L1^2)) + ...
                ((B2)./(wavLen.^2 - L2^2)));
        case  lower('Sellmeier3')
            K1 = glassParameters(1);
            L1 = glassParameters(2);
            K2 = glassParameters(3);
            L2 = glassParameters(4);
            K3 = glassParameters(5);
            L3 = glassParameters(6);
            K4 = glassParameters(7);
            L4 = glassParameters(8);
            n = sqrt(1 + ...
                ((K1*wavLen.^2)./(wavLen.^2 - L1)) + ...
                ((K2*wavLen.^2)./(wavLen.^2 - L2)) + ...
                ((K3*wavLen.^2)./(wavLen.^2 - L3))+ ...
                ((K4*wavLen.^2)./(wavLen.^2 - L4)));
        case  lower('Sellmeier4')
            A = glassParameters(1);
            B = glassParameters(2);
            C = glassParameters(3);
            D = glassParameters(4);
            E = glassParameters(5);
            n = sqrt( A + ...
                ((B*wavLen.^2)./(wavLen.^2 - C)) + ...
                ((D*wavLen.^2)./(wavLen.^2 - E)));
        case  lower('Sellmeier5')
            K1 = glassParameters(1);
            L1 = glassParameters(2);
            K2 = glassParameters(3);
            L2 = glassParameters(4);
            K3 = glassParameters(5);
            L3 = glassParameters(6);
            K4 = glassParameters(7);
            L4 = glassParameters(8);
            K5 = glassParameters(9);
            L5 = glassParameters(10);
            n = sqrt(1 + ...
                ((K1*wavLen.^2)./(wavLen.^2 - L1)) + ...
                ((K2*wavLen.^2)./(wavLen.^2 - L2)) + ...
                ((K3*wavLen.^2)./(wavLen.^2 - L3))+ ...
                ((K4*wavLen.^2)./(wavLen.^2 - L4))+ ...
                ((K5*wavLen.^2)./(wavLen.^2 - L5)));
        case  lower('Herzberger')
            A = glassParameters(1);
            B = glassParameters(2);
            C = glassParameters(3);
            D = glassParameters(4);
            E = glassParameters(5);
            F = glassParameters(6);
            
            L = 1./(wavLen.^2 - 0.028);
            n =  A + B*L + C*L.^2 + D*L.^2 + ...
                E*L.^4 + F*L.^6;
            
        case  lower('Conrady')
            n0 = glassParameters(1);
            A = glassParameters(2);
            B = glassParameters(3);
            
            n =  n0 + A./wavLen + B./wavLen.^3.5;
            
        case  lower('HandbookOfOptics1')
            A = glassParameters(1);
            B = glassParameters(2);
            C = glassParameters(3);
            D = glassParameters(4);
            
            n = sqrt(A + B./(wavLen^2-C)-D*wavLen^2);
        case  lower('HandbookOfOptics2')
            A = glassParameters(1);
            B = glassParameters(2);
            C = glassParameters(3);
            D = glassParameters(4);
            
            n = sqrt(A + ...
                (B*wavLen.^2)./(wavLen.^2-C) - D*wavLen^2);
        case  lower('Extended')
            A0 = glassParameters(1);
            A1 = glassParameters(2);
            A2 = glassParameters(3);
            A3 = glassParameters(4);
            A4 = glassParameters(5);
            A5 = glassParameters(6);
            A6 = glassParameters(7);
            A7 = glassParameters(8);
            
            n =  A0 + A1*wavLen.^2 + A2*wavLen.^-2 + ...
                A3*wavLen.^-4 + A4*wavLen.^-6 + ...
                A5*wavLen.^-8 + A6*wavLen.^-10 + ...
                A7*wavLen.^-12;
            
        case  lower('Extended2')
            A0 = glassParameters(1);
            A1 = glassParameters(2);
            A2 = glassParameters(3);
            A3 = glassParameters(4);
            A4 = glassParameters(5);
            A5 = glassParameters(6);
            A6 = glassParameters(7);
            A7 = glassParameters(8);
            
            n =  A0 + A1*wavLen.^2 + A2*wavLen.^-2 + ...
                A3*wavLen.^-4 + A4*wavLen.^-6 + ...
                A5*wavLen.^-8 + A6*wavLen.^4 + ...
                A7*wavLen.^6;
        case  lower('Extended3')
            A0 = glassParameters(1);
            A1 = glassParameters(2);
            A2 = glassParameters(3);
            A3 = glassParameters(4);
            A4 = glassParameters(5);
            A5 = glassParameters(6);
            A6 = glassParameters(7);
            A7 = glassParameters(8);
            A8 = glassParameters(9);
            
            n =  A0 + A1*wavLen.^2 + A2*wavLen.^4 +...
                A3*wavLen.^-2 + A4*wavLen.^-4 + ...
                A5*wavLen.^-6 + A6*wavLen.^-8 + ...
                A7*wavLen.^-10 + A8*wavLen.^-12;
    end
    
end