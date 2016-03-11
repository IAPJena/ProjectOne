function [RGBGradient,demoImage] = computeColorMap(cmapName,nLevels)
    % computeColorMap used to generate a RGB values corresponding to color
    % map specified by cmap. It uses linear interpolation to increase number 
    % of levels.
    %
    % Written by: 
    % Norman G. Worku
    % Date: 11.03.2016
    % INPUT:
    % - cmap: name of the color map (should be valid matlab color map).
    % - nLevels: number of colors or elements of the gradient.
    %
    % OUTPUT:
    % - RGBGradient: a matrix of nLevels*3 elements containing colormap.
    % - demoImage: a nLevel*10*3 RGB image that can be used to display the result demo.
    %
    % EXAMPLES:
    %  [RGBGradient,demoImage] = computeColorMap('jet',100)
    %  ---- See the gradient generated------------
    % image(demoImage); %display an image with the color gradient.
    %  ---- Use the gradient as color map ------------
    % surf(peaks)
    % colormap(RGBGradient);
    
    if nargin < 1
        cmapName = 'jet';
    end
    if nargin < 2
        nLevels = 64;
    end
    
    switch cmapName
        case {'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer',...
                'autumn', 'winter', 'gray ', 'bone ', 'copper', 'pink ', ...
                'lines ', 'colorcube ', 'prism ', 'flag', 'white'}
            cmap = colormap(cmapName);
        otherwise
            cmapName = 'jet';
            cmap = colormap(cmapName);
    end
    
    % Interpolate the matrix
    linR = cmap(:,1);
    linG = cmap(:,2);
    linB = cmap(:,3);
   
    linR_interpolated = interp1(linR,(linspace(1,length(linR),nLevels))');
    linG_interpolated = interp1(linG,(linspace(1,length(linG),nLevels))');
    linB_interpolated = interp1(linB,(linspace(1,length(linB),nLevels))');
    
    RGBGradient = [linR_interpolated,linG_interpolated,linB_interpolated];
    
    imageR = repmat(linR_interpolated,[1,10]);
    imageG = repmat(linG_interpolated,[1,10]);
    imageB = repmat(linB_interpolated,[1,10]);

    % merge R G B matrix and obtain our demo image.
    demoImage=cat(3,imageR,imageG,imageB);
