function [ EFL ] = computeEffectiveFocalLength( optSystem )
    % computeEffectiveFocalLength: computes the effective focal length of system by
    %                         tracing collimated rays.
    
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
        %           thick(1)=10^10;
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
    
    if strcmpi(obj_img,'FF') || strcmpi(obj_img,'IF')
        y0 = 0.01;
        u0 = 0;
%         [ nonDummySurfaceArray,nNonDummySurface,nonDummySurfaceIndices,...
%         surfaceArray,nSurface ] = getNonDummySurfaceArray( optSystem );
    
        [nSurface, surfaceArray ] = getNumberOfSurfaces(optSystem);
        initialSurf = 1;
        finalSurf = nSurface-1;
        wavlenInM = getPrimaryWavelength(optSystem);
        [ yf,uf ] = paraxialRayTracer( optSystem,y0,u0,initialSurf,finalSurf,wavlenInM);
        EFL = -y0/uf;
        % In image space
        lastIndex = getRefractiveIndex(surfaceArray(finalSurf).Glass,wavlenInM);
        EFL = EFL * lastIndex;
    elseif strcmpi(obj_img,'FI') || strcmpi(obj_img,'II')
        EFL = Inf;
    end
end

