function [Qf Uf] = QUTrace(Qi,Ui,initialSurf,finalSurf, refIndex,thick,curv)
%QUTrace: Performs QU trace for meridional rays of conventional optical system (spherical and rotationally symetric)
%   Inputs
% Qi,Ui,: perpendicular heght of the ray from the surface vertex, Q, and its slope (tangent of angle), U
% initialSurf,finalSurf,: initial and final surface indices NB. in MATLAB indeces start from 1
% refIndex,thick,curv : arrays of n,t of medium following and C of each surface from object to image direction
%   Output
% Qf,Uf,: height from the optical axis, y, and its slope (tangent of angle), u

% Example Call
% QUTrace(0.56,0,2,[1 1.4 1.4],[4 2 5],[Inf 3 -3])
if initialSurf==finalSurf
    Qf=Qi;
    Uf=Ui;
elseif initialSurf < finalSurf
%forward trace
%ray parametrs just after the initial ray
    Q=Qi;
    U=Ui;
    for k=initialSurf:1:finalSurf-1
        t=thick(k);
        c=curv(k+1);
        n=refIndex(k);
        nPrime=refIndex(k+1); 
        if t~=Inf
          Q = Q + t*sin(U);
        end

        I = asin(Q*c + sin (U));
        if any(imag(I))
          disp ('The ray does not intersect the surface');
          exit
        end
        IPrime = asin((n/nPrime) * sin (I));
        UPrime = U - I + IPrime ;
        % QPrime = (sin(IPrime)-sin(UPrime))/c; 
        %more general formula
        QPrime = Q*(cos(UPrime)+cos(IPrime))/(cos(U)+cos(I));
        Q = QPrime;
        U = UPrime;
    end
    Qf=Q;
    Uf=U;
elseif initialSurf > finalSurf
    %reverse trace
    Q = Qi;
    U = -Ui;    
    for k=initialSurf:-1:finalSurf+1
        t=thick(k-1);
        c=-curv(k);
        n=refIndex(k);
        nPrime=refIndex(k-1);        
        I = asin(Q*c + sin (U));       
        if any(imag(I))
            disp ('The ray does not intersect the surface')
            exit
        end
        IPrime = asin((n/nPrime) * sin (I));
        UPrime = U - I + IPrime; 
        %QPrime = (Sin(IPrime)-sin(UPrime))/c;           
        %more general formula
        QPrime = Q*(cos(UPrime)+cos(IPrime))/(cos(U)+cos(I));
        if t~=Inf
           Q = QPrime + t*sin(UPrime);
        end

        U = UPrime;
     end      
    Qf = Q;
    Uf = -U;
else   
end     
end





