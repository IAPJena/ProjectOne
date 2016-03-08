function [Ex,xlin,ylin] = computeEx(harmonicFieldSet,selectedFieldIndex)
    if nargin < 1
        harmonicFieldSet = HarmonicFieldSet;
    end
    if nargin < 2
        selectedFieldIndex = 0;
    end
    if selectedFieldIndex
        Ex = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,1,selectedFieldIndex)); 
        nx = size(Ex,2);
        ny = size(Ex,1);
        samplingPoints = [nx;ny];
        samplingDistance = harmonicFieldSet.SamplingDistance(:,selectedFieldIndex);
        centerXY = harmonicFieldSet.Center(:,selectedFieldIndex);
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);        
    else
        Ex = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,1,:)); % 3rd dim for different fields in the set
        nx = size(Ex,2);
        ny = size(Ex,1);
        samplingPoints = [nx;ny];
        samplingDistance = harmonicFieldSet.SamplingDistance;
        centerXY = harmonicFieldSet.Center;
        [xlin,ylin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);
    end
end

