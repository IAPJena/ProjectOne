function [Q,U] = convertPDToQUParameter(P,D,surfVertexZ) 
% convert the Position and Direction parameter of ray to Q U parameter
% Assume meridional plane ray (y z plane)

%check for meridionality of the ray
if P(1)~= 0 || D(1) ~= 0
   disp('The ray is not in the yz plane.'); 
else
   U = sign(D(2))*(acos(D(3))); 
   H = P(2); % height of ray position from optical axis
   S = P(3)-surfVertexZ; % distance from vertex to ray position along axis
 
   L = S - H/tan(U); %distance from vertex to ray intersection point with optical axis
   if abs(L) == inf
       Q = H;
   else
      Q = -L*sin(U);
   end
end
