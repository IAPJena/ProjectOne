function objNA = computeObjectNA...
        (optSystem,entPupilLocation, objectRefractiveIndex,objThick)
    % computeObjectNA: compute the paraxial object space NA
    % Inputs
    %   systemApertureType: 'ENPD' given enterenace pupil, 'OBNA' given object NA,
    %   ...
    %   systemApertureValue: value of aperture specified
    %   entPupilLocation: location of enterenace pupil from first surface
    %   objectRefractiveIndex: object side refractive index
    %   objThick: thickness from object surface to 1st surface
    
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
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    systemApertureType = optSystem.SystemApertureType;
    systemApertureValue = optSystem.SystemApertureValue;
    switch (systemApertureType)
        case 1 %'ENPD' % given 'Enterance Pupil Diameter entPupilLocation, objectRefractiveIndex,objThick
%             U0 = -(0.5*(systemApertureValue)/(entPupilLocation+objThick));
%             objNA = abs((U0) * objectRefractiveIndex);
            
            U0 = atan(0.5*(systemApertureValue)/(entPupilLocation+objThick));
            objNA = abs(sin(U0) * objectRefractiveIndex);
        case 2 %'OBNA' % given 'Object Space NA'
            objNA  = systemApertureValue;
        case 3 %'FLST' % Float by stop size
            % Trace a paraxial ray from object to stop and then determine the scaling
            % factor of initial angle so that the ray height at stop is equal to stop
            % surface aperture radius.
            entrancePupilDiameter = getEntrancePupilDiameter(optSystem);
%             U0 = -(0.5*(entrancePupilDiameter)/(entPupilLocation+objThick));
            U0 = atan(0.5*(entrancePupilDiameter)/(entPupilLocation+objThick));
            objNA = abs(sin(U0) * objectRefractiveIndex);
            
%             yobj = 0;
%             uobj = 0.01;
%             initialSurf = 1;
%             stopSurf = getStopSurfaceIndex(optSystem);
%             wavlenInM = getPrimaryWavelength(optSystem);
%             [ ystop,ustop ] = paraxialRayTracer( optSystem,yobj,uobj,initialSurf,stopSurf,wavlenInM);
%             
%             stopApertureRadius = getMaximumApertureRadius(optSystem.SurfaceArray(stopSurf).Aperture);
%             scaleFactor = stopApertureRadius/ystop;
%             
%             U0 = scaleFactor*uobj;
% %             objNA = objectRefractiveIndex*sin(U0);
%             objNA = objectRefractiveIndex*sin(U0);
        case 4 %'OBFN' % given 'Object Space F#'
            
        case 5 %'IMNA' % given 'Image Space NA'
            
        case 6 %'IMFN' % given 'Image Space F#'
            
        otherwise
            objNA = abs(objNA);
    end
end
    
