function [ stopIndex,stopClearAperture] = computeSystemStopIndex(optSystem,givenStopIndex)
    % computeSystemStopIndex: calculate the stop index
    % the stop index may be given directly by the user
    % Inputs
    % 	givenStopIndex: Stop index if specified by user otherwise = 0
    % Output
    % 	stopIndex: surface index of stop surface.
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
    
    % send pseudo mariginal ray from oxial point at object
    
    % if the stop surface is fixed by the user
    if givenStopIndex
        stopIndex = givenStopIndex;
        stopClearAperture = getClearAperture(optSystem.getNonDummySurfaceArray(stopIndex));
    else
        % If stop index not given by user then compute it
        nSurf = getNumberOfSurfaces(optSystem);
        refIndex = zeros(1,nSurf);
        thick = zeros(1,nSurf);
        curv = zeros(1,nSurf);
        clearAperture = zeros(1,nSurf);
        
        for kk=1:1:nSurf
            currentSurf = getSurfaceArray(optSystem,kk);
            refIndex(kk) = getRefractiveIndex(currentSurf.Glass,optSystem.PrimaryWavelengthIndex);
            thick(kk) = currentSurf.Thickness;
            try
                curv(kk) = 1/(currentSurf.OtherStandardData.Radius);
            catch
                % If the surface doesn't have Radius data then consider as
                % plane
                curv(kk) = 0;
            end
            
            % clearAperture(kk) = optSystem.getSurfaceArray(kk).getClearAperture;
            [ minApertureRadius ] = getMinimumApertureRadius( currentSurf.Aperture );
            clearAperture(kk) = minApertureRadius;
        end
        
        % For -ve thickness refindex should also be negative
        refIndex = refIndex.*sign(thick);
        % Replace zero index with 1 to avoid division by zero
        refIndex(refIndex==0) = 1;
        
        if abs(thick(1))>10^10
            thick(1)=10^10;
            obj = 'I';
        else
            obj = 'F';
        end
        if optSystem.IsImageAfocal
            img = 'I';
        else
            img = 'F';
        end
        obj_img = [obj,img];
        
        if strcmpi(obj_img,'IF') || strcmpi(obj_img,'II')
            % for object side afocal systems (object from infinity)
            ytm = 0.01;
            utm = 0;
        else
            % assume object surface at origin of the coordinate system
            ytm = 0;
            utm = 0.01;
        end
        
        % compute clear aperture to height ratio for each surface
        CAy(1) = abs((clearAperture(1))/(ytm));
        for kk=1:1:nSurf-1
            initialSurf = kk;
            finalSurf = kk+1;
            wavlenInM = getPrimaryWavelength(optSystem);
            [ ytm,utm ] = paraxialRayTracer( optSystem,ytm,utm,initialSurf,finalSurf,wavlenInM);
            % 		  [ytm,utm]=yniTrace(ytm,utm,kk,kk+1, refIndex,thick,curv);
            CAy(kk+1) = abs((clearAperture(kk+1))/(ytm));
        end
        
        % the surface with minimum value of clear aperture to height ratio is the stop
        [C,I] = min(CAy);
        stopIndex = I;
        stopClearAperture = clearAperture(stopIndex);
    end
end
