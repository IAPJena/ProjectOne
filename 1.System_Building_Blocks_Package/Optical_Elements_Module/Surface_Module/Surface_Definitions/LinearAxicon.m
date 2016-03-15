function [ returnDataStruct] = LinearAxicon(returnFlag,surfaceParameters,inputDataStruct)
    %LinearAxicon LinearAxicon surface definition
    % surfaceParameters = values of {'ApexAngle'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: About the surface
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.Name
    %       returnDataStruct.IsGratingEnabled;
    %       returnDataStruct.ImageFullFileName
    %       returnDataStruct.Description
    % 2: Surface specific 'UniqueSurfaceParameters' table field names and initial values in Surface Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldTypes
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 3: Surface specific 'Extra Data' table name and initial values in Surface Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueExtraDataName
    %       returnDataStruct.DefaultUniqueExtraData
    % 4: Return the surface sag at given xyGridPoints computed from rayPosition % Used for plotting the surface
    %   inputDataStruct:
    %       inputDataStruct.X
    %       inputDataStruct.Y
    %   Output Struct:
    %       returnDataStruct.MainSag
    %       returnDataStruct.AlternativeSag
    % 5: Paraxial ray trace results (Ray height and angle)
    %   inputDataStruct:
    %       inputDataStruct.InputParaxialRayParameters
    %       inputDataStruct.IndexBefore
    %       inputDataStruct.IndexAfter
    %       inputDataStruct.Wavelength
    %       inputDataStruct.ReflectionFlag
    %       inputDataStruct.ReverseTracingFlag
    %   Output Struct:
    %       returnDataStruct.OutputParaxialRayParameters
    % 6: New ray direction for real ray tracing
    %   inputDataStruct:
    %         inputDataStruct.RayDirection
    %         inputDataStruct.LocalSurfaceNormal
    %         inputDataStruct.IndexBefore
    %         inputDataStruct.IndexAfter
    %         inputDataStruct.WavelengthInUm
    %         inputDataStruct.DiffractionOrder
    %         inputDataStruct.GratingVectorDirection
    %         inputDataStruct.GratingLinesPerMicrometer
    %   Output Struct:
    %         returnDataStruct.NewLocalRayDirection
    %         returnDataStruct.TIR
    % 7: Return the function values of F(X,Y,Z) at the given ray intersection
    %    points
    %   inputDataStruct:
    %         inputDataStruct.RayIntersectionPoint
    %   Output Struct:
    %         returnDataStruct.Fxyz
    % 8: Return F'(X,Y,Z),the derivatives function values of F,  at the given
    %    ray intersection points and the surface normals
    %   inputDataStruct:
    %         inputDataStruct.RayIntersectionPoint
    %         inputDataStruct.RayDirection
    %   Output Struct:
    %         returnDataStruct.FxyzDerivative
    %         returnDataStruct.SurfaceNormal
    % 9: Return the ray Exit position (This allows the ray input and exit
    %    positions to be decoupled)
    %   inputDataStruct:
    %         inputDataStruct.RayIntersectionPoint
    %   Output Struct:
    %         returnDataStruct.LocalExitRayPosition
    % 10: Return any additional path related to the surface that is not
    %     given by the surface sag.
    %   inputDataStruct:
    %         inputDataStruct.RayIntersectionPoint
    %   Output Struct:
    %         returnDataStruct.AdditionalPathLength
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Mar 11,2016   Worku, Norman G.     Original Version
    
    %% Default input vaalues
    if nargin == 0
        disp('Error: The function LinearAxicon() needs atleat the return type.');
        returnDataStruct = struct;
        return;
    elseif nargin == 1 || nargin == 2
        if returnFlag == 1 || returnFlag == 2 || returnFlag == 3 || returnFlag == 4
            inputDataStruct = struct();
        else
            disp('Error: Missing input argument for LinearAxicon().');
            returnDataStruct = struct();
            return;
        end
    elseif nargin == 3
        % This is fine
    else
        
    end
    switch returnFlag
        case 1 % About the surface
            surfName = {'LinearAxicon','LIAX'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            imageFullFileName = {[pathstr,'\Surface.jpg']};  % Image file name
            description = {['LinearAxicon: Used to define linear axicon surfaces.']};  % Text description
            
            returnDataStruct = struct();
            returnDataStruct.Name = surfName;
            returnDataStruct.IsGratingEnabled = 1;
            returnDataStruct.IsExtraDataEnabled = 0;
            returnDataStruct.ImageFullFileName = imageFullFileName;
            returnDataStruct.Description =  description;
        case 2 % Surface specific 'UniqueSurfaceParameters'
            uniqueParametersStructFieldNames = {'ApexAngle'};
            uniqueParametersStructFieldDisplayNames = {'Apex Angle'};
            uniqueParametersStructFieldTypes = {'numeric'};
            defaultUniqueParametersStruct = struct();
            defaultUniqueParametersStruct.ApexAngle = -90;

            returnDataStruct = struct();
            returnDataStruct.UniqueParametersStructFieldNames = uniqueParametersStructFieldNames;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = uniqueParametersStructFieldDisplayNames;
            returnDataStruct.UniqueParametersStructFieldTypes = uniqueParametersStructFieldTypes;
            returnDataStruct.DefaultUniqueParametersStruct = defaultUniqueParametersStruct;
        case 3 % Surface specific 'Extra Data' table
            uniqueExtraDataName = {'Unused'};
            defaultUniqueExtraData = [0];
            
            returnDataStruct = struct();
            returnDataStruct.UniqueExtraDataName = uniqueExtraDataName;
            returnDataStruct.DefaultUniqueExtraData = defaultUniqueExtraData;
        case 4 % Surface sag at given xyGridPoints Z = F(X,Y)
            X = inputDataStruct.X;
            Y = inputDataStruct.Y;
            apexAngleInDeg = surfaceParameters.ApexAngle;
            mainSag = computeLinearAxiconSurfaceSag(apexAngleInDeg,X,Y);
            
            returnDataStruct = struct();
            returnDataStruct.MainSag = mainSag;
            returnDataStruct.AlternativeSag = mainSag;
        case 5 % Paraxial ray trace results
            y = inputDataStruct.InputParaxialRayParameters(1,:);
            u = inputDataStruct.InputParaxialRayParameters(2,:);
            reverseTracing = inputDataStruct.ReverseTracingFlag;
            reflection = inputDataStruct.ReflectionFlag;
            indexBefore = inputDataStruct.IndexBefore;
            indexAfter = inputDataStruct.IndexAfter;

            % the height doesnot change
            yf = y;
            % for angle compute based on the direction of propagation
            if ~reverseTracing
                %forward trace
                c = 10^-16;
                n = indexBefore;
                nPrime = indexAfter;
            else
                %reverse trace
                c = -10^-16;
                n = indexAfter;
                nPrime = indexBefore;
            end
            if reflection
                n = -n;
            end
            
            paI = u+yf*c; %The yui method generates the paraxial angles of incidence
            % during the trace and is probably the most common method used in computer programs.
            uf = u+((n/nPrime)-1)*paI;
            outputParaxialRayParameters = [yf,uf]';
            
            returnDataStruct = struct();
            returnDataStruct.OutputParaxialRayParameters = outputParaxialRayParameters;
            
        case 6 % Real Ray trace new direction
            rayDirection = inputDataStruct.RayDirection;
            localSurfaceNormal = inputDataStruct.LocalSurfaceNormal;
            indexBefore = inputDataStruct.IndexBefore;
            indexAfter = inputDataStruct.IndexAfter;
            wavelengthInUm = inputDataStruct.WavelengthInUm;
            diffractionOrder = inputDataStruct.DiffractionOrder;
            gratingVectorDirection = inputDataStruct.GratingVectorDirection;
            gratingLinesPerMicrometer = inputDataStruct.GratingLinesPerMicrometer;
            
            % Use the general snells law
            [newLocalRayDirection,TIR] = computeGeneralRefractionReflection ...
                (rayDirection,localSurfaceNormal,indexBefore,indexAfter,...
                wavelengthInUm,diffractionOrder,gratingVectorDirection,gratingLinesPerMicrometer);
            
            returnDataStruct = struct();
            returnDataStruct.NewLocalRayDirection = newLocalRayDirection;
            returnDataStruct.TIR = TIR;
        case 7 % F(X,Y,Z)
            apexAngleInDeg = surfaceParameters.ApexAngle;
            
            X = inputDataStruct.RayIntersectionPoint(1,:);
            Y = inputDataStruct.RayIntersectionPoint(2,:);
            Z = inputDataStruct.RayIntersectionPoint(3,:);
            
            surfaceSag = computeLinearAxiconSurfaceSag(apexAngleInDeg,X,Y);
            Fxyz = Z - surfaceSag;
            returnDataStruct.Fxyz = Fxyz;
        case 8 % F'(X,Y,Z) and surface normal
            apexAngleInDeg = surfaceParameters.ApexAngle;
            
            X = inputDataStruct.RayIntersectionPoint(1,:);
            Y = inputDataStruct.RayIntersectionPoint(2,:);
            Z = inputDataStruct.RayIntersectionPoint(3,:);
            
            k = inputDataStruct.RayDirection(1,:);
            l = inputDataStruct.RayDirection(2,:);
            m = inputDataStruct.RayDirection(3,:);
            
            % Compute its the derivative F'(X,Y,Z)
            [Fx,Fy,Fz] = computeLinearAxiconPartialDerivates(apexAngleInDeg,X,Y);
            Fderivative = Fx.*k + Fy.*l + Fz.*m;
            
            surfNormal = [Fx;Fy;Fz];
            normalizedSurfaceNormal = normalize2DMatrix( surfNormal,1);
            returnDataStruct.SurfaceNormal = normalizedSurfaceNormal;
            returnDataStruct.FxyzDerivative = Fderivative;
        case 9 % Exit position
            localRayExitPoint = inputDataStruct.RayIntersectionPoint;
            returnDataStruct.LocalExitRayPosition = localRayExitPoint;
        case 10 % additiona�l pathlength
            intersectionPoint = inputDataStruct.RayIntersectionPoint;
            % For now just return 0. but shall be corrected
            additionalPathLength = 0*intersectionPoint(1,:);
            returnDataStruct.AdditionalPathLength = additionalPathLength;
        otherwise
            
    end
end

function surfaceSag = computeLinearAxiconSurfaceSag...
        (apexAngleInDeg,X,Y)
    
    apexAngleInRad = apexAngleInDeg*pi/180;
    r = sqrt(X.^2+Y.^2);
    z = r/(tan(apexAngleInRad/2));
    surfaceSag = z;
end
function [Fx,Fy,Fz] = computeLinearAxiconPartialDerivates(apexAngleInDeg,X,Y)
    r = sqrt(X.^2+Y.^2);
    apexAngleInRad = apexAngleInDeg*pi/180;
    Fx = -X./(tan(apexAngleInRad/2)*r);
    Fy = -Y./(tan(apexAngleInRad/2)*r);
    Fx(isnan(Fx)) = 0;
    Fy(isnan(Fy)) = 0;    
    Fz = ones(size(Fx));
end


