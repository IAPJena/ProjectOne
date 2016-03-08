function [ parentWindow ] = saveMySystemAs(parentWindow)
    % saveMySystemAs: Display save dialog and save the optical system
    % Member of ParentWindow class
    
    % First compute all fast semi diameters
    % parentWindow.computeFastSemidiameters;
    
    aodHandles = parentWindow.ParentHandles;
    
    [fileName,pathName] = uiputfile('New Optical System.mat','Save As');
    
    if ~strcmpi(num2str(fileName),'0') && ~strcmpi(num2str(pathName),'0')
        aodHandles.IsSaved = 1;
        aodHandles.PathName = pathName;
        aodHandles.FileName = fileName;
        
        parentWindow.ParentHandles = aodHandles;
        currentOpticalSystemArray = getCurrentOpticalSystem(parentWindow,0);
        saveToMATFile( currentOpticalSystemArray,pathName,fileName);
        % Change the title bar to optical system name
        set(aodHandles.FigureHandle,'Name',[aodHandles.PathName,aodHandles.FileName]);
        parentWindow.ParentHandles = aodHandles;
    else
        return;
    end
end

