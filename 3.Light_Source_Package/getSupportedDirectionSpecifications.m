function [  fullNames,dispNames ] = getSupportedDirectionSpecifications(index)
    %getSupportedEdgeSizeSpecifications Summary of this function goes here
    %   Detailed explanation goes here
    fullNames = {'DirectionCosineXY','DirectionCosineYZ','DirectionCosineXZ',...
        'DirectionAngleXY','DirectionAngleYZ','DirectionAngleXZ',...
        'SphereAngleThetaPhi'};
    dispNames = {'Direction Cosine (x : y)','Direction Cosine (y : z)','Direction Cosine (x : z)',...
        'Direction Angle (x : y)','Direction Angle (y : z)','Direction Cosine (x : z)',...
        'Sphere Angle (Theta : Phi)'};
    if nargin == 0
        
    elseif index ~= 0
        fullNames = fullNames{index};
        dispNames = dispNames{index};
    end    
end

