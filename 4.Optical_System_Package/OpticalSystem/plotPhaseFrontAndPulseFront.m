function [ drawn ] = plotPhaseFrontAndPulseFront( optSystem,wavLenInSI,fieldPointXYInSI,locationOfPhaseFrontAlongChiefRay, nSamplingPoints1,nSamplingPoints2,gridType,plotIn2D,axesHandle )
%PLOTPHASEFRONTANDPULSEFRONT Plot the pulse and phase fron on a system
%layout diagram
% locationOfPhaseFrontAlongChiefRay: In lens unit
if nargin < 9
figure;
axesHandle = axes;
end

% Compute the phase fronts and pulse fronts
[ meshGridX1,meshGridY1,phaseFront] =...
    computePhaseFront(optSystem, wavLenInSI,fieldPointXYInSI,locationOfPhaseFrontAlongChiefRay, nSamplingPoints1,nSamplingPoints2,gridType);
[ meshGridX2,meshGridY2,pulseFront] =...
    computePulseFront(optSystem, wavLenInSI,fieldPointXYInSI,locationOfPhaseFrontAlongChiefRay, nSamplingPoints1,nSamplingPoints2,gridType);

% Plot on the system layout
rayPathMatrix = NaN;
plotSystemLayout(optSystem,rayPathMatrix,plotIn2D,axesHandle)
if min(size(meshGridX1))==1
    if plotIn2D
        % Plot the 2D line on the axes (YZ cross section)
        hold on;
        plot(axesHandle,phaseFront,meshGridY1,'LineWidth',1,'Color','g');
        hold on;
        plot(axesHandle,pulseFront,meshGridY2,'LineWidth',1,'Color','r');   
        % Plot the phase and pulse fronts on separate figure for detailed
        % view
        phaseAndPulseFrontFig = figure('Name','Phase and Pulse Front');
        phaseAndPulseFrontAxes = axes('parent',phaseAndPulseFrontFig);
        plot(phaseAndPulseFrontAxes,phaseFront,meshGridY1,'LineWidth',1,'Color','g');
        hold on
        plot(phaseAndPulseFrontAxes,pulseFront,meshGridY1,'LineWidth',1,'Color','r'); 
        legend(phaseAndPulseFrontAxes,'Phase Front','Pulse Front')
        
        % Plot the differnce between the two fronts
        h = figure('name','phaseFront-pulseFront');
        newAxes = axes;
        plot(newAxes,phaseFront-pulseFront,meshGridY1,'LineWidth',1,'Color','r'); 
        
%         pulseFrontFig = figure('Name','Phase Front');
%         pulseFrontAxes = axes('parent',pulseFrontFig);
%         plot(pulseFrontAxes,pulseFront,meshGridY1,'LineWidth',1,'Color','r');         
    else
        % Plot the 3D line on the axes
        hold on;
        plot3(axesHandle,meshGridX1,phaseFront,meshGridY1,'LineWidth',1,'Color','g');
        hold on;
        plot3(axesHandle,meshGridX2,pulseFront,meshGridY2,'LineWidth',1,'Color','r');  

        % Plot the phase and pulse fronts on separate figure for detailed
        % view
        phaseAndPulseFrontFig = figure('Name','Phase and Pulse Front');
        phaseAndPulseFrontAxes = axes('parent',phaseAndPulseFrontFig);
        plot3(phaseAndPulseFrontAxes,meshGridX1,phaseFront,meshGridY1,'LineWidth',1,'Color','g');
        hold on
        plot3(phaseAndPulseFrontAxes,meshGridX2,pulseFront,meshGridY2,'LineWidth',1,'Color','r'); 
        legend(phaseAndPulseFrontAxes,'Phase Front','Pulse Front')   
        
        % Plot the differnce between the two fronts
        h = figure('name','phaseFront-pulseFront');
        newAxes = axes;
        plot3(newAxes,meshGridX2,phaseFront-pulseFront,meshGridY2,'LineWidth',1,'Color','r'); 

    
%         pulseFrontFig = figure('Name','Phase Front');
%         pulseFrontAxes = axes('parent',pulseFrontFig);
%         plot3(pulseFrontAxes,meshGridX2,pulseFront,meshGridY2,'LineWidth',1,'Color','r');          
        
    end
else
    % Plot surface
    hold on;
    surf(axesHandle,meshGridX1,phaseFront,meshGridY1,'FaceColor','g','EdgeColor','none','FaceAlpha',0.5);
    hold on;
    surf(axesHandle,meshGridX2,pulseFront,meshGridY2,'FaceColor','r','EdgeColor','none','FaceAlpha',0.5);
    
    % Plot the phase and pulse fronts on separate figure for detailed
    % view
    phaseAndPulseFrontFig = figure('Name','Phase and Pulse Front');
    phaseAndPulseFrontAxes = axes('parent',phaseAndPulseFrontFig);
    surf(phaseAndPulseFrontAxes,meshGridX1,phaseFront,meshGridY1,'FaceColor','g','EdgeColor','none','FaceAlpha',0.5);
    hold on;
    surf(phaseAndPulseFrontAxes,meshGridX2,pulseFront,meshGridY2,'FaceColor','r','EdgeColor','none','FaceAlpha',0.5);
    legend(phaseAndPulseFrontAxes,'Phase Front','Pulse Front')
%     alpha(phaseAndPulseFrontAxes,0.5)    
    az = 72; el = 30;
    view(phaseAndPulseFrontAxes,[az,el])
    
    % Plot the differnce between the two fronts
    h = figure('name','phaseFront-pulseFront');
    newAxes = axes;
    surf(newAxes,meshGridX2,phaseFront-pulseFront,meshGridY2,'FaceColor','r','EdgeColor','none','FaceAlpha',0.5);
%     pulseFrontFig = figure('Name','Pulse Front');
%     pulseFrontAxes = axes('parent',pulseFrontFig);
%     surf(pulseFrontAxes,meshGridX2,pulseFront,meshGridY2,pulseFront,'FaceColor','interp','EdgeColor','none');
%     view(pulseFrontAxes,[az,el])
end
drawn = 1;
end

