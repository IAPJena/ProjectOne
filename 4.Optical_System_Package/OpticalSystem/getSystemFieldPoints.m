function [ fieldPointXY, weight ] = getSystemFieldPoints( optSystem,indices,returnInSIUnit )
    %getSystemFieldPoints returns the system field points with corresponding
    %weight for given index. If index is not given or == 0, then all
    %field points in the field point matrix will be returned.
    
    if nargin < 2
        indices = 0;
    end
     if nargin < 3
        returnInSIUnit = 1;
    end
    fieldPointMatrix = optSystem.FieldPointMatrix;
    if returnInSIUnit
        unitFactor = getFieldPointUnitFactor(optSystem);
    else
        unitFactor = 1;
    end
    
    if length(indices) == 1 && indices == 0
        fieldPointXY = (fieldPointMatrix(:,1:2))'*unitFactor;
        weight = (fieldPointMatrix(:,3))';
    else
        fieldPointXY = (fieldPointMatrix(indices,1:2))'*unitFactor;
        weight = (fieldPointMatrix(indices,3))';
    end
end

