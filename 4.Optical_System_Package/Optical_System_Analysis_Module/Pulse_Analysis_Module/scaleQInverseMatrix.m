function [ scaledQinv ] = scaleQInverseMatrix( QInverseInSI )
%SCALEQINVERSEMATRIX Scales the Qinv matrix to distance unit of mm and time
%unit of fs

tempQinv = QInverseInSI;
% change the unit of Qin11 from 1/m  to 1/mm
tempQinv(1,1) = tempQinv(1,1)*10^-3;
% change the unit of Qin22 from m/s^2  to mm/fs^2 =
tempQinv(2,2) = tempQinv(2,2)*10^-27;
% change the unit of Qin12 and Qin21  from 1/s  to 1/fs =
tempQinv(1,2) = tempQinv(1,2)*10^-15;
tempQinv(2,1) = tempQinv(2,1)*10^-15;
scaledQinv = tempQinv;
end

