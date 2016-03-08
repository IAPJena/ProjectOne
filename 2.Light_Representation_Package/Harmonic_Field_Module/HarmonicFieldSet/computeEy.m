function [Ey,xlin,ylin] = computeEy(harmonicFieldSet,selectedFieldIndex)
    if nargin < 1
        harmonicFieldSet = HarmonicFieldSet;
    end
    if nargin < 2
        selectedFieldIndex = 0;
    end
    if selectedFieldIndex
        Ey = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,2,selectedFieldIndex)); 
        nx = size(Ey,2);
        ny = size(Ey,1);
        samplingPoints = [nx;ny];
        samplingDistance = harmonicFieldSet.SamplingDistance(:,selectedFieldIndex);
        centerXY = harmonicFieldSet.Center(:,selectedFieldIndex);
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);
    else
        Ey = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,2,:)); % 3rd dim for different fields in the set
        nx = size(Ey,2);
        ny = size(Ey,1);
        samplingPoints = [nx;ny];
        samplingDistance = harmonicFieldSet.SamplingDistance;
        centerXY = harmonicFieldSet.Center;
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);
    end
end

