function [ semiMajorAxisIn3D,semiMinorAxisIn3D,directionIn3D,orientationAngleIn3D,...
        xMeshIn3D,yMeshIn3D ] = polarizationEllipseParametersIn3D( harmonicFieldSet,plane )
    %COMPLEXAMPLITUDEIN3D % return Ex and Ey in 3D matrix with the 3rd dimension being the spectral dim
    
    allExIn3D = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,1,:));
    allEyIn3D = squeeze(harmonicFieldSet.ComplexAmplitude(:,:,2,:));
    Nx = size(allExIn3D,2);
    Ny = size(allExIn3D,1);
    
    samplingPoints = [Nx;Ny];
    samplingDistance = harmonicFieldSet.SamplingDistance;
    centerXY = harmonicFieldSet.Center;
    [x_lin,y_lin] = generateSamplingGridVectors(samplingPoints ,samplingDistance, centerXY);

    % Initialize all returns to zero
    semiMajorAxisIn3D = allExIn3D*0;
    semiMinorAxisIn3D = allExIn3D*0;
    directionIn3D = allExIn3D*0;
    orientationAngleIn3D = allExIn3D*0;
    xMeshIn3D = allExIn3D*0;
    yMeshIn3D = allExIn3D*0;
    
    nFields = size(allExIn3D,3);
    Nx = size(allExIn3D,1);
    Ny = size(allExIn3D,2);
    if plane == 1 %strcmpi(plane,'XY')
        for kk = 1:nFields
            Ex = allExIn3D(:,:,kk);
            Ey = allEyIn3D(:,:,kk);
            % Convert to 1 D to make compatble with the function computing
            % polarization ellipse parameter( accepts 1XN vector) and
            % returns 4XN matrix of a,b,dir and angle
            Ex1D = (Ex(:))';
            Ey1D = (Ey(:))';
            ellipseParameter = convertJonesVectorToPolarizationEllipse( Ex1D,Ey1D );
            
            semiMajorAxisIn3D(:,:,kk) = reshape(ellipseParameter(1,:),Nx,Ny);
            semiMinorAxisIn3D(:,:,kk) = reshape(ellipseParameter(2,:),Nx,Ny);
            directionIn3D(:,:,kk) = reshape(ellipseParameter(3,:),Nx,Ny);
            orientationAngleIn3D(:,:,kk) = reshape(ellipseParameter(4,:),Nx,Ny);
            
            [xMeshIn3D(:,:,kk),yMeshIn3D(:,:,kk)] = meshgrid(x_lin(:,:,kk),y_lin(:,:,kk));
        end
    else
        msgbox('Ez computaion is not supported at the momnet.');
        return;
    end
end

