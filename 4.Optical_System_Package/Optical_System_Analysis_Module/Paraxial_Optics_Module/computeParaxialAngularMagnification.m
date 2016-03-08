function [ angMag] = computeParaxialAngularMagnification(optSystem)
    % computeParaxialAngularMagnification: computes the paraxial angular
    %                                   magnificatrion using Lagrange invariant.
    
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
    
    % trace a paraxial cheif ray from stop to forward and backward.
    % Then compute the angular magnification
    % Angular magnification
    % The ratio of the paraxial image space chief ray angle to the paraxial object space chief ray angle. The angles
    % are measured with respect to the paraxial entrance and exit pupil locations.
    
    ystop = 0;
    ustop = 0.01;
     
    [stopIndex] =  getStopSurfaceIndex(optSystem);
    initialSurf = stopIndex;
    [ NonDummySurfaceIndices,surfaceArray,nSurface ] = getNonDummySurfaceIndices( optSystem );
    nonDummySurfaceArray = surfaceArray(NonDummySurfaceIndices);
    
    nNonDummySurface = length(nonDummySurfaceArray);
    finalSurfObjSide = 1;
    finalSurfImgSide = nNonDummySurface - 1;
    
    wavlenInM = getPrimaryWavelength(optSystem);
    [ yimg,uimg ] = paraxialRayTracer( optSystem,ystop,ustop,initialSurf,finalSurfImgSide,wavlenInM);
    [ yobj,uobj ] = paraxialRayTracer( optSystem,ystop,ustop,initialSurf,finalSurfObjSide,wavlenInM);
    
    objSideIndex = getRefractiveIndex(nonDummySurfaceArray(finalSurfObjSide).Glass,wavlenInM);
    imgSideIndex = getRefractiveIndex(nonDummySurfaceArray(finalSurfImgSide).Glass,wavlenInM);
    angMag = (uimg*imgSideIndex)/(uobj*objSideIndex);
end
    
