function [ outValReshaped ] = compute3dDot(vect1,vect2)
    % compute3dDot: computes the dot product of two 3xN vectors
    %   The function is also vectorized so if the inputs are array then
    %   the output will also be array of the same size.
    %   To replace the default cross function b/c it is faster
    % Input:
    %    vect1,vect2: 3xN vectors
    % Output:
    %    outVal : Nx1 the dot product
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jan 18,2014   Worku, Norman G.     Original with Vectorized inputs and outputs
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    % If the input vectors are 3 X n1 X n2 X... (but both with the same
    % dims) , first convert to 3 X N where N = n1*n2*... , then perform the
    % dot product and reshape back to the original shape.
    size1 = size(vect1);
    size2 = size(vect2);
    
    sizeMax = max([size1(2),size2(2)]);
    
    if size1(2) < sizeMax
        vect1 = cat(2,vect1,repmat(vect1(:,end),[1,sizeMax-size1(2)]));
    end
    if size2(2) < sizeMax
        vect2 = cat(2,vect2,repmat(vect2(:,end),[1,sizeMax-size2(2)]));
    end
    
    if size1(1) == 3
        if length(size1) > 2
            N = prod(size1(2:end));
            newReshapedVect1 = reshape(vect1,[3,N]);
            newReshapedVect2 = reshape(vect2,[3,N]);
        else
            newReshapedVect1 = (vect1);
            newReshapedVect2 = (vect2);
        end
    else
        disp('Error: First dim of the two vectors must be 3 for compute3dDot function');
        outValReshaped = NaN;
        return;
    end

    outVal = newReshapedVect1(1,:).*newReshapedVect2(1,:) + ...
        newReshapedVect1(2,:).*newReshapedVect2(2,:)+ ...
        newReshapedVect1(3,:).*newReshapedVect2(3,:);
    
    % reshape back
    if length(size1) > 2
        outValReshaped = reshape(outVal,[1,size1(2:end)]);
    else
        outValReshaped = outVal;
    end
end

