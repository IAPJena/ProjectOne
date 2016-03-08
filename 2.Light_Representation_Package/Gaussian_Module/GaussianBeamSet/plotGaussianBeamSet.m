function [ plotted ] = GaussianBeamSet.m( gaussianBeamSet,plotType,nPoints1,nPoints2,axesHandle )
    %GaussianBeamSet.m plots the amplitude, phase and intensity of a given
    %gaussian beam or superposition of gaussian beam arrays
    % plotType = 1(Amplitude),2(Intensity),3(Phase)
    % medium: for computation of mediumImpedence: Intrinsic impedence of the
    % medium for intensity calculation = ratio |E|/|H|
    % = 376.7 Ohms for free space
    
    if nargin == 0
        disp('Error: The function plotGaussianBeam requires gaussian beam object.');
        plotted = NaN;
        return;
    elseif nargin == 1
        plotType = 1;
        nPoints1 = 50;
        nPoints2 = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 2
        nPoints1 = 50;
        nPoints2 = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 3
        nPoints2 = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 4
        figure;
        axesHandle = axes;
    end
    
    mediumImpedence = 376.7;
    % Compute the plotting range (3*standard deviation covers area > 99%)
    E0 = gaussianBeamSet.PeakAmplitude;
    w0x = gaussianBeamSet.WaistRadiusInX;
    w0y = gaussianBeamSet.WaistRadiusInY;
    zx = gaussianBeamSet.DistanceFromWaistInX;
    zy = gaussianBeamSet.DistanceFromWaistInY;
    wavLen = gaussianBeamSet.CentralRayWavelength;
    
    centerPositions = gaussianBeamSet.CentralRayPosition;
    c0x = centerPositions(1,:);
    c0y = centerPositions(2,:);
    
    [ wx,wy ] = getGaussianBeamSpotRadius(gaussianBeamSet);
    [ Rx,Ry ] = getGaussianBeamRadiusOfCurvature(gaussianBeamSet);
    [ guoyPhaseX,guoyPhaseY ] = getGaussianBeamGuoyPhaseShift(gaussianBeamSet);
    
    xMax = 3*wx/sqrt(2);
    yMax = 3*wy/sqrt(2);
    
    maxR = max([xMax;yMax]);
    
    % Plot each gaussian beam separately
    nBeam = length(maxR);
    for bb = 1: nBeam
        r = (linspace(-maxR(bb),maxR(bb),nPoints1))';
        phi = (linspace(0,2*pi,nPoints2));
        
        x = r*cos(phi)+c0x(bb);
        y = r*sin(phi)+c0y(bb);
        
        %
        % xlin = linspace(-xMax,xMax,gridSize);
        % ylin = linspace(-yMax,yMax,gridSize);
        % [x,y] = meshgrid(xlin,ylin);
        
        switch plotType
            case 1 % Amplitude
                amplitude = E0(bb)*((w0x(bb)/wx(bb))*exp(-(x-c0x(bb)).^2/wx(bb)^2)).*((w0y(bb)/wy(bb))*exp(-(y-c0y(bb)).^2/wy(bb)^2));
                output = amplitude;
            case 2 % Intensity
                intensity = ((E0(bb)*((w0x(bb)/wx(bb))*exp(-(x-c0x(bb)).^2/wx(bb)^2)).*((w0y(bb)/wy(bb))*exp(-(y-c0y(bb)).^2/wy(bb)^2))).^2)/mediumImpedence^2;
                output = intensity;
            case 3 % Phase
                phase = ((2*pi/wavLen(bb))*zx(bb) + guoyPhaseX(bb) + (pi/wavLen(bb))*((x-c0x(bb)).^2)/Rx(bb))+...
                    ((2*pi/wavLen(bb))*zy(bb) + guoyPhaseY(bb) + (pi/wavLen(bb))*((y-c0y(bb)).^2)/Ry(bb));
                output = phase;
        end
        surf(axesHandle,x,y,output,'facecolor','interp',...
            'edgecolor','none',...
            'facelighting','phong');
        hold on
    end
    
    view(2);
    axis equal;
    plotted = 1;
end

