function [ product3DMatrix ] = multiplySliced3DMatrices( matrix1,matrix2 )
    % multiplySliced3DMatrices: To perform slicewise multiplication of 3D
    %         matrices and give the output 3D matrix. NB. 2D matrices can
    %         also be used as special case of 3D matrices.
    % Inputs
    %   matrix1,matrix2: Input (n1Xn2,n2Xn3XN or n1Xn2XN, n2Xn3XN) matrices.
    %   NB. The sizes in the 2nd dimensions of the two matrices
    %       must allow multiplication in the given order.
    % Output
    %   product3DMatrix: n1Xn3XN matrix resulting from slicewize producnt
    %   of the two matrices
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jan 18,2014   Worku, Norman G.     Original Version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % Check for inner input sizes for multiplication condition
    outer1 = size(matrix1,1);
    inner1 = size(matrix1,2);
    inner2 = size(matrix2,1);
    outer2 = size(matrix2,2);
    
    if inner1 ~= inner2
        disp('Error: Inner sizes of Matrices must agree for multiplication');
        return;
    else
        % Determine the 3rd dimensions
        thirdDim1 = size(matrix1,3);
        thirdDim2 = size(matrix2,3);
        % Make the third dimension of the two matrices of equal by
        % replicating the last slice of the smaller one.
        if thirdDim1 < thirdDim2
            matrix1 = cat(3,matrix1,repmat(matrix1(:,:,end),[1,1,thirdDim2-thirdDim1]));
        elseif thirdDim1 > thirdDim2
            matrix2 = cat(3,matrix2,repmat(matrix2(:,:,end),[1,1,thirdDim1-thirdDim2]));
        else
        end
         % The following magic line performs the sliced matrix multiplication
         Z = permute(sum(bsxfun(@times,matrix1,permute(matrix2,[4 1 3 2])),2),[1 4 3 2]);

        product3DMatrix = Z;
    end
end

