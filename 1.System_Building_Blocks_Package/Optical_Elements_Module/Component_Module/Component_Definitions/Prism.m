function [ returnDataStruct] = Prism( ...
        returnFlag,componentParameters,inputDataStruct)
    %Prism : Component defining a general prism
    % componentParameters = values of {'RayPath','Glass','BaseAngle1','BaseAngle2',
    %                          'FirstSurfaceLengthX','FirstSurfaceLengthY'}
    % inputDataStruct : Struct of all additional inputs (not included in the component parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: About the component
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.Name
    %       returnDataStruct.ImageFullFileName
    %       returnDataStruct.Description
    % 2: Component specific 'UniqueParametersStruct' table field names and
    %    initial values in Surface Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 3: Component 'Extra Data' parameters
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueExtraDataFieldNames
    %       returnDataStruct.DefaultUniqueExtraData
    % 4: The surface array of the component
    %   inputDataStruct:
    %       inputDataStruct.FirstTilt
    %       inputDataStruct.FirstDecenter
    %       inputDataStruct.FirstTiltDecenterOrder
    %       inputDataStruct.LastThickness
    %       inputDataStruct.ComponentTiltMode
    %   Output Struct:
    %       returnDataStruct.SurfaceArray
    
    %% Default input values
    if nargin < 1
        disp('Error: The function Prism() needs atleat the return type.');
        returnDataStruct = NaN;
        return;
    end
    
    if returnFlag == 4
        if nargin < 2
            % take the defualt componentparameters
            returnFlag = 2;
            [returnDataStruct] = Prism(returnFlag);
            componentParameters = returnDataStruct.DefaultUniqueParametersStruct;
        end
        if nargin < 3
            inputDataStruct.FirstTilt = [0,0,0];
            inputDataStruct.FirstDecenter = [0,0];
            [isMember,DxDyDzTxTyTzindex] = ismember('DxDyDzTxTyTz',GetSupportedTiltDecenterOrder);
            inputDataStruct.FirstTiltDecenterOrder  = DxDyDzTxTyTzindex; %{'Dx','Dy','Dz','Tx','Ty','Tz'};
            inputDataStruct.LastThickness = 10;
            [isMember,NAXindex] = ismember('NAX',GetSupportedTiltModes);
            inputDataStruct.ComponentTiltMode = NAXindex; %'NAX';
        end
    end
    
    %%
    switch returnFlag(1)
        case 1 % About  component
            returnData1 = {'Prism'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            returnData2 = {[pathstr,'\Prism.jpg']};  % Image file name
            returnData3 = {['Prism: Is a general prism which can be used as',...
                ' Isosceles Prism, Right angled prism, Rooftop prism by',...
                ' changing the angle and ray path parameters.',...
                ' Example: theta_1 = 90, theta_2 = 45 and Ray path = S1-S3-S2 represents a',...
                ' Right angled prism bending light upwards.']};  % Text description
            
            returnDataStruct.Name = returnData1;
            returnDataStruct.ImageFullFileName = returnData2;
            returnDataStruct.Description = returnData3;
        case 2 % 'BasicComponentDataFields' table field names and initial values in COmponent Editor GUI
            defaultCompUniqueStruct = struct();
            defaultCompUniqueStruct.RayPath = 'S1-S2';
            defaultCompUniqueStruct.Glass = Glass('BK7');
            defaultCompUniqueStruct.UpperApexAngle = 45;
            defaultCompUniqueStruct.LowerApexAngle = 90;
            defaultCompUniqueStruct.FirstSurfaceLengthX = 10;
            defaultCompUniqueStruct.FirstSurfaceLengthY = 10;
            
            returnDataStruct.UniqueParametersStructFieldNames = {'RayPath','Glass','UpperApexAngle','LowerApexAngle','FirstSurfaceLengthX','FirstSurfaceLengthY'}; % parameter names
            returnDataStruct.UniqueParametersStructFieldDisplayNames = {'Ray Path','Glass Name','Upper Apex Angle','Lower Apex Angle','First Surface Width in X','First Surface Width in Y'}; % parameter display names
            returnDataStruct.UniqueParametersStructFieldFormats = {{'S1-S2','S1-S3','S1-S2-S3','S1-S3-S2','S1-S2-S3-S1','S1-S3-S2-S1'},'Glass','numeric','numeric','numeric','numeric'}; % parameter types
            returnDataStruct.DefaultUniqueParametersStruct= defaultCompUniqueStruct; % default value
            
        case 3 % 'Extra Data' table field names and initial values in Component Editor GUI
            returnDataStruct.UniqueExtraDataFieldNames = {'Unused'};
            returnDataStruct.DefaultUniqueExtraData = {[0]};
        case 4 % return the surface array of the compont
            firstTilt = inputDataStruct.FirstTilt;
            firstDecenter = inputDataStruct.FirstDecenter;
            firstTiltDecenterOrder = inputDataStruct.FirstTiltDecenterOrder;
            lastThickness = inputDataStruct.LastThickness;
            compTiltMode = inputDataStruct.ComponentTiltMode;
            referenceCoordinateTM = inputDataStruct.ReferenceCoordinateTM;
            previousThickness = inputDataStruct.PreviousThickness;
            
            surfaceArray = computePrismSurfaceArray(componentParameters,...
                firstTilt,firstDecenter,firstTiltDecenterOrder,lastThickness,...
                compTiltMode,referenceCoordinateTM,previousThickness); % surface array
            returnDataStruct.SurfaceArray = surfaceArray; % surface array
    end
end


function surfArray = computePrismSurfaceArray(componentParameters,firstTilt,firstDecenter,firstTiltDecenterOrder,lastThickness,lastTiltMode,referenceCoordinateTM,previousThickness)
    tempSurfaceArray = Surface;
    % Set surface1 properties
    tempSurfaceArray(1) = Surface;
    tempSurfaceArray(1).TiltDecenterOrder =  firstTiltDecenterOrder;
    tempSurfaceArray(1).Tilt = firstTilt;
    tempSurfaceArray(1).Decenter = firstDecenter;
    supportedTiltModes = GetSupportedTiltModes();
    [isMember,NAXindex] = ismember('NAX',supportedTiltModes);
    tempSurfaceArray(1).TiltMode = NAXindex;
    
    type = 'RectangularAperture';
    apertDecenter = [0,0];
    apertRotInDeg = 0;
    drawAbsolute = 1;
    supportedSurfaceApertureOuterShapes = GetSupportedSurfaceApertureOuterShapes();
    [~,outerShape] = ismember('Rectangular',supportedSurfaceApertureOuterShapes);
    additionalEdge = 0;
    uniqueParameters = struct();
    uniqueParameters.DiameterX = componentParameters.FirstSurfaceLengthX;
    uniqueParameters.DiameterY = componentParameters.FirstSurfaceLengthY;
    
    
    % Tilt and decenter
    currentSurface = tempSurfaceArray(1);
    [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
        currentSurface,referenceCoordinateTM,previousThickness);
    % set surface property
    currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
    currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
    tempSurfaceArray(1) = currentSurface;
    
    additionalEdgeType = 1; % relative
    tempSurfaceArray(1).Aperture = Aperture(type,apertDecenter,apertRotInDeg,...
        drawAbsolute,outerShape,additionalEdgeType,additionalEdge,uniqueParameters);

    tempSurfaceArray(1).Glass = componentParameters.Glass;
    
    % Set surface2 and surface3 properties
    % Compute the initial tilt and decenters of surf 2 and 3
    % before applicatio of the tilt and decenter of surf 1
    leftBaseAngleInRad = componentParameters.LowerApexAngle*pi/180;
    apexAngleInRad = componentParameters.UpperApexAngle*pi/180; 
    rightBaseAngleInRad = pi - (apexAngleInRad+leftBaseAngleInRad);

    fullApertureY1 = componentParameters.FirstSurfaceLengthY;
    % Using sin law of triangles
    fullApertureY2 = (sin (leftBaseAngleInRad)/sin (rightBaseAngleInRad))*fullApertureY1;
    fullApertureY3 = (sin (apexAngleInRad)/sin (rightBaseAngleInRad))*fullApertureY1;
    % Using the centers of each side as decenter
    % parameterrs
    % Decenter of S2 with respect to S1
    decenterZ2 = 0.5*fullApertureY2*sin(apexAngleInRad);
    decenterY2 = -0.5*fullApertureY2*cos(apexAngleInRad)+0.5*fullApertureY1;
    decenterX2 = 0;
    % Decenter of S3 with respect to S1
    decenterZ3 = 0.5*fullApertureY3*sin(leftBaseAngleInRad);
    decenterY3 = 0.5*fullApertureY3*cos(leftBaseAngleInRad)-0.5*fullApertureY1;
    decenterX3 = 0;
    
    % Decenter of S1 with respect to S3 or
    % Decenter of S1 with respect to S2
    % Just take negative of the corresponding value
    
    % Know set the surface properties based on the RayPath
    switch componentParameters.RayPath
        case 'S1-S2'
            tempSurfaceArray(2) = Surface;
            newDecenter =[decenterX2,decenterY2,decenterZ2];
            tempSurfaceArray(1).Thickness = newDecenter(3);
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = lastThickness;
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [-apexAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter(1:2);
            tempSurfaceArray(2).TiltMode = lastTiltMode;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(...
                currentSurface,prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(2).Aperture = surf2Aperture;
        case 'S1-S3'
            tempSurfaceArray(2) = Surface;
            newDecenter = [decenterX3,decenterY3,decenterZ3];
            tempSurfaceArray(1).Thickness = newDecenter(3);
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = lastThickness;
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [apexAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter(1:2);
            tempSurfaceArray(2).TiltMode = lastTiltMode;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY3;
            tempSurfaceArray(2).Aperture = surf2Aperture;
            
        case 'S1-S2-S3'
            tempSurfaceArray(2) = Surface;
            tempSurfaceArray(3) = Surface;
            tempSurfaceArray(1).Thickness = decenterZ2;
            
            newDecenter2 =[decenterX2,decenterY2,decenterZ2];
            newDecenter3 = [decenterX3,decenterY3,decenterZ3];
            
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = ...
                - 0.5*fullApertureY1*cos(2*apexAngleInRad-pi/2);
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [-apexAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter2(1:2);
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(2).TiltMode = BENindex;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(2).Aperture = surf2Aperture;
            
            tempSurfaceArray(2).Glass = tempSurfaceArray(1).Glass;
            tempSurfaceArray(2).Glass.Name = 'MIRROR';
            
            % 3rd surface parameters
            tempSurfaceArray(3).Thickness = -lastThickness;
            tempSurfaceArray(3).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(3).Tilt = ...
                -[(pi-(2*apexAngleInRad+leftBaseAngleInRad))*180/pi,0,0];
            tempSurfaceArray(3).Decenter = ...
                [-newDecenter3(1),0.5*fullApertureY1*sin(2*apexAngleInRad-pi/2)];
            tempSurfaceArray(3).TiltMode = lastTiltMode;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(3);
            previousSurface = tempSurfaceArray(2);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(3) = currentSurface;
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            surf3Aperture.UniqueParameters.DiameterY = fullApertureY3;
            tempSurfaceArray(3).Aperture = surf3Aperture;
            
            
        case 'S1-S3-S2'
            tempSurfaceArray(2) = Surface;
            tempSurfaceArray(3) = Surface;
            tempSurfaceArray(1).Thickness = decenterZ3;
            newDecenter2 =[decenterX2,decenterY2,decenterZ2];
            newDecenter3 = [decenterX3,decenterY3,decenterZ3];
            
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = ...
                - 0.5*fullApertureY1*cos(2*leftBaseAngleInRad-pi/2);
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [leftBaseAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter3(1:2);
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(2).TiltMode = BENindex;
            
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(2).Aperture = surf2Aperture;
            
            tempSurfaceArray(2).Glass = tempSurfaceArray(1).Glass;
            tempSurfaceArray(2).Glass.Name = 'MIRROR';
            
            
            % 3rd surface parameters
            tempSurfaceArray(3).Thickness = -lastThickness;
            tempSurfaceArray(3).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(3).Tilt = ...
                -[(pi-(2*leftBaseAngleInRad+apexAngleInRad))*180/pi,0,0];
            tempSurfaceArray(3).Decenter = ...
                [-newDecenter2(1),0.5*fullApertureY1*sin(2*leftBaseAngleInRad-pi/2)];
            tempSurfaceArray(3).TiltMode = lastTiltMode;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(3);
            previousSurface = tempSurfaceArray(2);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(3) = currentSurface;
            
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            surf3Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(3).Aperture = surf3Aperture;
            
            
        case 'S1-S2-S3-S1'
            tempSurfaceArray(2) = Surface;
            tempSurfaceArray(3) = Surface;
            tempSurfaceArray(4) = Surface;
            tempSurfaceArray(1).Thickness = decenterZ2;
            
            newDecenter2 =[decenterX2,decenterY2,decenterZ2];
            newDecenter3 = [decenterX3,decenterY3,decenterZ3];
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = ...
                - 0.5*fullApertureY1*cos(2*apexAngleInRad-pi/2);
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [-apexAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter2(1:2);
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(2).TiltMode = BENindex;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(2).Aperture = surf2Aperture;
            
            tempSurfaceArray(2).Glass = tempSurfaceArray(1).Glass;
            tempSurfaceArray(2).Glass.Name = 'MIRROR';
            
            
            % 3rd surface parameters
            s1s3 = sqrt(decenterZ3^2+decenterY3^2);
            tempSurfaceArray(3).Thickness = ...
                s1s3*cos(2*rightBaseAngleInRad-apexAngleInRad-pi/2);
            tempSurfaceArray(3).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(3).Tilt = ...
                -[(pi-(2*apexAngleInRad+leftBaseAngleInRad))*180/pi,0,0];
            tempSurfaceArray(3).Decenter = ...
                [-newDecenter3(1),0.5*fullApertureY1*sin(2*apexAngleInRad-pi/2)];
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(3).TiltMode = BENindex;
            tempSurfaceArray(3).Glass = tempSurfaceArray(2).Glass;
            tempSurfaceArray(3).Glass.Name = 'MIRROR';
            
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(3);
            previousSurface = tempSurfaceArray(2);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(3) = currentSurface;
            
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            surf3Aperture.UniqueParameters.DiameterY = fullApertureY3;
            tempSurfaceArray(3).Aperture = surf3Aperture;
            % 4th surface parameters
            tempSurfaceArray(4).Thickness = lastThickness;
            tempSurfaceArray(4).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(4).Tilt = ...
                [(rightBaseAngleInRad-(apexAngleInRad+leftBaseAngleInRad))*180/pi,0,0];
            tempSurfaceArray(4).Decenter = ...
                [newDecenter3(1),-s1s3*sin(2*rightBaseAngleInRad-apexAngleInRad-pi/2)];
            tempSurfaceArray(4).TiltMode = lastTiltMode;
            
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(4);
            previousSurface = tempSurfaceArray(3);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(4) = currentSurface;
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            tempSurfaceArray(4).Aperture = surf3Aperture;
            
            
        case 'S1-S3-S2-S1'
            tempSurfaceArray(2) = Surface;
            tempSurfaceArray(3) = Surface;
            tempSurfaceArray(4) = Surface;
            tempSurfaceArray(1).Thickness = decenterZ2;
            
            newDecenter2 =[decenterX2,decenterY2,decenterZ2];
            newDecenter3 = [decenterX3,decenterY3,decenterZ3];
            % 2nd surface parameters
            tempSurfaceArray(2).Thickness = ...
                - 0.5*fullApertureY1*cos(2*leftBaseAngleInRad-pi/2);
            tempSurfaceArray(2).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(2).Tilt = ...
                [leftBaseAngleInRad*180/pi,0,0];
            tempSurfaceArray(2).Decenter = newDecenter3(1:2);
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(2).TiltMode = BENindex;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(2);
            previousSurface = tempSurfaceArray(1);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(2) = currentSurface;
            
            surf2Aperture = tempSurfaceArray(1).Aperture;
            surf2Aperture.UniqueParameters.DiameterY = fullApertureY3;
            tempSurfaceArray(2).Aperture = surf2Aperture;
            tempSurfaceArray(2).Glass = tempSurfaceArray(1).Glass;
            tempSurfaceArray(2).Glass.Name = 'MIRROR';
            
            
            % 3rd surface parameters
            s1s2 = sqrt(decenterZ2^2+decenterY2^2);
            tempSurfaceArray(3).Thickness = ...
                s1s2*cos(2*rightBaseAngleInRad-leftBaseAngleInRad-pi/2);
            tempSurfaceArray(3).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(3).Tilt = ...
                [(pi-(2*leftBaseAngleInRad+apexAngleInRad))*180/pi,0,0];
            tempSurfaceArray(3).Decenter = ...
                [-newDecenter2(1),0.5*fullApertureY1*sin(2*leftBaseAngleInRad-pi/2)];
            [isMember,BENindex] = ismember('BEN',supportedTiltModes);
            tempSurfaceArray(3).TiltMode = BENindex;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(3);
            previousSurface = tempSurfaceArray(2);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(3) = currentSurface;
            
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            surf3Aperture.UniqueParameters.DiameterY = fullApertureY2;
            tempSurfaceArray(3).Aperture = surf3Aperture;
            tempSurfaceArray(3).Glass = tempSurfaceArray(2).Glass;
            tempSurfaceArray(3).Glass.Name = 'MIRROR';
            
            
            % 4th surface parameters
            tempSurfaceArray(4).Thickness = lastThickness;
            tempSurfaceArray(4).TiltDecenterOrder = ...
                tempSurfaceArray(1).TiltDecenterOrder;
            tempSurfaceArray(4).Tilt = ...
                [(rightBaseAngleInRad-(apexAngleInRad+leftBaseAngleInRad))*180/pi,0,0];
            tempSurfaceArray(4).Decenter = ...
                [newDecenter2(1),s1s2*sin(2*rightBaseAngleInRad-leftBaseAngleInRad-pi/2)];
            tempSurfaceArray(4).TiltMode = lastTiltMode;
            
            % Tilt and decenter
            currentSurface = tempSurfaceArray(4);
            previousSurface = tempSurfaceArray(3);
            % Update the surface coordinates and positions
            prevRefCoordinateTM = previousSurface.ReferenceCoordinateTM;
            prevSurfCoordinateTM = previousSurface.SurfaceCoordinateTM;
            prevThickness = previousSurface.Thickness;
            if prevThickness > 10^10 % Replace Inf with INF_OBJ_Z = 0 for object distance
                prevThickness = 0;
            end
            [surfaceCoordinateTM,referenceCoordinateTM] = TiltAndDecenter(currentSurface,...
                prevRefCoordinateTM,prevThickness);
            % set surface property
            currentSurface.SurfaceCoordinateTM = surfaceCoordinateTM;
            currentSurface.ReferenceCoordinateTM = referenceCoordinateTM;
            tempSurfaceArray(4) = currentSurface;
            
            surf3Aperture = tempSurfaceArray(1).Aperture;
            tempSurfaceArray(4).Aperture = surf3Aperture;
            
    end
    surfArray = tempSurfaceArray;
end