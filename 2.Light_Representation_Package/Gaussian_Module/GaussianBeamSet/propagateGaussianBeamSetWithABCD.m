function [ gaussianBeamOut] = propagateGaussianBeamSetWithABCD( gaussianBeamSet, ...
        ABCDInX, ABCDInY,finalCentralRayPosition,finalCentralRayDirection,...
        finalCentralRayWavelength,finalXDirection,finalYDirection )
    %propagateGaussianBeamSetWithABCD. Propagate gaussian beam with ABCD matrices
    % The code is also vectorized. Multiple inputs and outputs are possible.
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Nov 07,2014   Worku, Norman G.     Original Version
    
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    [ qxIn,qyIn ] = getComplexQParameter(gaussianBeamSet);
    Ax = ABCDInX(1,1,:);
    Bx = ABCDInX(1,2,:);
    Cx = ABCDInX(2,1,:);
    Dx = ABCDInX(2,2,:);
    qxOut = (Ax.*qxIn + Bx)./((Cx.*qxIn + Dx));
    
    Ay = ABCDInY(1,1,:);
    By = ABCDInY(1,2,:);
    Cy = ABCDInY(2,1,:);
    Dy = ABCDInY(2,2,:);
    qyOut = (Ay.*qyIn + By)./((Cy.*qyIn + Dy));
    
    gaussianBeamOut = fromQParametersToGaussianBeamSet...
        (qxOut,qyOut,finalCentralRayPosition,finalCentralRayDirection,...
        finalCentralRayWavelength,finalXDirection,finalYDirection);
end
