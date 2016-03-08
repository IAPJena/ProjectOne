function [ direction ] = getHFSourcePrincipalDirection( harmonicFieldSource )
    %getPrincipalDirection the principal direction of the field
    directionSpecification = harmonicFieldSource.PrincipalDirectionSpecification;
    directionValue = harmonicFieldSource.PrincipalDirectionValue;
    
    switch directionSpecification
        case 1 %'DirectionCosineXY'
            directionCosineZ = sqrt(1-sum((directionValue).^2));
            direction = [directionValue(1);directionValue(2);directionCosineZ];
        case 2 %'DirectionCosineYZ'
            directionCosineX = sqrt(1-sum((directionValue).^2));
            direction = [directionCosineX,directionValue(1);directionValue(2)];
        case 3 %'DirectionCosineXZ'
            directionCosineY = sqrt(1-sum((directionValue).^2));
            direction = [directionValue(1);directionCosineY;directionValue(2)];
        case 4 %'DirectionAngleXY'
            directionValue = cos(directionValue*pi/180);
            directionCosineZ = sqrt(1-sum((directionValue).^2));
            direction = [directionValue(1);directionValue(2);directionCosineZ];
        case 5 %'DirectionAngleYZ'
            directionValue = cos(directionValue*pi/180);
            directionCosineX = sqrt(1-sum((directionValue).^2));
            direction = [directionCosineX,directionValue(1);directionValue(2)];
        case 6 %'DirectionAngleXZ'
            directionValue = cos(directionValue*pi/180);
            directionCosineY = sqrt(1-sum((directionValue).^2));
            direction = [directionValue(1);directionCosineY;directionValue(2)];
        case 7 %'SphereAngleThetaPhi'
            theta = directionValue(1)*pi/180;
            phi = directionValue(2)*pi/180;
            directionCosineZ = cos(theta);
            directionCosineX = sin(theta)*cos(phi);
            directionCosineY = sin(theta)*sin(phi);
            direction = [directionCosineX;directionCosineY;directionCosineZ];
    end
end

