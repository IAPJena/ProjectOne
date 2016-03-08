function [ updatedSystem,saved] = getCurrentOpticalSystem (parentWindow,configurationIndex)
    % getCurrentOpticalSystem: Constructs an optical system object from the
    % Main Window
    % Member of ParentWindow class
    
    if nargin < 1
        disp('Erorr: The function getCurrentOpticalSystem needs atleast one input argument.');
        updatedSystem = NaN;
        saved = NaN;
        return;
    end
    if nargin < 2
        configurationIndex = parentWindow.ParentHandles.CurrentConfiguration;
    end
    
    % Check validity of the optical system inputs
    [ isValidSystem,message,updatedOpticalSystem ] = validateOpticalSystem(parentWindow);
    if configurationIndex
        parentWindow.ParentHandles.OpticalSystem(configurationIndex) = updatedOpticalSystem;
    else
        parentWindow.ParentHandles.OpticalSystem = updatedOpticalSystem;
    end
    
    if ~isValidSystem
        msg1 = (['Warning: The optical system was invalid and the following ',...
            'changes have been made to make it Valid. So plaese confirm the changes. ']);
        for mm = 1:length(message)
            msg1 = [msg1  ([num2str(mm) , ' : ',message{mm}])];
        end
        
        msgHandle = msgbox(msg1,'Invalid system: Confirm changes','Warn');
    end
    
    aodHandles = parentWindow.ParentHandles;
    if configurationIndex
        savedOpticalSystem = aodHandles.OpticalSystem(configurationIndex);
    else
        savedOpticalSystem = aodHandles.OpticalSystem;
    end
    
    updatedSystem = savedOpticalSystem;
    nConfig = length(savedOpticalSystem);
    for kk = 1:nConfig
        [ updatedSystem(kk) ] = updateOpticalSystem( savedOpticalSystem(kk) );
    end
    
    if configurationIndex
        aodHandles.OpticalSystem(configurationIndex) = updatedSystem;
    else
        aodHandles.OpticalSystem = updatedSystem;
    end
    
    saved = 1;
    %aodHandles.IsSaved = 1;
    parentWindow.ParentHandles = aodHandles;
end

