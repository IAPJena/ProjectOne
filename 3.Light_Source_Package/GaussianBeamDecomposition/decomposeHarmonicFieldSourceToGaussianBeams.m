function [ gaussianBeamSet ] = decomposeHarmonicFieldSourceToGaussianBeams( ...
        harmonicFieldSource,Nx,Ny,OF,wavelength )
    %DECOMPOSEAMPLITUDEPROFILETOGAUSSIANBEMAS Summary of this function goes here
    %   Detailed explanation goes here
    
    % Take the amplitude profile of the source
    [ U_xyTot,xlinTot,ylinTot] = getSpatialProfile( harmonicFieldSource );
    % Total width of the window
    Wx = max(xlinTot) - min(xlinTot);
    Wy = max(ylinTot) - min(ylinTot);
    
    % Width of each gaussian
    waistX = Wx*OF/(Nx*sqrt(pi));
    waistY = Wy*OF/(Ny*sqrt(pi));
    
    % Check that the waist fulfills paraaxiality of gaussian
    % waist >= minimumWaist, minimumWaist = 3*wavelength
    minimumWaist = 3*wavelength;
    paraxialGaussian = (waistX >= minimumWaist) && (waistY >= minimumWaist);
    if paraxialGaussian
        % Grid spacing for gaussian beamlets
        gridSpacingX = Wx/Nx;
        gridSpacingY = Wx/Ny;
        
        xlinGauss = linspace(min(xlinTot),max(xlinTot),Nx);
        ylinGauss = linspace(min(ylinTot),max(ylinTot),Ny);
        
        [xCenter,yCenter] = meshgrid(xlinGauss,ylinGauss);
        gaussianCenterPosition = [xCenter(:),yCenter(:),xCenter(:)*0];
        
        % Gaussian beam set properties
        nGaussian = size(gaussianCenterPosition,1);
        centralRayPosition = gaussianCenterPosition;
        centralRayDirection = ones(nGaussian,1)*[0,0,1];
        centralRayWavelength = ones(nGaussian,1)*wavelength;
        waistRadiusInX = ones(nGaussian,1)*waistX;
        waistRadiusInY = ones(nGaussian,1)*waistY;
        distanceFromWaistInX = ones(nGaussian,1)*0;
        distanceFromWaistInY = ones(nGaussian,1)*0;
        peakAmplitude = ones(nGaussian,1)*1; % Used for optimization
        
        localXDirection = ones(nGaussian,1)*[1,0,0];
        localYDirection = ones(nGaussian,1)*[0,1,0];
        
        newGaussianBeamSet = ScalarGaussianBeamSet(centralRayPosition,...
            centralRayDirection,centralRayWavelength,waistRadiusInX,...
            waistRadiusInY,distanceFromWaistInX,distanceFromWaistInY,...
            peakAmplitude,localXDirection,localYDirection,nGaussian);
        
        
        % Optimize the amplitude to fit the given U_xyTot which we are
        % decompositing
        
        % First multiply with constant amplitude
        [ U_xyTot2,xlinTot2,ylinTot2] = getSpatialProfile( harmonicFieldSource,xlinGauss,ylinGauss );
        
        optimizationAlgorithmName = 'steepestDescentOptimizer';
        % optimizationAlgorithmName = 'newtonGaussOptimizer';
        % Note: newtonGaussOptimizer This method now works correctly for amplitude
        %  only. But it gives almost the best result in the first iteration
        meritFunctionName = 'RootMeanSquareError';
        
        varAmp = 1;
        if varAmp
            newGaussianBeamSet.PeakAmplitude(:,2) = ones(nGaussian,1);
        else
            newGaussianBeamSet.PeakAmplitude(:,2) = zeros(nGaussian,1);
        end
        
        
        optimizableObject = newGaussianBeamSet;
        % Optimization optins
        optimizationOption = struct();
        optimizationOption.TolX = 10^-3;
        optimizationOption.TolFun = 10^-3;
        optimizationOption.OutputFcn = @(x)x; % just nothing;
        optimizationOption.MaximumIteration = 20;
        
        % Define the GausssianBeamSet Agregate Operand
        optimizationOperandName = 'GBAG';
        signalAmplitudeVector = U_xyTot(:); % 2D amplitude converted to 1D vector
        operandTarget = signalAmplitudeVector;
        
        % The weight can be changed
        % Case 1: Unity weight
        operandWeight = ones(size(signalAmplitudeVector));
        
        %     % Case 2: Give higher weight for boundary gaussians (Parabolic)
        %     maxWeight = 1;
        %     minWeight = 0.5;
        %     nOp = length(signalAmplitudeVector);
        %     x = linspace(-nOp/2,nOp/2-1,nOp);
        %     a = (4*(maxWeight-minWeight))/(nOp^2);
        %     operandWeight = a*x.^2 + minWeight;
        %
        
        %  Case 3: Give weight of 0 for all. atleast one element has to be different
        % from zero since the rmse involves division by weight.
        %     operandWeight = zeros(size(signalAmplitudeVector));
        %     operandWeight(1) = 1;
        
        figure; plot(operandWeight)
        
        uniqueParamStruct = struct();
        uniqueParamStruct.nPointsX = length(xlinTot);
        uniqueParamStruct.lowerX = min(xlinTot);
        uniqueParamStruct.upperX = max(xlinTot);
        
        uniqueParamStruct.nPointsY = length(ylinTot);
        uniqueParamStruct.lowerY =  min(ylinTot);
        uniqueParamStruct.upperY = max(ylinTot);
        
        optimizationOperand = OptimizationOperand( optimizationOperandName,...
            optimizableObject,operandTarget,operandWeight,uniqueParamStruct );
        
        % Define the merit function given by its name
        newMeritFunction.Name = meritFunctionName;
        newMeritFunction.OptimizationOperand = optimizationOperand;
        newMeritFunction.OptimizableObject = optimizableObject;
        
        [fieldNames,fieldFormat,defaultUniqueParamStruct] = ...
            getMeritFunctionUniqueParameters(meritFunctionName);
        newMeritFunction.UniqueParameters = defaultUniqueParamStruct;
        
        
        % Get the initial center and width using a constant width to spacing ratio
        [initialVariableVector,minimumVariableVector,maximumVariableVector] = getOptimizableVector( optimizableObject );
        
        % Call the nonlinear optimizer
        [ optimalValue,optimalMeritFunctionValue,optimizedObject,outputStruct ] = ...
            NonLinearOptimizer( optimizationAlgorithmName,newMeritFunction,...
            optimizationOperand,optimizableObject,...
            optimizationOption,initialVariableVector,minimumVariableVector,maximumVariableVector );
        
        optimalMeritFunctionValue
        
        %         % For now just multiply with the spatial profile
        %         % Add boarder sampling points
        % embeddingFrameSamplePoints = harmonicFieldSource.AdditionalBoarderSamplePoints;
        % NxTot = Nx + embeddingFrameSamplePoints(1);
        % NyTot = Ny + embeddingFrameSamplePoints(2);
        %
        %         [ U_xyTot,xlinTot,ylinTot] = getSpatialProfile( harmonicFieldSource,NxTot,NyTot );
        %
        %         peakAmp = newGaussianBeamSet.PeakAmplitude;
        %         newGaussianBeamSet.PeakAmplitude = peakAmp.*(U_xyTot(:))';
        
        
        gaussianBeamSet = optimizedObject;
    else
        disp(['Error: The waist radius found is not in the paraxial region ',...
            'so please increase the overlap factor.']);
        gaussianBeamSet = NaN;
        return;
    end
end

