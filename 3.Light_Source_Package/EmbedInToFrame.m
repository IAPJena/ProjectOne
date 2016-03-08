function [ U_xyTot] = EmbedInToFrame( U_xy,zeroPixelsLeft,zeroPixelsRight,zeroPixelsTop,zeroPixelsBottom)
    %EMBEDINTOFRAME Appends zero pixels around the field
   
    U_xyTot = [zeros(size(U_xy,1),zeroPixelsLeft),U_xy,...
        zeros(size(U_xy,1),zeroPixelsRight)];
    % Here the order for Top and Bottom is exchanged from the normal
    % expected order. This is because Matlab plots the indices are counted
    % from left to right and top to bottom. But normally we expect the
    % indices to increase from bottom to top !! 
    % To see what i mean run the following script
    %     pcolor(hadamard(20))
    %     colormap(gray(2))
    %     axis ij
    %     axis square
    U_xyTot = [zeros(zeroPixelsBottom,size(U_xyTot,2));U_xyTot;...
        zeros(zeroPixelsTop,size(U_xyTot,2))];
end

