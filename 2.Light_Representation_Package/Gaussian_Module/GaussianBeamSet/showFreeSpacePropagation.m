function [ plotted ] = showFreeSpacePropagation( gaussianBeam,startZ,endZ,...
        plotType ,nRadialPoints,nAngularPoints,axesHandle)
    %SHOWFREESPACEPROPAGATION Shows 3D animation of propagation of gaussian
    %beam through free space froom start Z to final Z
    
    if nargin == 0
        disp('Error: The function showFreeSpacePropagation requires gaussian beam object.');
        plotted = NaN;
        return;
    elseif nargin == 1
        startZ = -3*getRayleighRange(gaussianBeam);
        endZ = 3*getRayleighRange(gaussianBeam);
        plotType = 1;
        nRadialPoints = 50;
        nAngularPoints = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 2
        endZ = 3*getRayleighRange(gaussianBeam);
        plotType = 1;
        nRadialPoints = 50;
        nAngularPoints = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 3
        plotType = 1;
        nRadialPoints = 50;
        nAngularPoints = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 4
        nRadialPoints = 50;
        nAngularPoints = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 5
        nAngularPoints = 64;
        figure;
        axesHandle = axes;
    elseif nargin == 6
        figure;
        axesHandle = axes;
    end
    
    distanceFromWaistInX = linspace(startZ,endZ,200);
    distanceFromWaistInY = distanceFromWaistInX;
    
    E0 = gaussianBeam.PeakAmplitude;
    w0x = gaussianBeam.WaistRadiusInX;
    w0y = gaussianBeam.WaistRadiusInY;
    wavLen = gaussianBeam.CentralRayWavelength;
    [ wx,wy ] = getSpotRadius(gaussianBeam);
    gaussianBeam.DistanceFromWaistInX = distanceFromWaistInX(1);
    gaussianBeam.DistanceFromWaistInY = distanceFromWaistInY(1);
    % gaussianBeam.DistanceFromWaistInY = distanceFromWaist(1);
    zx = gaussianBeam.DistanceFromWaistInX;
    zy = gaussianBeam.DistanceFromWaistInY;
    xLimit = 3*wx/sqrt(2);
    yLimit = 3*wy/sqrt(2);
    
    % for zz = 1:200
    %     gaussianBeam.DistanceFromWaistInX = distanceFromWaist(zz);
    %     gaussianBeam.DistanceFromWaistInY = distanceFromWaist(zz);
    %
    %     zx = gaussianBeam.DistanceFromWaistInX;
    %     zy = gaussianBeam.DistanceFromWaistInY;
    %     [ wx,wy ] = gaussianBeam.getSpotRadius;
    %     [ Rx,Ry ] = gaussianBeam.getRadiusOfCurvature;
    %     [ guoyPhaseX,guoyPhaseY ] = gaussianBeam.getGuoyPhaseShift;
    %     xMax = 3*wx/sqrt(2);
    %     yMax = 3*wy/sqrt(2);
    %
    %     maxR = max([xMax,yMax]);
    %     r = (linspace(-maxR,maxR,nRadialPoints))';
    %     phi = (linspace(0,2*pi,nAngularPoints));
    %     x = r*cos(phi);
    %     y = r*sin(phi);
    %
    % %     xlin = linspace(-xMax,xMax,gridSize);
    % %     ylin = linspace(-yMax,yMax,gridSize);
    % %     [x,y] = meshgrid(xlin,ylin);
    %
    %
    %     switch plotType
    %         case 1 % Amplitude
    %             amplitude = E0*((w0x/wx)*exp(-x.^2/wx^2)).*((w0y/wy)*exp(-y.^2/wy^2));
    %             output = amplitude;
    %         case 2 % Intensity
    %             intensity = ((E0*((w0x/wx)*exp(-x.^2/wx^2)).*((w0y/wy)*exp(-y.^2/wy^2))).^2)/mediumImpedence^2;
    %             output = intensity;
    %         case 3 % Phase
    %             phase = ((2*pi/wavLen)*zx + guoyPhaseX + (pi/wavLen)*(x.^2)/Rx)+...
    %                 ((2*pi/wavLen)*zy + guoyPhaseY + (pi/wavLen)*(y.^2)/Ry);
    %             output = mod(phase,2*pi);
    %     end
    %     surf(axesHandle,x,y,output,'facecolor','interp',...
    %                  'edgecolor','none',...
    %                  'facelighting','phong');
    % %     hold on;
    % %     axis equal;
    %     xlim(2*[-xLimit xLimit])
    %     ylim(2*[-yLimit yLimit])
    % %     zlim([0 2*pi])
    %     zlim([0 E0])
    %     view(2);
    %
    %     pause(0.05)
    % end
    
    % To show gaussian beam in 3D
    maxR = max([wx,wy]);
    r = (linspace(-maxR,maxR,nRadialPoints))';
    phi = (linspace(0,2*pi,nAngularPoints));
    x = r*cos(phi);
    y = r*sin(phi);
    z = zx.*ones(size(x,1),size(x,2));
    xyzPoints1 =  cat(3,x,y,z);
    for zz = 1:200
        gaussianBeam.DistanceFromWaistInX = distanceFromWaistInX(zz);
        gaussianBeam.DistanceFromWaistInY = distanceFromWaistInY(zz);
        %     gaussianBeam.DistanceFromWaist = distanceFromWaist(zz);
        zx = gaussianBeam.DistanceFromWaistInX;
        zy = gaussianBeam.DistanceFromWaistInY;
        [ wx,wy ] = getSpotRadius(gaussianBeam);
        [ Rx,Ry ] = getGaussianBeamRadiusOfCurvature(gaussianBeam);
        [ guoyPhaseX,guoyPhaseY ] = getGuoyPhaseShift(gaussianBeam);
        
        maxR = max([wx,wy]);
        r = (linspace(-maxR,maxR,nRadialPoints))';
        phi = (linspace(0,2*pi,nAngularPoints));
        x2 = r*cos(phi);
        y2 = r*sin(phi);
        
        z2 = zx.*ones(size(x2,1),size(x2,2));
        xyzPoints2 =  cat(3,x2,y2,z2);
        
        gaussianBoarderX(:,:,zz) = [xyzPoints2(1,:,1);xyzPoints1(1,:,1)];
        gaussianBoarderY(:,:,zz) = [xyzPoints2(1,:,2);xyzPoints1(1,:,2)];
        gaussianBoarderZ(:,:,zz) = [xyzPoints2(1,:,3);xyzPoints1(1,:,3)];
        
        
        surf(axesHandle,[gaussianBoarderX(:,:,zz)],[gaussianBoarderY(:,:,zz)],[gaussianBoarderZ(:,:,zz)],'facecolor','interp',...
            'edgecolor','none',...
            'facelighting','phong');
        hold on;
        %      axis equal;
        xlim(2*[-xLimit xLimit])
        ylim(2*[-yLimit yLimit])
        % %     zlim([0 2*pi])
        zlim(2*[startZ endZ])
        %     view(2);
        
        xyzPoints1 = xyzPoints2;
        pause(0.05)
    end
    
end

