function [ returnDataStruct] = IdealLens(returnFlag,surfaceParameters,inputDataStruct)
    %IdealLens Ideal lens definition
    % surfaceParameters = values of {'FocalLength'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: About the surface
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.Name
    %       returnDataStruct.ImageFullFileName
    %       returnDataStruct.IsGratingEnabled;
    %       returnDataStruct.Description
    % 2: Surface specific 'UniqueSurfaceParameters' table field names and initial values in Surface Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldTypes
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 3: Surface specific 'Extra Data' table names and initial values in Surface Editor GUI
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
    % Jun 17,2015   Worku, Norman G.     Original Version
    % Jul 10,2015   Worku, Norman G.     input and output are made struct
    %% Default input vaalues
    if nargin == 0
        disp('Error: The function IdealLens() needs atleat the return type.');
        returnDataStruct = struct;
        return;
    elseif nargin == 1 || nargin == 2
        if returnFlag == 1 || returnFlag == 2 || returnFlag == 3 || returnFlag == 4
            inputDataStruct = struct();
        else
            disp('Error: Missing input argument for IdealLens().');
            returnDataStruct = struct();
            return;
        end
    elseif nargin == 3
        % This is fine
    else
        
    end
    switch returnFlag
        case 1 % About the surface
            surfName = {'IdealLens','IDLN'}; % display name
            % look for image description in the current folder and return
            % full address
            [pathstr,name,ext] = fileparts(mfilename('fullpath'));
            imageFullFileName = {[pathstr,'\Surface.jpg']};  % Image file name
            description = {['Ideal Lens: Used to define an ideal paraxial lens.']};  % Text description
            
            returnDataStruct = struct();
            returnDataStruct.Name = surfName;
            returnDataStruct.IsGratingEnabled = 0;
            returnDataStruct.IsExtraDataEnabled = 0;
            returnDataStruct.ImageFullFileName = imageFullFileName;
            returnDataStruct.Description =  description;
        case 2 % Surface specific 'UniqueSurfaceParameters'
            uniqueParametersStructFieldNames = {'FocalLength'};
            uniqueParametersStructFieldDisplayNames = {'Focal Length'};
            uniqueParametersStructFieldTypes = {'numeric'};
            defaultUniqueParametersStruct = struct();
            defaultUniqueParametersStruct.FocalLength = 100;
            
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
        case 4 % Surface sag at given xyGridPoints
            % Just assume plane surface
            X = inputDataStruct.X;
            Y = inputDataStruct.Y;
            mainSag = zeros(size(X,1),size(X,2));
            
            returnDataStruct = struct();
            returnDataStruct.MainSag = mainSag;
            returnDataStruct.AlternativeSag = mainSag;
        case 5 % Paraxial ray trace results
            y = inputDataStruct.InputParaxialRayParameters(1,:);
            u = inputDataStruct.InputParaxialRayParameters(2,:);
            reverseTracing = inputDataStruct.ReverseTracingFlag;
            indexBefore = inputDataStruct.IndexBefore;
            indexAfter = inputDataStruct.IndexAfter;
            focalLength = surfaceParameters.FocalLength;
            % Use the ABCD matrix for paraxial ray tracing
            A = 1; B = 0; C = -1/focalLength; D = 1;
            ABCD = [A,B;C,D];
            invABCD = (1/(A*D-B*C))*[D,-B;-C,A];
            if ~reverseTracing
                %forward trace
                yf = ABCD(1,1)*y + ABCD(1,2)*u ;
                uf = ABCD(2,1)*y + ABCD(2,2)*u ;
            else
                %reverse trace
                yf = invABCD(1,1)*y + invABCD(1,2)*u ;
                uf = invABCD(2,1)*y + invABCD(2,2)*u ;
            end
            
            outputParaxialRayParameters = [yf,uf]';
            
            returnDataStruct = struct();
            returnDataStruct.OutputParaxialRayParameters = outputParaxialRayParameters;
        case 6 % Real Ray trace new direction
            %% Exit ray direction
            % using gaussian thin lens equation 1/f = -n/t+n'/t'
            % first compute the intersection of the lines with local z axis on
            % the object side
            focalLength = surfaceParameters.FocalLength;
            
            rayDirection = inputDataStruct.RayDirection;
            indexBefore = inputDataStruct.IndexBefore;
            indexAfter = inputDataStruct.IndexAfter;
            localRayIntersectionPoint = inputDataStruct.RayIntersectionPoint;
            % COmpute intersection of the ray with plane perpendiculr to
            % the radius pointing from origin to localRayIntersectionPoint
            linePoint = localRayIntersectionPoint;
            lineVector = rayDirection;
            planePoint = [0,0,0]';
            planeNormalVector  = normalize2DMatrix(localRayIntersectionPoint,1);
            [linePlaneIntersection,distance] = computeLinePlaneIntersection...
                (linePoint,lineVector,planePoint,planeNormalVector);
            thicknessBefore = linePlaneIntersection(3,:);

            % compute image side intersection t'=(f)/((fn/t + 1)*n')
            % The Cartesian convention takes everything to the left of the lens as negative, 
            thicknessAfter = (focalLength)./((indexBefore.*focalLength./thicknessBefore + 1).*indexAfter);
            % now compute the new ray direction
            dxAfter = sign(thicknessAfter).*(0 -(localRayIntersectionPoint(1,:)));
            dyAfter = sign(thicknessAfter).*(0 -(localRayIntersectionPoint(2,:)));
            dzAfter = sign(thicknessAfter).*(thicknessAfter - (localRayIntersectionPoint(3,:)));
            exitRayDirection = normalize2DMatrix([dxAfter;dyAfter;dzAfter],1);
            % For thicknessAfter == Inf, the exit ray dire = parallel to z
            % axis
            exitRayDirection(3,abs(thicknessAfter) > 10^10) = 1;
            % For intersection point = 000 the ray direction doesnt change
            exitRayDirection(:,isnan(thicknessBefore)) = rayDirection(:,isnan(thicknessBefore));
            
            TIR = ones(1,size(exitRayDirection,2));
            
            returnDataStruct = struct();
            returnDataStruct.NewLocalRayDirection = exitRayDirection;
            returnDataStruct.TIR = TIR;
        case 7 % F(X,Y,Z)
            Z = inputDataStruct.RayIntersectionPoint(3,:);
            Fxyz = Z;
            returnDataStruct.Fxyz = Fxyz;
        case 8 % F'(X,Y,Z) and surface normal
            X = inputDataStruct.RayIntersectionPoint(1,:);
            Y = inputDataStruct.RayIntersectionPoint(2,:);
            Z = inputDataStruct.RayIntersectionPoint(3,:);
            
            k = inputDataStruct.RayDirection(1,:);
            l = inputDataStruct.RayDirection(2,:);
            m = inputDataStruct.RayDirection(3,:);
            
            % Compute its the derivative F'(X,Y,Z)
            Fx = -X.*0;
            Fy = -Y.*0;
            Fz = ones(1,length(X));
            Fderivative = Fx.*k + Fy.*l + Fz.*m;
            
            surfNormal = [Fx;Fy;Fz];
            normalizedSurfaceNormal = normalize2DMatrix( surfNormal,1);
            returnDataStruct.SurfaceNormal = normalizedSurfaceNormal;
            returnDataStruct.FxyzDerivative = Fderivative;
        case 9 % Exit position
            localRayExitPoint = inputDataStruct.RayIntersectionPoint;
            returnDataStruct.LocalExitRayPosition = localRayExitPoint;
        case 10 % additional path
            intersectionPoint = inputDataStruct.RayIntersectionPoint;
            focalLength = surfaceParameters.FocalLength;
            % Ref: http://www2.ph.ed.ac.uk/~wjh/teaching/mo/slides/lens/lens.pdf
            % additionalPathLength = -(2*pi./wavlenInM).*(intersectionPointXY(1,:).^2+intersectionPointXY(2,:).^2)./(2*focalLength);
            % additionalPathLength = -(intersectionPointXY(1,:).^2+intersectionPointXY(2,:).^2)/(2*focalLength);
            additionalPathLength = -(sqrt(intersectionPoint(1,:).^2+intersectionPoint(2,:).^2 + focalLength^2)-focalLength);
            returnDataStruct.AdditionalPathLength = additionalPathLength;
        otherwise
    end
end

