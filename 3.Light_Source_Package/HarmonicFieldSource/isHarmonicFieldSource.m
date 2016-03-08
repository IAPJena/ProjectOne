function [ isHarmonicFieldSource ] = isHarmonicFieldSource( currentHarmonicFieldSource )
    %ISHarmonicFieldSource Summary of this function goes here
    %   Detailed explanation goes here
    isHarmonicFieldSource = 0;
    if isstruct(currentHarmonicFieldSource)
        if isfield(currentHarmonicFieldSource,'ClassName') && strcmpi(currentHarmonicFieldSource.ClassName,'HarmonicFieldSource')
           isHarmonicFieldSource = 1; 
        end
    else
        if strcmpi(class(currentHarmonicFieldSource),'HarmonicFieldSource')
            isHarmonicFieldSource = 1; 
        end
    end
    
end

