function [ I1,I2 ] = getReferencePointIndices( harmonicField )
%GETREFERENCEPOINTINDICES returns the ref. points indices which are used
%for forexample OPD computation as cheif ray index

  Ex = harmonicField.ComplexAmplitude(:,:,1);
  n1 = size(Ex,1); 
  n2 = size(Ex,2);
  I1 = floor(n1/2);
  I2 = floor(n2/2);
end

