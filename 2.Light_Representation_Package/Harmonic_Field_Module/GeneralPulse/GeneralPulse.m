function NewGeneralPulse = GeneralPulse(harmonicFieldSet,direction)
    if nargin == 0
        harmonicFieldSet =  HarmonicFieldSet();
        direction = [0,0,1]';
    elseif nargin == 1
        direction = [0,0,1]';
    else
        
    end
    NewGeneralPulse.PulseHarmonicFieldSet = harmonicFieldSet;
    NewGeneralPulse.Direction = direction;
    NewGeneralPulse.ClassName = 'GeneralPulse';
end

