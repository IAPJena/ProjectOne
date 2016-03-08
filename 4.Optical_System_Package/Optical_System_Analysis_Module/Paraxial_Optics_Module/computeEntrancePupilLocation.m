function [ pupilPosition ] = computeEntrancePupilLocation(optSystem)
    % computeEntrancePupilLocation: compute the paraxial entrance pupil
    % position from first optical surface
    
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
    
    % Trace a paraxial ray from axial point @ stop and determine the
    % corresponding ray parameter at object surface.
    ystop = 0;
    ustop = 0.01;
    initialSurf = getStopSurfaceIndex(optSystem);
    finalSurf = 1;
    wavlenInM = getPrimaryWavelength(optSystem);
    [ yobj,uobj ] = paraxialRayTracer( optSystem,ystop,ustop,initialSurf,finalSurf,wavlenInM);
    % Then entrance pupil position is where this object ray crosses the
    % optical axis
    nonDummySurfaceArray = getNonDummySurfaceArray(optSystem);
    if abs(nonDummySurfaceArray(1).Thickness) > 10^10
        objThick = 0;
    else
        objThick = nonDummySurfaceArray(1).Thickness;
    end
    pupilPosition = -yobj/uobj- objThick; %from 1st surface of the optical system
end
