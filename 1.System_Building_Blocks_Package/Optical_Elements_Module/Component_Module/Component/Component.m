function newComponent = Component(compType,uniqueParameters,firstTilt,firstDecenter,firstTiltDecenterOrder,compTiltMode,lastThickness)
    % Component Struct:
    %
    %   Defines optical components such as sequence of interface,lens,prism.
    %   This is used in the optical systems which are defined in the
    %   component based manner.
    %
    % Example Calls:
    %
    % newComponent = Component()
    %   Returns a defualt 'SequenceOfSurfaces' component.
    %
    % newComponent = Component(compType)
    %   Returns a default component of given compType
    %
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jun 17,2015   Worku, Norman G.     Support the user defined coating
    %
    if nargin < 1
        % Make single surface component by default
        compType = 1; %'SequenceOfSurfaces';        
    end
    % If the type is given as string instead of number, then find the index
    % corresponding to the type string
    if ~isnumeric(compType)
        supportedComponentTypes = GetSupportedComponentTypes();
        [isFound, foundAt] = ismember(compType,supportedComponentTypes);
        if isFound
            compType = foundAt;
        else
            disp(['Error: The component type specified is not valid so the ',...
                'default SequenceOfSurface is used.']);
            compType = 1;
        end
    end    
    if nargin < 2
        % Connect the component definition function
        componentDefinitionHandle = str2func( GetSupportedComponentTypes(compType));
        returnFlag = 2; % Basic parameters of the component
        [ returnDataStruct] = componentDefinitionHandle(returnFlag);
        uniqueParameters = returnDataStruct.DefaultUniqueParametersStruct;        
    end    
    if nargin < 3
        firstTilt = [0,0,0];
    end 
    if nargin < 4
         firstDecenter = [0,0];
    end     
    if nargin < 5
         firstTiltDecenterOrder  = 1;%{'Dx','Dy','Dz','Tx','Ty','Tz'};
    end     
    if nargin < 6
         compTiltMode = 1;%'DAR';
    end    
    if nargin < 7
         lastThickness = 10;
    end     
    newComponent.Type = compType;
    newComponent.Comment = '';
    newComponent.StopSurfaceIndex = 0;
    
    newComponent.FirstTiltDecenterOrder = firstTiltDecenterOrder;
    newComponent.FirstTilt = firstTilt;
    newComponent.FirstDecenter = firstDecenter;
    newComponent.ComponentTiltMode = compTiltMode;
    
    newComponent.LastThickness = lastThickness;
    
    newComponent.UniqueParameters = uniqueParameters;
    newComponent.ClassName = 'Component';
end


