function mySurfaceArray = getComponentSurfaceArray(currentComponent,referenceCoordinateTM,previousThickness)
    % getComponentSurfaceArray: Compute surface parameters of the currentComponent
    % parameter index
    % Input:
    %   ( currentComponent )
    % Output:
    %   [ mySurfaceArray ]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    if nargin < 1
        disp('Error: The function getComponentSurfaceArray requires atleaast one input argument,currentComponent. ');
        mySurfaceArray = NaN;
        return;
    end
    if nargin < 2
        referenceCoordinateTM = eye(4);
    end
    if nargin < 3
        previousThickness = 0;
    end
    
    componentDefinitionFileName = GetSupportedComponentTypes(currentComponent.Type);
    % Connect the component definition function
    componentDefinitionHandle = str2func(componentDefinitionFileName);
    returnFlag = 4; % surface array of the component
    firstTilt = currentComponent.FirstTilt;
    firstDecenter = currentComponent.FirstDecenter;
    firstTiltDecenterOrder = currentComponent.FirstTiltDecenterOrder;
    lastThickness = currentComponent.LastThickness;
    componentTiltMode = currentComponent.ComponentTiltMode;
    
    stopSurfaceInComponentIndex = currentComponent.StopSurfaceIndex;
    componentParameters = currentComponent.UniqueParameters;
    
    inputDataStruct = struct();
    inputDataStruct.FirstTilt = firstTilt;
    inputDataStruct.FirstDecenter = firstDecenter;
    inputDataStruct.FirstTiltDecenterOrder = firstTiltDecenterOrder;
    inputDataStruct.LastThickness = lastThickness;
    inputDataStruct.ComponentTiltMode = componentTiltMode;
    inputDataStruct.ReferenceCoordinateTM = referenceCoordinateTM;
    inputDataStruct.PreviousThickness = previousThickness;
    
    [ returnDataStruct ] = componentDefinitionHandle(returnFlag,...
        componentParameters,inputDataStruct);
    surfArray = returnDataStruct.SurfaceArray;
    
    % Make the stop surface
    for kk = 1:length(surfArray)
        surfArray(kk).StopSurfaceIndex = 0;
    end
    if stopSurfaceInComponentIndex
        surfArray(stopSurfaceInComponentIndex).StopSurfaceIndex = 1;
    end
    
    mySurfaceArray = surfArray;
end