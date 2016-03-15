function [ C ] = computeSurfaceColor( Z,peakColor,valleyColor,nLevels )
    %COMPUTESURFACECOLOR Computes the 3D color matrix for coloring the
    %surface described by (Z). The function first generates a color map
    %based on the two maxima colors given and maps the values of 
    %(Z) to the colormap. 
    % 
    % INPUT:
    % -Z : a 2D matrix with the values used to color the surface.
    % -peakColor: the RGB vector (1x3) for maximum Z value
    % -valleyColor: the RGB vector (1x3) for minimum Z value
    % -nLevels: the number of colors inbetween the max and min values
    %
    % OUTPUT:
    % -C : A 3D matrix which has the color values for each points of the Z
    % matrix. It can be directly passed to the surf functions to color any
    % surface.
    %
    % Example1: Basic usage
    % Z = peaks; peakColor = [1,0,0];,valleyColor = [0,1,0]; nLevels = 100;
    % C = computeSurfaceColor( Z,peakColor,valleyColor,nLevels );
    % figure; surf(Z,C)
    %
    % Example2: Use to plot two surfaces with differnt color grad on the
    % same axis
    % Z1 = peaks; peakColor1 = [0,1,0];,valleyColor1 = [0,0,1]; nLevels = 100;
    % C1 = computeSurfaceColor( Z1,peakColor1,valleyColor1,nLevels );
    % Z2 = peaks-20; peakColor2 = [1,0,0];,valleyColor2 = [0,0,1]; nLevels = 100;
    % C2 = computeSurfaceColor( Z2,peakColor2,valleyColor2,nLevels );
    % figure; surf(Z1,C1); hold on;  surf(Z2,C2);  
    
    P = Z;
%     colorGrad = computeLinearColorGradient(peakColor,valleyColor,nLevels);
    colorGrad = computeColorMap('summer',nLevels);
    
    stepSize = (max(max(P) - min(min(P))))/nLevels;
    if stepSize == 0
        stepSize = 1;
    end
    colorLevelIndex = floor((P - min(min(P)))/stepSize);
    
    colorLevelIndex(colorLevelIndex == 0) = 1;
    colorLevelIndex(isnan(colorLevelIndex)) = 1;
    
    R = reshape(colorGrad(colorLevelIndex(:),1),size(colorLevelIndex));
    G = reshape(colorGrad(colorLevelIndex(:),2),size(colorLevelIndex));
    B = reshape(colorGrad(colorLevelIndex(:),3),size(colorLevelIndex));
    C = cat(3,R,G,B);
end

