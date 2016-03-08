function [ drawn ] = plotPhaseAndPulseFrontEvolution( ...
        optSystem, wavelengthIndices,fieldIndices, refSurfaceIndex, deltaTime,...
        numberOfTimeSamples,nSamplingPoints1,nSamplingPoints2,gridType,plotIn2D,axesHandle )
    %plotPhaseAndPulseFrontEvolution: Plot the pulse and phase evolution near
    %a given surface.
    if nargin < 11
        figure;
        axesHandle = axes;
    end
    
    offsetInTime = [-floor(numberOfTimeSamples/2):1:floor(numberOfTimeSamples/2)]*deltaTime;
    nTime = length(offsetInTime);
    
    if plotIn2D
        gridType = 'Tangential';
    end
    maxX = 0;
    maxY = 0;
    minX = 0;
    minY = 0;
    
    maxZWidth = 0;
    for kk = 1:nTime
        % Compute the phase fronts and pulse fronts
        [ meshGridX1(:,:,kk),meshGridY1(:,:,kk),phaseFront(:,:,kk)] =...
            computePhaseFront(optSystem,wavelengthIndices,fieldIndices,...
            refSurfaceIndex,offsetInTime(kk), nSamplingPoints1,nSamplingPoints2,gridType);
        [ meshGridX2(:,:,kk),meshGridY2(:,:,kk),pulseFront(:,:,kk)] =...
            computePulseFront(optSystem, wavelengthIndices,fieldIndices,...
            refSurfaceIndex,offsetInTime(kk), nSamplingPoints1,nSamplingPoints2,gridType);
    end
    
    % compute the minimum and maximum limits of the x and y axis and the
    % maximum width of the z axis so that all subplots will be of the same
    % scale
    minX = min(min(min(meshGridX1)));
    minY = min(min(min(meshGridY1)));
    
    maxX = max(max(max(meshGridX1)));
    maxY = max(max(max(meshGridY1)));
    
    phaseFrontWidth = squeeze(max(max(phaseFront,[],1),[],2) -  min(min(phaseFront,[],1),[],2));
    phaseFrontCenter = squeeze(0.5*(max(max(phaseFront,[],1),[],2) +  min(min(phaseFront,[],1),[],2)));
    
    pulseFrontWidth = squeeze(max(max(pulseFront,[],1),[],2) -  min(min(pulseFront,[],1),[],2));
    pulseFrontCenter = squeeze(0.5*(max(max(pulseFront,[],1),[],2) +  min(min(pulseFront,[],1),[],2)));
    
    maxZWidth = max(max(cat(2,phaseFrontWidth,pulseFrontWidth)));
    
    for kk = 1:nTime
        % Plot the phase and pulse fronts on separate figure for detailed view
        if plotIn2D
            h = subplot(1,nTime,kk,'replace');%,...
            plot(phaseFront(:,:,kk),meshGridY1(:,:,kk),'--','LineWidth',2,'Color','g');
            hold on
            plot(pulseFront(:,:,kk),meshGridY1(:,:,kk),'-','LineWidth',2,'Color','r');
            hold on
            % NB. X and Z axis are exchanged from that of default
            set(h,'YLim',[minY,maxY],...
                'XLim',[phaseFrontCenter(kk) - 2*maxZWidth, phaseFrontCenter(kk)+ 2*maxZWidth],...
                'XTick',[phaseFrontCenter(kk) - 2*maxZWidth,phaseFrontCenter(kk),phaseFrontCenter(kk) + 2*maxZWidth]);
        else
            h = subplot(1,nTime,kk,'replace');
            surf(phaseFront(:,:,kk),meshGridX1(:,:,kk),meshGridY1(:,:,kk));
            shading interp
            hold on
            surf(pulseFront(:,:,kk),meshGridX1(:,:,kk),meshGridY1(:,:,kk));
            shading interp
            hold on
            % NB. X and Z axis are exchanged from that of default
            set(h,...
                'ZLim',[minX,maxX],'YLim',[minY,maxY],...
                'XLim',[phaseFrontCenter(kk) - 2*maxZWidth, phaseFrontCenter(kk) + 2*maxZWidth],...
                'XTick',[phaseFrontCenter(kk) - 2*maxZWidth,phaseFrontCenter(kk),phaseFrontCenter(kk) + 2*maxZWidth]);
        end
        legend(h,'Phase front','Pulse front','Location','NorthOutSide');
        xlabel(h,['t = ',num2str(offsetInTime(kk)),' s']);
    end
    drawn = 1;
end

