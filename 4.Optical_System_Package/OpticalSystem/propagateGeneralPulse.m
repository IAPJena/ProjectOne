function [ outputPulse ] = propagateGeneralPulse( optSystem,inputPulse,outputWindowSize,deltaZ )
    %PROPAGATEGENERALPULSE Propagates a general pulse using hybrid model
    % GeOp to Exit pupil and Fraunhofer diffraction to Focus
    % all dimensions are in meter
    
    if nargin < 4
        deltaZ = 0;
    end
    % use geometric propagation for Entrance to exit pupil propagation
    inputHarmonicFieldSet = inputPulse.PulseHarmonicFieldSet;
    endSurfaceIndex = 'ExP'; % trace to exit pupil sphere
    phaseToDirMethod = 2; % use gradient method
    effectsToInclude = 1; % only OPL
    
    [ exitPupilHarmonicFieldSet ] = GeometricalOpticsPropagator( ...
        optSystem, inputHarmonicFieldSet, endSurfaceIndex, phaseToDirMethod, effectsToInclude );
    
    % Use fraunhofer diffraction from exit pupil to focal region
    exitPupilLocationFromImageSurf = - getExitPupilLocation(optSystem)*...
        getLensUnitFactor(optSystem); % +ve if ExP is to left of image
    propagationDistance = deltaZ + exitPupilLocationFromImageSurf;
    addSphericalCorrection = 1;
    
    inputHarmonicFieldArray = exitPupilHarmonicFieldSet.HarmonicFieldArray;
    nFields = size(inputHarmonicFieldArray,2);
    finalFocalRegionHarmonicFieldSet(nFields) = HarmonicFieldSet;
    
    for ff = 1:nFields
        finalFocalRegionHarmonicFieldArray(ff) = ScalarFraunhoferPropagator( exitPupilHarmonicFieldSet.HarmonicFieldArray(ff),...
            propagationDistance,outputWindowSize,addSphericalCorrection );
    end
    finalFocalRegionHarmonicFieldSet = HarmonicFieldSet(finalFocalRegionHarmonicFieldArray);
    outputPulse = GeneralPulse(finalFocalRegionHarmonicFieldSet);
end

