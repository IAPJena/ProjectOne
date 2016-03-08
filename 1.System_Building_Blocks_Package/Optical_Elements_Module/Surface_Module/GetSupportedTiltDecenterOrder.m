function [  fullNames,displayNames ] = GetSupportedTiltDecenterOrder(index)
    %GETSUPPORTEDTILTDECENTERORDER Summary of this function goes here
    %   Detailed explanation goes here
    % Note: The list can be added if another order is needed and the
    % toolbox works fine with the added ones with out any modification
    if nargin < 1
        index = 0;
    end
    fullNames = {'DxDyDzTxTyTz','TxTyTzDxDyDz'};
    displayNames = {'Dx->Dy->Dz->Tx->Ty->Tz','Tx->Ty->Tz->Dx->Dy->Dz'};
    if index
        fullNames = fullNames{index};
        displayNames = displayNames{index};
    end
end

