function [ returnDataStruct] = ParallelPlaneGrating(returnFlag,gratingParameters,inputDataStruct)
    %ParallelPlaneGrating  Definition of grating ruling formed by
    %intersection of a surface with parallel planes (parallel to XZ plane
    % and periodic in Y direction)
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
        disp(['Error: The function ParallelPlaneGrating() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 2
            disp(['Error: The function ParallelPlaneGrating() needs atleast all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    if nargin < 3
        if returnFlag == 2
            disp(['Error: The function ParallelPlaneGrating() needs atleast all three ',...
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
            % NB: In the reference the grating lines are assumed to be
            % periodic along x axis but to agree with the convention in zemax
            % here i have assumed grating lines are periodic along y axis so 
            % in the formulas given in the paper the varaibles have to be 
            % interchanged x<->y, K<->L and u<->v
            T = gratingParameters.LinesPerMicrometer; % Grating line density in micrometer
            D = (1/T)*10^-6; % Grating period in meter
            M = gratingParameters.LinearCoefficient;
            
            % surfPoints = (x,y,z);
            y = inputDataStruct.SurfacePoints(2,:);
            % surfNormal = (ex,ey,ez)
            ex = inputDataStruct.SurfaceNormal(1,:);
            ey = inputDataStruct.SurfaceNormal(2,:);
            ez = inputDataStruct.SurfaceNormal(3,:);
            % Let the vector (u,v,w) represent unit vector in the direction
            % perpendicular to the ruling --> the grating vector
            v = 1./(sqrt(1+ey.^2./(ex.^2+ez.^2)));
            u = -ex.*ey.*v./(ex.^2+ez.^2);
            w = -ey.*ez.*v./(ex.^2+ez.^2);
            
            % Direction of the grating vector
            localGratingVector = [u;v;w];
            % Magnitude of the grating period
            dlocal = (M.*y + D)./v; 
            gratingFreq = (1./dlocal);
            returnDataStruct.LocalGratingVector = localGratingVector;
            returnDataStruct.LocalGratingLinesPerMicrometer = gratingFreq*10^-6;
            
    end
end

