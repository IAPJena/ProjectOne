function [ XMulti,YMulti,normalizedIntensityMulti,peakIntensityMulti,SrehlRatioMuti1 ] =...
        plotFFTPointSpreadFunction( optSystem,wavelengthIndices,fieldIndices,gridSize,...
        spotPlotRadius, plotPanelHandle,textHandle)
    % plotFFTPointSpreadFunction Summary of this function goes here
    %   if axesHandle is not given then plot is not needed and only
    %   calculated datas shall be returned. wavelengthIndices, fieldIndices
    %   apodType,apodParam : Apodization type index and corresponding
    %   apodization parameters.
    
    % Default inputs
    dispPlot = 1;
    dispText = 1;
    if nargin < 4
        disp(['Error: The plotFFTPointSpreadFunction function needs atleast',...
            'optSystem,wavLen, fieldPointXY and rayGridSize as arguments.']);
        XMulti = [];
        YMulti = [];
        normalizedIntensityMulti = [];
        peakIntensityMulti = [];
        return
    elseif nargin == 4
        spotPlotRadius = 0.02;
        dispPlot = 0;
        dispText = 0;
    elseif nargin == 5
        dispPlot = 0;
        dispText = 0;
    elseif nargin == 6
        dispText = 0;
    else
        
    end
    
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
    
    % Compute the wavefront surface no axes handle is given to supress the
    % plot. NB. The X,Y and OPDAtExitPupil will be 4D matrix of dim
    % [l,m,nField,nWav]
    zerCoeff = 9;
    
    [ XMulti1,YMulti1,OPDAtExitPupilMulti1,PupilWeightMatrixMulti1,...
        RMSMulti1,WPVMulti1,ZERMulti1,SrehlRatioMuti1 ] = ...
        plotWavefrontAtExitPupil(optSystem,wavelengthIndices,fieldIndices,gridSize,...
        zerCoeff);
    nField = size(OPDAtExitPupilMulti1,3);
    nWav = size(OPDAtExitPupilMulti1,4);

    if dispPlot
        % Clear all childs of plotPanelHandle
        set(get(plotPanelHandle,'Children'),'Visible','off');
    end
    textResult = char('','<<<<<<<<<< FFT PSF >>>>>>>>>>>','');
    
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
            pupilApodization = PupilWeightMatrixMulti1(:,:,fieldIndex,wavIndex);
            
            OPDAtExitPupil = OPDAtExitPupilMulti1(:,:,fieldIndex,wavIndex);
            %%
            %         % propagate complex pupil function using scalar diffraction and plot psf
            X = XMulti1(:,:,fieldIndex,wavIndex);
            Y = YMulti1(:,:,fieldIndex,wavIndex);
            xp = X(1,:);
            yp = Y(:,1);
            %         % For the spot display
            %         npx = length(xp);
            %         npy = npx;
            %         dus = spotPlotRadius; % size to see the result
            %         xs = linspace(-dus,dus,npx);
            %         ys = xs;
            %%
            % Modify the OPD by appending zeros in the bottom and left
            % Similarly add an additional point in the -ve directions for xp and
            % yp. This is required as the function 'prop_fraun_fft' assumes NxN
            % input field (even N), where the real field is of odd dimension
            % starting from 2 to N and N/2+1 beign its center.
            
            %         mod_xp = [2*xp(1)-xp(2),xp];
            %         mod_yp = [2*yp(1)-yp(2);yp];
            %         mod_xs = [2*xs(1)-xs(2),xs];
            %         mod_ys = [2*ys(1)-ys(2),ys];
            %         mod_OPDAtExitPupil = [zeros(size(OPDAtExitPupil,1),1),OPDAtExitPupil];
            %         mod_OPDAtExitPupil = [mod_OPDAtExitPupil;zeros(1,size(mod_OPDAtExitPupil,2))];
            
            %             wlInMM = wavLen(wavIndex)*getWavelengthUnitFactor(optSystem)*10^3; % Wavelength in mm
            
            kW = (2*pi/(wavLen(wavIndex)*getWavelengthUnitFactor(optSystem)))*...
                OPDAtExitPupil*getLensUnitFactor(optSystem);
            
            efd = sqrt(pupilApodization).*exp(-1i.*kW); % Complex pupil fun
            %%
            %                     z = -getExitPupilLocation(optSystem);
            %                     % Add spherical phase correction as the existing diffraction code
            %                     % assumes the wavefront has curvature = Z of propagation
            %                     [xpm,ypm] = meshgrid(xp,yp);
            %                     rpm = sqrt(xpm.^2+ypm.^2);
            %                     rcurv = z;
            %                     efd = efd .* exp(-1i*pi/(wl*z)*(rpm.^2));
            %%
            %  Propagation
            
            %% new code
            npx = size(X,1);
            npy = size(X,2);
            
            Ex = efd;
            Ey = efd*0;
            sampDistX = ((max(max(X))-min(min(X)))/(npx-1))*getLensUnitFactor(optSystem);
            sampDistY = ((max(max(Y))-min(min(Y)))/(npy-1))*getLensUnitFactor(optSystem);
            wavelen = wavLen(wavIndex)*getWavelengthUnitFactor(optSystem);
            initialHarmonicField = HarmonicFieldSet(Ex,Ey,sampDistX,sampDistY,wavelen);
            
            propagationDistance = -getExitPupilLocation(optSystem)*getLensUnitFactor(optSystem);
            outputWindowSize = 2*spotPlotRadius*getLensUnitFactor(optSystem);
            addSphericalCorrection = 1; % since field is defined on exit pupil sphere
            [ finalHarmonicField ] = FraunhoferPropagator( initialHarmonicField,...
                propagationDistance,outputWindowSize,addSphericalCorrection );
            efds = computeEx(finalHarmonicField);
            npxs = size(efds,1);
            npys = size(efds,2);
            
            dxs = finalHarmonicField.SamplingDistance(1);
            dys = finalHarmonicField.SamplingDistance(2);
            if npxs == 1
                xs = 0;
            else
                xs = [-floor(npxs/2)*dxs:dxs:floor(npxs/2)*dxs];
            end
            if npys == 1
                ys = 0;
            else
                ys = [-floor(npys/2)*dys:dys:floor(npys/2)*dys];
            end
            %
            % dus = outputWindowSize/2; % size to see the result (radius)
            % xs = linspace(-dus,dus,npx);
            % ys = xs;
            %%  end of new code
            
            % % efds = fraunhoferDiffraction(efd,wl, abs(xp(1)-xp(2)), z);
            %  efds = prop_fraun_fft(xp,yp,efd,xs,ys,z,wl);
            %%
            intensity = abs(efds).^2;
            
            % Normalize and plot Intensity
            normalize = 1;
            if normalize
                peakIntensity = max(max(intensity));
                intensity = intensity./peakIntensity;
            end
            [xbm,ybm] = meshgrid(xs,ys);
            
            strehlRatio = SrehlRatioMuti1(fieldIndex,wavIndex);
            textResult = char(textResult,...
                ['Field Point XY : [',num2str(fieldPointXY(1,fieldIndex)),',',...
                num2str(fieldPointXY(2,fieldIndex)),']'],...
                ['Wavelength : ',num2str(wavLen(wavIndex))],...
                ['Srehl Ratio (Approximation of Marechal) : ',num2str(strehlRatio)],'');
            
            if dispPlot
                % Plot the PSF
                EnhancedPColor({subplotAxes,xbm,ybm,intensity},sectionPlotAxes);
                title(subplotAxes,'FFT PSF (Intensity)')
                zlabel(subplotAxes,'Intensity') % x-axis label
                xlabel(subplotAxes,'X (m)')
                ylabel(subplotAxes,'Y (m)')
                axis(subplotAxes,'tight')
            end
            
            normalizedIntensityMulti (:,:,fieldIndex,wavIndex) = intensity;
            peakIntesityMulti(:,:,fieldIndex,wavIndex) = peakIntensity;
            XMulti (:,:,fieldIndex,wavIndex) = xbm;
            YMulti (:,:,fieldIndex,wavIndex) = ybm;
        end
    end
    if dispText
        set(textHandle,'String',textResult);
    else
        disp(textResult);
    end
    set(gcf,'Name',['Point Spread Function (PSF)']);
end

