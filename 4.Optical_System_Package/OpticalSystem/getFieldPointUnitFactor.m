function [ fieldUnitFactor, fieldUnitText] = getFieldPointUnitFactor( optSystem )
    %getFieldPointUnitFactor returns the factor for unit used for field points
    % defintion in the system. Returns the lens unit for object and image height
    % and 1 for angles
    
    fieldType = optSystem.FieldType;
    switch (fieldType)
        case 1 %('ObjectHeight')
            [ lensUnitFactor,lensUnitText ] = getLensUnitFactor( optSystem );
            fieldUnitFactor = lensUnitFactor;
            fieldUnitText = lensUnitText;
        case 2 %('Angle')
            fieldUnitFactor = 1;
            fieldUnitText = 'Deg';
    end
end