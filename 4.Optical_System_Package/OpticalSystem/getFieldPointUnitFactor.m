function [ fieldUnitFactor, fieldUnitText, fieldUnitTextShort] = getFieldPointUnitFactor( optSystem )
    %getFieldPointUnitFactor returns the factor for unit used for field points
    % defintion in the system. Returns the lens unit for object and image height
    % and 1 for angles
    
    fieldType = optSystem.FieldType;
    switch (fieldType)
        case 1 %('ObjectHeight')
            [ lensUnitFactor,lensUnitText,lensUnitTextShort ] = getLensUnitFactor( optSystem );
            fieldUnitFactor = lensUnitFactor;
            fieldUnitText = lensUnitText;
            fieldUnitTextShort = lensUnitTextShort;
        case 2 %('Angle')
            fieldUnitFactor = 1;
            fieldUnitText = 'Degree';
            fieldUnitTextShort = 'deg';
    end
end