function [ lastThickness] = computeParaxialImageLocation(optSystem)
    % computeParaxialImageLocation: solves for location of paraxial images.
    
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
    if abs(optSystem.SurfaceArray(1).Thickness)>10^10 || optSystem.IsObjectAfocal
        obj = 'I';
    else
        obj = 'F';
    end
    if optSystem.IsImageAfocal
        img = 'I';
    else
        img = 'F';
    end
    obj_img = [obj, img];
    
    % trace a paraxial axial ray
    if strcmpi(obj_img,'FF')
        y0 = 0;
        u0 = 0.01;
        initialSurf = 1;
        finalSurf = getNumberOfSurfaces(optSystem)-1;
        wavlenInM = getPrimaryWavelength(optSystem);
        [ yf,uf ] = paraxialRayTracer( optSystem,y0,u0,initialSurf,finalSurf,wavlenInM);
        lastThickness = -yf/uf;
    elseif  strcmpi(obj_img,'FI') || strcmpi(obj_img,'II')
        lastThickness = Inf;
    elseif strcmpi(obj_img,'IF')
        y0 = 0.01;
        u0 = 0;
        initialSurf = 1;
        finalSurf = getNumberOfSurfaces(optSystem)-1;
        wavlenInM = getPrimaryWavelength(optSystem);
        [ yf,uf ] = paraxialRayTracer( optSystem,y0,u0,initialSurf,finalSurf,wavlenInM);
        lastThickness = -yf/uf;
    end
