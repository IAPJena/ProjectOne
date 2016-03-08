function [P,D] = convertQUToPDParameter(Q,U,surfVertexZ,surfRadius) 
% convert the Q U parameter  to Position and Direction parameter of ray 
% Assume meridional plane ray (y z plane)

%check for meridionality of the ray
if 1 == 0
   disp('The ray is not in the yz plane.'); 
else
   L = -Q/sin(U);
   I = asin((Q/surfRadius) + sin (U));
   if abs(surfRadius) ~= inf 
      Z = surfVertexZ + surfRadius *(1-cos(I-U)); 
      Y = surfRadius *(sin(I-U));
   else
       Z = surfVertexZ;
       Y = Q/cos(U);
   end
   
   P = [0 Y Z]; 
   D = [0 (sin(U)) (cos(U))];
end