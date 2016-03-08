function [ isHarmonicFieldSet ] = isHarmonicFieldSet( currentHarmonicFieldSet )
    %ISHarmonicFieldSet Summary of this function goes here
    %   Detailed explanation goes here
    isHarmonicFieldSet = 0;
    if isstruct(currentHarmonicFieldSet)
        if isfield(currentHarmonicFieldSet,'ClassName') && strcmpi(currentHarmonicFieldSet.ClassName,'HarmonicFieldSet')
           isHarmonicFieldSet = 1; 
        end
    else
        if strcmpi(class(currentHarmonicFieldSet),'HarmonicFieldSet')
            isHarmonicFieldSet = 1; 
        end
    end
    
end

