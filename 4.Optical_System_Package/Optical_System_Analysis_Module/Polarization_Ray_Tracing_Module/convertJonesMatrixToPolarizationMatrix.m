function [ Pqm1 ] = convertJonesMatrixToPolarizationMatrix( JMq,Kqm1,Kq)
    % convertJonesToPolarizationMatrix:  Converts 2D Jones Matrix to 3D P Matrix
    % The function is vectorized so it can work on
    % multiple sets of inputs once at the same time.
    %  Input
    %     JMq: 2X2XN Jones Matrix for the component
    %     Kqm1,Kq:3XN Wave vector before component q and just after component q
    %  Output
    %     Pq: a 3X3XN P matrix
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %   Part of the RAYTRACE_TOOLBOX V3.0 (OOP Version)
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jan 18,2014   Worku, Norman G.     Vectorized inputs and outputs
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % Compute local coordinates before {Sq,Pq,Kqm1} and after the component  {Sqp,Pqp,Kq}
    nRay = size(JMq,3);
    temp1 = compute3dCross(Kqm1,Kq);
    % For temp1~=0
    cond1 = sum(temp1.^2,1)~=0;
    Sqm1 = temp1;
    Sqm1(:,cond1) = temp1(:,cond1)./repmat(sqrt(sum(temp1(:,cond1).^2,1)),[3,1]);
    % Handle case for Kqm1 = Kq so temp1==0
    temp2 = compute3dCross(Kqm1,[0;0;1]);
    cond2 = sum(temp1.^2,1)==0&sum(temp2.^2,1)~=0;
    Sqm1(:,cond2) = temp2(:,cond2)./repmat(sqrt(sum(temp2(:,cond2).^2,1)),[3,1]);
    % Handle case Kqm1=[0 0 1]
    cond3 = sum(temp1.^2,1)==0&sum(temp2.^2,1)==0;
    % Sq = [1 ;0 ;0]
    Sqm1(1,cond3) = 1;
    Sqm1(2,cond3) = 0;
    Sqm1(3,cond3) = 0;
    
    Pqm1 = compute3dCross(Kqm1,Sqm1);
    Sq = Sqm1;
    Pq = compute3dCross(Kq,Sqm1);
    
    % Compute the Orthogonal matrices to transform to and from local
    % coordinates before and after the component p
    
    % Transform incident light [Exq-1 Eyq-1 Ezq-1] = [Esq-1,Epq-1,0] from global
    % coordinate {x,y,z} to local coordinate {Sq,Pq,Kqm1}
    Oinq(1,1,:) = Sqm1(1,:);Oinq(1,2,:) = Sqm1(2,:);Oinq(1,3,:) = Sqm1(3,:);
    Oinq(2,1,:) = Pqm1(1,:);Oinq(2,2,:) = Pqm1(2,:);Oinq(2,3,:) = Pqm1(3,:);
    Oinq(3,1,:) = Kqm1(1,:);Oinq(3,2,:) = Kqm1(2,:);Oinq(3,3,:) = Kqm1(3,:);
    
    % Transform light [Exq Eyq Ezq] = [Esqp,Epqp,0] from local
    % coordinate {Sqp,Pqp,Kq} to global coordinate {x,y,z}
    Ooutq(1,1,:) = Sq(1,:);Ooutq(1,2,:) = Pq(1,:);Ooutq(1,3,:) = Kq(1,:);
    Ooutq(2,1,:) = Sq(2,:);Ooutq(2,2,:) = Pq(2,:);Ooutq(2,3,:) = Kq(2,:);
    Ooutq(3,1,:) = Sq(3,:);Ooutq(3,2,:) = Pq(3,:);Ooutq(3,3,:) = Kq(3,:);
    
    % Change the 2x2 Jones to 3x3 by just adding 0 and 1
    JMq_new = JMq;
    JMq_new(:,3,:) = repmat([0;0],[1,nRay]);
    JMq_new(3,:,:) = repmat([0;0;1],[1,nRay]);
    
    % Finally compute your P matrix
    Pqm1 = multiplySliced3DMatrices( multiplySliced3DMatrices( Ooutq,JMq_new ),Oinq );
end

