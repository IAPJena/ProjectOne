function [ returnDataStruct] = ConcentricCylinderGrating(returnFlag,gratingParameters,inputDataStruct)
    %ConcentricCylinderGrating  Definition of grating ruling formed by
    %intersection of a surface with concentric cylinders ( periodic in r direction)
    %   Ref: G.H.Spencer and M.V.R.K.Murty, GENERAL RAY-TRACING PROCEDURE
    % gratingParameters = values of {'LinesPerMicrometer','LinearCoefficient'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Grating specific 'UniqueGratingParameters' table field names
    % and initial values in Grating Editor GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Determine local grating vectors and grating density for the given 
    %    positions and given surface normals
    %   inputDataStruct:
    %       inputDataStruct.SurfacePoints % 3 X N matrix
    %       inputDataStruct.SurfaceNormal % 3 X N matrix
    %   Output Struct:
    %       returnDataStruct.LocalGratingVector % 3 X N matrix
    %       returnDataStruct.LocalGratingLinesPerMicrometer % 1 X N vector
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 03,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input vaalues
    if nargin < 1
        disp(['Error: The function ConcentricCylinderGrating() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 2
            disp(['Error: The function ConcentricCylinderGrating() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 2
            disp(['Error: The function ConcentricCylinderGrating() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of gratingParameters
            returnData1 = {'LinesPerMicrometer','LinearCoefficient'};
            returnData1_Disp = {'Grating Lines Per Micrometer (At the origin)','Linear Coefficient'};
            returnData2 = {'numeric','numeric'};
            defaultGratingParameter = struct();
            defaultGratingParameter.LinesPerMicrometer = 0;
            defaultGratingParameter.LinearCoefficient = 0;
            returnData3 = defaultGratingParameter;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Determine local grating vectors for the given surface normals
            T = gratingParameters.LinesPerMicrometer; % Grating line density in micrometer
            D = (1/T)*10^-6; % Grating period in meter
            M = gratingParameters.LinearCoefficient;
            
            % surfPoints = (x,y,z);
            x = inputDataStruct.SurfacePoints(1,:);
            y = inputDataStruct.SurfacePoints(2,:);
            % surfNormal = (ex,ey,ez)
            ex = inputDataStruct.SurfaceNormal(1,:);
            ey = inputDataStruct.SurfaceNormal(2,:);
            ez = inputDataStruct.SurfaceNormal(3,:);
            % Let the vector (u,v,w) represent unit vector in the direction
            % perpendicular to the ruling --> the grating vector
            G = sqrt(ez.^2.*(x.^2+y.^2) + (ey.*x - ex.*y).^2);
            u = (ez.^2.*x + ey.*(ey.*x - ex.*y))./G;
            v = (ez.^2.*y + ex.*(ey.*x - ex.*y))./G;
            w = (-ey.*(ex.*x + ey.*y))./G;
            % Direction of the grating vector
            localGratingVector = [u;v;w];
            % Magnitude of the grating period
            r = sqrt(x.^2+y.^2);
            dlocal = r.*(M.*r + D)./(x.*u + y.*v);
            gratingFreq = (1./dlocal);
            
            returnDataStruct.LocalGratingVector = localGratingVector;
            returnDataStruct.LocalGratingLinesPerMicrometer = gratingFreq*10^-6;
    end
end

