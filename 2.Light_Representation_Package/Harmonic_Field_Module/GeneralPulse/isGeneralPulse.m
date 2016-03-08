function [ isGeneralPulse ] = isGeneralPulse( currentGeneralPulse )
    %ISGeneralPulse Summary of this function goes here
    %   Detailed explanation goes here
    isGeneralPulse = 0;
    if isstruct(currentGeneralPulse)
        if isfield(currentGeneralPulse,'ClassName') && strcmpi(currentGeneralPulse.ClassName,'GeneralPulse')
           isGeneralPulse = 1; 
        end
    else
        if strcmpi(class(currentGeneralPulse),'GeneralPulse')
            isGeneralPulse = 1; 
        end
    end
    
end

