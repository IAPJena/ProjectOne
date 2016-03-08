function [ QInverseMatrixInSI ] = convertScaledQInverseMatrixToSI( scaledQInverse )
%CONVERTSCALEDQINVERSEMATRIXTOSI converts Qinverse matrix from scaled units
%(mm and fs) to SI units (m and s)

tempQinv = scaledQInverse;
% change the unit of Qin11 from  1/mm  to 1/m
tempQinv(1,1) = tempQinv(1,1)*10^3;
% change the unit of Qin22 from mm/fs^2 to m/s^2
tempQinv(2,2) = tempQinv(2,2)*10^27;
% change the unit of Qin12 and Qin21  from  1/fs to 1/s
tempQinv(1,2) = tempQinv(1,2)*10^15;
tempQinv(2,1) = tempQinv(2,1)*10^15;
QInverseMatrixInSI = tempQinv;
end

