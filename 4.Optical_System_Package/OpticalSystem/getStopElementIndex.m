function [stopElementIndex,stopSurfaceIndex,specified,nElement] = getStopElementIndex(elementArray)
    % getStopElementIndex: gives the stop index surface set by user
    stopElementIndex = 0;
    specified = 0;
    nElement = length(elementArray);
    for kk=1:1:nElement
        curentElement = elementArray{kk};
        if curentElement.StopSurfaceIndex
            stopElementIndex = kk;
            stopSurfaceIndex = curentElement.StopSurfaceIndex;
            specified = 1;
            return;
        end
    end
    
%     if stopIndex == 0
%         % If stop index not given by user then compute it
%         givenStopIndex = 0;
%         [ stopIndex,stopClearAperture] = computeSystemStopIndex(optSystem,givenStopIndex);
%     end
end