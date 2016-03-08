function [ returnDataStruct] = GaussianWaveProfile(returnFlag,spatialProfileParameters,inputDataStruct)
    % GaussianWaveProfile A user defined function for gaussian spatial profile
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined spatial profiles.
    % spatialProfileParameters = values of {'Type','OrderX','OrderY','CentralWavelength',
    %  'WaistRadiusX','WaistRadiusY','WaistDistanceX','WaistDistanceY','CutOffAmplitudeFactor'}
    % inputDataStruct : Struct of all additional inputs (not included in the surface parameters)
    % required for computing the return. (Vary depending on the returnFlag)
    % returnFlag : An integer indicating what is requested. Depending on it the
    % returnDataStruct will have different fields
    % 1: Return the field names and initial values of spatialProfileParameters
    % which could be used in the Source definition GUI
    %   inputDataStruct:
    %       empty
    %   Output Struct:
    %       returnDataStruct.UniqueParametersStructFieldNames
    %       returnDataStruct.UniqueParametersStructFieldDisplayNames
    %       returnDataStruct.UniqueParametersStructFieldFormats
    %       returnDataStruct.DefaultUniqueParametersStruct
    % 2: Return the spatial profile shape and size(fieldDiameter)
    %   inputDataStruct:
    %        empty
    %   returnDataStruct:
    %       returnDataStruct.BoarderShape
    %       returnDataStruct.BoarderDiameter
    % 3: Return the spatial profile for given meshgrid points xMesh and yMesh
    %   inputDataStruct:
    %       inputDataStruct.xMesh
    %       inputDataStruct.yMesh
    %     %       inputDataStruct.LateralPosition
    %   returnDataStruct:
    %       returnDataStruct.SpatialProfileMatrix,
    
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version
    % Sep 09,2015   Worku, Norman G.     Edited to common user defined format
    
    %% Default input values
    if nargin < 1
        disp(['Error: The function GaussianWaveProfile() needs atleast one argument',...
            'the return type.']);
        returnDataStruct = NaN;
        return;
    end
    if nargin < 2
        if returnFlag == 1
            % OK
        elseif returnFlag == 2
            % get the default parameters
            retF = 1;
            returnData = GaussianWaveProfile(retF);
            spatialProfileParameters = returnData.DefaultUniqueParametersStruct;
        else
            disp(['Error: The function GaussianWaveProfile() needs all three ',...
                'arguments the compute the required return.']);
            returnDataStruct = NaN;
            return;
        end
    end
    
    switch returnFlag(1)
        case 1 % Return the field names and initial values of spatialProfileParameters
            returnData1 = {'Type','OrderX','OrderY','CentralWavelength','WaistRadiusX',...
                'WaistRadiusY','WaistDistanceX','WaistDistanceY','CutOffAmplitudeFactor'};
            returnData2 = {{'FundamentalGaussianMode','HermiteGaussianMode','LaguerreGaussianMode'},...
                'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};
            returnData1_Disp = {'Type','Order in X','Order in Y','Central Wavelength',...
                'Waist Radius in X','Waist Radius in Y','Waist Distance in X','Waist Distance in Y','Cut Off Amplitude Factor'};
            spatialProfileParametersStruct = struct();
            spatialProfileParametersStruct.Type = 1; %'FundamentalGaussianMode';
            spatialProfileParametersStruct.OrderX = [0];
            spatialProfileParametersStruct.OrderY = [0];
            spatialProfileParametersStruct.CentralWavelength = 550*10^-9;
            spatialProfileParametersStruct.WaistRadiusX = [1*10^-3];
            spatialProfileParametersStruct.WaistRadiusY = [1*10^-3];
            spatialProfileParametersStruct.WaistDistanceX = [0];
            spatialProfileParametersStruct.WaistDistanceY = [0];
            spatialProfileParametersStruct.CutOffAmplitudeFactor = [10^-2];
            returnData3 = spatialProfileParametersStruct;
            
            returnDataStruct.UniqueParametersStructFieldNames = returnData1;
            returnDataStruct.UniqueParametersStructFieldDisplayNames = returnData1_Disp;
            returnDataStruct.UniqueParametersStructFieldFormats = returnData2;
            returnDataStruct.DefaultUniqueParametersStruct = returnData3;
        case 2 % Return the spatial profile shape and size(fieldDiameter)
            boarderShape = 1; %'Elliptical';
            w0_x = spatialProfileParameters.WaistRadiusX;
            w0_y = spatialProfileParameters.WaistRadiusY;
            z_x = spatialProfileParameters.WaistDistanceX;
            z_y = spatialProfileParameters.WaistDistanceY;
            cutOffAmplitudeFactor = spatialProfileParameters.CutOffAmplitudeFactor;
            centralLambda = spatialProfileParameters.CentralWavelength;
            
            zR_x = (pi*(w0_x)^2)/(centralLambda);
            wz_x = w0_x*sqrt(1+(z_x/zR_x)^2);
            
            zR_y = (pi*(w0_y)^2)/(centralLambda);
            wz_y = w0_y*sqrt(1+(z_y/zR_y)^2);
            
            % Gaussian inside the area of  limited by cut off amplitude
            % (3*waist radius) is assumed to be relevant
            
            diameterX = 2*sqrt(-log(cutOffAmplitudeFactor))*wz_x;
            diameterY = 2*sqrt(-log(cutOffAmplitudeFactor))*wz_y;
            
            returnDataStruct.BoarderShape = boarderShape;
            returnDataStruct.BoarderDiameter = [diameterX,diameterY]';
        case 3 % Return the spatial profile
            % NB. The formula of ideal gaussian wave from VirtualLab are used
            % here
            type = spatialProfileParameters.Type;
            w0_x = spatialProfileParameters.WaistRadiusX;
            w0_y = spatialProfileParameters.WaistRadiusY;
            z_x = spatialProfileParameters.WaistDistanceX;
            z_y = spatialProfileParameters.WaistDistanceY;
            centralLambda = spatialProfileParameters.CentralWavelength;
            
            orderX = spatialProfileParameters.OrderX;
            orderY = spatialProfileParameters.OrderY;
            %mSquare = spatialProfileParameters.MSquareParameter;
            
            zR_x = (pi*(w0_x)^2)/(centralLambda);
            wz_x = w0_x*sqrt(1+(z_x/zR_x)^2);
            if z_x == 0
                R_x = Inf;
            else
                R_x = z_x*(1+(zR_x/z_x)^2);
            end
            m = orderX;
            
            zR_y = (pi*(w0_y)^2)/(centralLambda);
            wz_y = w0_y*sqrt(1+(z_y/zR_y)^2);
            if z_y == 0
                R_y = Inf;
            else
                R_y = z_y*(1+(zR_y/z_y)^2);
            end
            n = orderY;
            k = 2*pi/(centralLambda);
            
            x = inputDataStruct.xMesh;
            y = inputDataStruct.yMesh;
            %             % lateral offset
            %             cx = inputDataStruct.LateralPosition(1);
            %             cy = inputDataStruct.LateralPosition(2);
            % Compute the Gaussian profile
            Uxy_Fundamental = ...
                (exp(-((x).^2)/(wz_x^2)).*exp(1i*(-(k*z_x/2) - k*(((x).^2)/(2*R_x)) + 0.5*atan(z_x/zR_x)))).*...
                exp(-((y).^2)/(wz_y^2)).*exp(1i*(-(k*z_y/2) - k*(((y).^2)/(2*R_y)) + 0.5*atan(z_y/zR_y)));
            %             Uxy_Fundamental = ...
            %                 (exp(-((x-cx).^2)/(wz_x^2)).*exp(1i*(-(k*z_x/2) - k*(((x-cx).^2)/(2*R_x)) + 0.5*atan(z_x/zR_x)))).*...
            %                 exp(-((y-cy).^2)/(wz_y^2)).*exp(1i*(-(k*z_y/2) - k*(((y-cy).^2)/(2*R_y)) + 0.5*atan(z_y/zR_y)));
            switch (type)
                case 1 %lower('FundamentalGaussianMode')
                    Uxy = Uxy_Fundamental;
                case 2 %lower('HermiteGaussianMode')
                    % NB: For astigmatic case the function should be rechecked.
                    Uxy = Uxy_Fundamental.*exp(1i*(m*atan(z_x/zR_x)+n*atan(z_y/zR_y))).*...
                        Hermite(m,(sqrt(2)*(x-cx))./(wz_x)).*Hermite(n,(sqrt(2)*(y-cy))./(wz_y));
                case 3 %lower('LaguerreGaussianMode')
                    p = m; % radial order
                    l = n; % angle orger
                    % NB: For astigmatic case the function should be rechecked.
                    %                     disp('Currently LaguerreGaussianMode is not supported.');
                    %                     Uxy = NaN;
                    %                     return;
                    %                     Uxy = U_xy_Fundamental.*exp(1i*(p*atan((x-cx)./(y-cy))+(2*p+l)*atan(z_x/zR_x))).*...
                    %                         Laguerre(p,l,(2*((x-cx).^2+(y-cy).^2)/wz_x.^2));
                    Uxy = U_xy_Fundamental.*exp(1i*(p*atan((x)./(y))+(2*p+l)*atan(z_x/zR_x))).*...
                        Laguerre(p,l,(2*((x).^2+(y).^2)/wz_x.^2));
            end
            returnDataStruct.SpatialProfileMatrix = Uxy;  % (sizeX X sizeY) Matrix of normalized amplitude
    end
end