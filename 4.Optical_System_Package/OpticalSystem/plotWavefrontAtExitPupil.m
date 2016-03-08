function [ XMulti,YMulti,OPDAtExitPupilMulti,PupilWeightMatrixMulti,RMSMulti,WPVMulti,ZERMulti,SrehlRatioMuti] =...
        plotWavefrontAtExitPupil( optSystem,wavelengthIndices,fieldIndices ,rayGridSize,...
        zerCoeff,plotPanelHandle,textHandle)
    % PLOTWAVEFRONTATEXITPUPIL: computes and plots the OPD surface in the exit pupil of
    % the system.
    %   if plotPanelHandle & textHandle are not given then plot is not needed
    %   and only calculated datas shall be returned
    
    % Default inputs
    dispPlot = 1;
    dispText = 1;
    if nargin < 4
        disp(['Error: The plotWavefrontAtExitPupil function needs atleast',...
            'optSystem,rayGridSize,wavLen and fieldPointXY as arguments.']);
        XMulti = [];
        YMulti = [];
        OPDAtExitPupilMulti = [];
        PupilWeightMatrixMulti = [];
        RMSMulti = [];
        WPVMulti = [];
        ZERMulti = [];
        return
    elseif nargin == 4
        zerCoeff = 16;
        dispPlot = 0;
        dispText = 0;
        
    elseif nargin == 5
        dispPlot = 0;
        dispText = 0;
    elseif nargin == 6
        dispText = 0;
    elseif nargin == 7
    end
    
    nSurf = getNumberOfSurfaces(optSystem);
    PupSamplingType = 'Cartesian';
    numberOfRays = rayGridSize^2;
    
    wavelengthUnitFactor = getWavelengthUnitFactor(optSystem);
    lensUnitFactor = getLensUnitFactor(optSystem);
    wavLenInM = getSystemWavelengths(optSystem,wavelengthIndices);
    wavLen = wavLenInM/wavelengthUnitFactor;
    switch (optSystem.FieldType)
        case 1 %('ObjectHeight')
            fieldPointXYInM = getSystemFieldPoints(optSystem,fieldIndices);
            fieldPointXY = fieldPointXYInM/lensUnitFactor;
        case 2 %('Angle')
            fieldPointXY = getSystemFieldPoints(optSystem,fieldIndices);
    end
    % Now perform scalar ray trace
    rayTraceOptionStruct = RayTraceOptionStruct;
    rayTraceOptionStruct.ComputeOpticalPathLength = 1;
    [polarizedRayTracerResult,pupilMeshGrid,outsidePupilIndices] = multipleRayTracer(optSystem,wavelengthIndices,...
        fieldIndices,rayGridSize,rayGridSize,PupSamplingType,rayTraceOptionStruct);%,pupilMeshGrid,outsidePupilIndices
    
    X = pupilMeshGrid(:,:,1);
    Y = pupilMeshGrid(:,:,2);
    % Find cheif ray index
    cheifRayIndex = find((X(~outsidePupilIndices)).^2+(Y(~outsidePupilIndices)).^2==0);
    % take first value in case of multiple ocuurances
    cheifRayIndex = cheifRayIndex(1);
    
    nSurf = size(polarizedRayTracerResult,1);
    % Effective number of traced rays
    nRay = polarizedRayTracerResult(end).FixedParameters.TotalNumberOfPupilPoints;
    
    % nGrid = max(pupilGridIndices(1,:));
    nGrid = size(pupilMeshGrid,2);
    
    %nGrid = rayGridSize;
    nField = size(polarizedRayTracerResult,3);
    nWav = size(polarizedRayTracerResult,4);
    
    if dispPlot
        % Clear all childs of plotPanelHandle
        %         set(get(plotPanelHandle,'Children'),'Visible','off');
        delete(get(plotPanelHandle,'Children'));
    end
    textResult = char('','<<<<<<<<<< Wavefront RMS and PV Values >>>>>>>>>>>','');
    textZernike = char('<<<<<<<<<< Zernike Coefficients  >>>>>>>>>>>');
    % Generate a new panel for each field and wavelength combination to display
    % the wavefront @ exit pupil in the subplots.
    
    for wavIndex = 1:nWav
        for fieldIndex = 1:nField
            if dispPlot
                subplotPanel = uipanel('Parent',plotPanelHandle,...
                    'Units','Normalized',...
                    'Position',[(wavIndex-1)/nWav,(nField-fieldIndex)/nField,...
                    min([1/nWav,1/nField]),min([1/nWav,1/nField])],...
                    'Title',['Field Point XY : [',num2str(fieldPointXY(1,fieldIndex)),',',...
                    num2str(fieldPointXY(2,fieldIndex)),']',...
                    ' & Wavelength : ',num2str(wavLen(wavIndex))]);
                subplotAxes = axes('Parent',subplotPanel,...
                    'Units','Normalized',...
                    'Position',[0.25,0.40, 0.50, 0.50]);
                sectionPlotAxes = axes('Parent',subplotPanel,...
                    'Units','Normalized',...
                    'Position',[0.25,0.08, 0.50, 0.20]);
            end
            
            objectToImageOPLSum = [polarizedRayTracerResult(nSurf).TotalOpticalPathLength];
            %% Trace all rays back to the exit pupil sphere
            initialPosition = squeeze(getAllSurfaceRayIntersectionPoint(polarizedRayTracerResult(nSurf),...
                0,fieldIndex,wavIndex));
            initialDirection = -1*squeeze(getAllSurfaceIncidentRayDirection(polarizedRayTracerResult(nSurf),...
                0,fieldIndex,wavIndex));
            
            % Define exit pupil sphere
            exitPupilCenter = initialPosition(:,cheifRayIndex);
            exitPupilRadius = - getExitPupilLocation(optSystem);
            % Line(Ray):  initialPosition + t*initialDirection  = P
            % Sphere: (P-exitPupilCenter)^2 - exitPupilRadius^2 = 0
            % To get intersection point
            % at^2+bt+c=0 where
            % a = 1,
            % b = 2*initialDirection(initialPosition-exitPupilCenter),
            % c = |initialPosition-exitPupilCenter|^2-exitPupilRadius^2
            
            a = 1;
            b = 2*compute3dDot(initialDirection,(initialPosition-repmat(exitPupilCenter,[1,nRay])));
            c = sum((initialPosition-repmat(exitPupilCenter,[1,nRay])).^2,1)-exitPupilRadius^2;
            
            discr = b.^2 - 4*a.*c;
            if sum(discr<0,2)
                disp('Error Some rays fail to intersect the exit pupil.');
            end
            % Parameters
            root1 = (-b+sqrt(discr))./(2*a);
            root2 = (-b-sqrt(discr))./(2*a);
            % the intersection point shall be compute using the line eqation.
            intersectionPoint1 = initialPosition + repmat(root1,[3,1]).*initialDirection;
            intersectionPoint2 = initialPosition + repmat(root2,[3,1]).*initialDirection;
            % The real intersection point depends on the exit pupil location,
            % if it is to the left of image plane then the intersection point
            % with smaller z value is taken. Otherwise the other is taken.
            if exitPupilRadius > 0 % exit pupil to the left
                if intersectionPoint1(3,1) < intersectionPoint2(3,1)
                    rayExitPupilIntersection = intersectionPoint1;
                else
                    rayExitPupilIntersection = intersectionPoint2;
                end
            else
                if intersectionPoint1(3,1) < intersectionPoint2(3,1)
                    rayExitPupilIntersection = intersectionPoint2;
                else
                    rayExitPupilIntersection = intersectionPoint1;
                end
            end
            %                         %% If plane exit pupil is assumed
            %                         % Determine parameterr for Z of exit pupil from the global axis.
            %                         % NB. Exit pupil location is measured from the image plane
            %                         ExitPupilZ = getTotalTrack(optSystem) + getExitPupilLocation(optSystem);
            %                         % Line(Ray):  (x0,y0,z0) + t*(dx,dy,dz)  = (X,Y,Z)
            %                         t = (ExitPupilZ - initialPosition(3,:))./initialDirection(3,:);
            %                         intersectionPoint1 = initialPosition + repmat(t,[3,1]).*initialDirection;
            %                         rayExitPupilIntersection = intersectionPoint1;
            
            additionalOpticalPath = sqrt(sum((initialPosition-rayExitPupilIntersection).^2,1));
            
            %additionalOpticalPath = 0*additionalOpticalPath;
            %         if polarized
            %             totalOPLAtExitPupil = objectToImageOPLSum;
            %         else
            %             totalOPLAtExitPupil = objectToImageOPLSum - additionalOpticalPath;
            %         end
            totalOPLAtExitPupil = objectToImageOPLSum - additionalOpticalPath;
            totalOPLAtExitPupilCheifRay = totalOPLAtExitPupil(cheifRayIndex);
            opd = -totalOPLAtExitPupil+totalOPLAtExitPupilCheifRay;
            
            %         opd = totalOPLAtExitPupil;
            
            % Determine exit pupil coordinates from entrance coordinates and
            % the ratio of their diameters
            entPupilDiameter = getEntrancePupilDiameter(optSystem);
            exitPupilDiameter = getExitPupilDiameter(optSystem);
            exitPupilCoordinates = pupilMeshGrid * (exitPupilDiameter/entPupilDiameter);
            
            % Plot the surface at exit pupil
            X = pupilMeshGrid(:,:,1);
            Y = pupilMeshGrid(:,:,2);
            
            % Initialize all values to zero
            OPDAtExitPupil(1:nGrid,1:nGrid) = zeros;
            %         AmplitudeTransmission(1:nGrid,1:nGrid) = zeros;
            
            % Change the pupilGridIndices (2XN matrix with 2D indices of the grid
            % corresponding to each ray) to linear index so that the values opd can be
            % linearly assigned.
            OPDAtExitPupil(~outsidePupilIndices) = opd;
            %         if polarized
            %             AmplitudeTransmission(~outsidePupilIndices) = ampTransCoeff;
            %         else
            %             AmplitudeTransmission(1:nGrid,1:nGrid) = ones;
            %         end
            %
            apodType = optSystem.ApodizationType;
            apodParam = optSystem.ApodizationParameters;
            gridSize = size(OPDAtExitPupil,1);
            [ ~,~,pupilApodization ] =...
                plotPupilApodization( optSystem,apodType,apodParam,gridSize);
            PupilWeightMatrix = pupilApodization;
            
            %         normalizedAmpTrans = AmplitudeTransmission/max(max(AmplitudeTransmission));
            
            useApodization = 0;
            if useApodization
                OPDAtExitPupil = OPDAtExitPupil.*PupilWeightMatrix;
            end
            
            %         usePolTransmission = 0;
            %         if usePolTransmission && polarized
            %             OPDAtExitPupil = OPDAtExitPupil.*normalizedAmpTrans;
            %         end
            
            WPV = max(max(OPDAtExitPupil))-min(min(OPDAtExitPupil));
            RMS = computeWavefrontRMS(OPDAtExitPupil,PupilWeightMatrix);
            
            % Change them  from lens unit to wavelength scale
            RMS = (RMS * getLensUnitFactor(optSystem)) ./...
                (wavLen * getWavelengthUnitFactor(optSystem));
            WPV = (WPV * getLensUnitFactor(optSystem)) ./...
                (wavLen * getWavelengthUnitFactor(optSystem));
            SrehlRatio = (exp(1))^(-4*pi*(RMS)^2);
            
            % Compute Zernike Coefficients
            xp = X(find(pupilApodization));
            yp = Y(find(pupilApodization));
            nzern = zerCoeff;
            a = 1;
            phasin = (OPDAtExitPupil(find(pupilApodization)) * getLensUnitFactor(optSystem)) ./...
                (wavLen * getWavelengthUnitFactor(optSystem));
            
            % Add spherical phase to the wavefront error to get the actual
            % wavefront surface.
            R = sqrt(X.^2+Y.^2);
            rp = R(find(pupilApodization));
            % phasin =  phasin + wrapTo2Pi((2*pi./wavelengthInMeter).*sqrt(exitPupilRadius^2-rp.^2));
            %phasin =  phasin + wrapTo2Pi((pi./(wavelengthInMeter*exitPupilRadius)).*(rp.^2));
            % Remove the mean value
            % phasin = phasin - mean(phasin);
            % phasin = phasin + (2pi./(wavelengthInMeter*exitPupilRadius)).*(rp.^2);
            
            [cout,phasout,wrms,wpv] = zernike_fit_irreg(xp,yp,nzern,a,phasin);
            ZER = cout;
            zernikeComments = {...
                '  %  Offset:      1',...
                '  %  Tilt y:      ypa.^2 ',...
                '  %  Tilt x:      xpa.^2 ',...
                '  %  Defokus:     2.*(xpa.^2 + ypa.^2) - 1',...
                '  %  Astigmatism: ypa.^2 - xpa.^2',...
                '  %  Astigmatism: 2.* xpa.* ypa',...
                '  %  Coma:        ypa .* (3.*(xpa.^2 + ypa.^2) - 2)',...
                '  %  Coma:        xpa .* (3.*(xpa.^2 + ypa.^2) - 2 )',...
                '  %  Spherical:   6.*(xpa.^2 + ypa.^2).^2 - 6.*(xpa.^2 + ypa.^2) + 1 ',...
                '  %  Dreiblatt:   ypa .* (ypa.^2 - 3.*xpa.^2)',...
                '  %  Dreiblatt:   xpa .* (3.*ypa.^2 - xpa.^2)',...
                '  %  Astigmatism 5. Ord:  (ypa.^2 - xpa.^2).*(4.*(xpa.^2 + ypa.^2) - 3)',...
                '  %  Astigmatism 5. Ord:  2.*xpa.*ypa.*(4.*(xpa.^2 + ypa.^2) - 3)',...
                '  %  Coma 5. Ord:   ypa.*(10.*(xpa.^2 + ypa.^2).^2 -12.*(xpa.^2 + ypa.^2) + 3)',...
                '  %  Coma 5. Ord:   xpa.*(10.*(xpa.^2 + ypa.^2).^2 -12.*(xpa.^2 + ypa.^2) + 3)',...
                '  %  Spherical 5. Ord:    20.*(xpa.^2 + ypa.^2).^3 - 30.*(xpa.^2 + ypa.^2).^2 + 12.*(xpa.^2 + ypa.^2) - 1'};
            
            textZernike = char(textZernike,'',...
                ['Field Point XY : [',num2str(fieldPointXY(1,fieldIndex)),',',...
                num2str(fieldPointXY(2,fieldIndex)),']'],...
                [' Wavelength : ',num2str(wavLen(wavIndex))]);
            for j = 1:length(ZER)
                if ZER(j)<0 ; stro = '%8.5f'; so = ' ';  else  stro = '%9.5f';so = '  ';end
                if j < 10 ; sd = '  = ';  else  sd = ' = ';end
                if j <= 16
                    comment = char(zernikeComments{j});
                else
                    comment = '';
                end
                textZernike = char(textZernike,...
                    ['Z ',num2str(j,'%3.0f'),sd,...
                    so,num2str(ZER(j),stro),comment]);
            end
            
            textResult = char(textResult,...
                [['Field Point XY : [',num2str(fieldPointXY(1,fieldIndex)),',',...
                num2str(fieldPointXY(2,fieldIndex)),']',...
                ' Wavelength : ',num2str(wavLen(wavIndex))]],...
                ['Wavefront RMS (Waves) : ',num2str(RMS)],...
                ['Wavefront WPV (Waves) : ',num2str(WPV)],'');
            
            % plot if required
            if dispPlot
                % Modify OPD by making the boundary layer of 0 around for better
                % visibility in the edge
                modifiedOPD = OPDAtExitPupil;
                modifiedOPD(1,:) = 0; modifiedOPD(end,:) = 0;
                modifiedOPD(:,1) = 0; modifiedOPD(:,end) = 0;
                % Scale to wavelength
                OPDAtExitPupil = (modifiedOPD * getLensUnitFactor(optSystem)) ./...
                    (wavLen * getWavelengthUnitFactor(optSystem));
                
                normX = X./(0.5*exitPupilDiameter);
                normY = Y./(0.5*exitPupilDiameter);
                EnhancedPColor({subplotAxes,normX,normY,OPDAtExitPupil},sectionPlotAxes);
                %                 surf(normX,normY,OPDAtExitPupil,'Parent',subplotAxes,'facecolor','interp',...
                %                     'edgecolor','none',...
                %                     'facelighting','phong');
                title(subplotAxes,'OPD at Exit Pupil')
                zlabel(subplotAxes,'OPD (in Waves)') % x-axis label
                xlabel(subplotAxes,'X - Pupil(Rel. Units)')
                ylabel(subplotAxes,'Y - Pupil(Rel. Units)')
                axis(subplotAxes,'tight')
            end
            XMulti(:,:,fieldIndex,wavIndex) = X;
            YMulti(:,:,fieldIndex,wavIndex) = Y;
            OPDAtExitPupilMulti(:,:,fieldIndex,wavIndex) = OPDAtExitPupil;
            PupilWeightMatrixMulti(:,:,fieldIndex,wavIndex) = PupilWeightMatrix;
            RMSMulti(:,fieldIndex,wavIndex) = RMS;
            WPVMulti(:,fieldIndex,wavIndex) = WPV;
            ZERMulti(:,fieldIndex,wavIndex) = ZER;
            SrehlRatioMuti(fieldIndex,wavIndex) = SrehlRatio;
        end
    end
    textResult = char(textResult,textZernike);
    if dispText
        set(textHandle,'String',textResult);
    else
        
    end
    set(gcf,'Name',['Wavefront at Exit Pupil']);
end

