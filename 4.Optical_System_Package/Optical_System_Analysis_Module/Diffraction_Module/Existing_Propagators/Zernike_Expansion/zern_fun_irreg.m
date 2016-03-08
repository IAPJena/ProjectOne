function zern_fun = zern_fun_irreg(nzern,xp,yp,a)
%___________________________________________________________________________________
%
%  Aufruf :  zern_fun = zern_fun_kart_gen(nzern,xp,yp,a)
%
%  Berechnung der Zernikefunktionen auf einem beliebigen
% irregulären Koordinatenraster.
%  Die Koordinaten müssen nicht auf 1 normiert sein, das wird
%  intern besorgt.
%  Es sind maximal 64 Zernikes berücksichtigt
%
%  Version :  2010-04-03   H. Gross
%___________________________________________________________________________________
%
%  Input :  nzern     : Maximal gewünschter Index, es sind grundsätzlich 
%                       Quadratzahlen 9 , 16 , 25 , 36 , 49 , 64  zu wählen
%                       oder maximal 66
%
%           xp(np)   : x-Koordinatenvektor absolut
%                       intern werden die Koordinaten auf den maximalen Wert a normiert
%           yp(np)   : y-Koordinatenvektor absolut
%                       intern werden die Koordinaten auf den maximalen Wert a normiert
%           a         : Normierungsradius
%
%
%  Output : zern_fu(np,nzern)   : Zernikefunktionen bis zur Ordnung nzern auf dem 
%                       Einheitskreis für die normierten Koordinaten 
%___________________________________________________________________________________
%
%  Koordinaten normieren, x und y getrennt
%


% Call: zern_fun = zern_fun_kart_gen (NOTE s, p, y p, a) 
% 
% Calculation of the Zernike functions on any 
% Irregular grid coordinates. 
%, The coordinates do not need to be normalized to 1, which is 
% Worried internally. 
% There are a maximum of 64 Zernike account


np = length( xp );xpa = xp / a ; ypa = yp / a ;
%
%  Festlegen der Koeffizientenzahl auf eine Quadratzahl
%
if nzern <= 64 & nzern > 49 ; nzern = 64 ; end
if nzern <= 49 & nzern > 36 ; nzern = 49 ; end
if nzern <= 36 & nzern > 25 ; nzern = 36 ; end
if nzern <= 25 & nzern > 16 ; nzern = 25 ; end
if nzern <= 16 & nzern >  9 ; nzern = 16 ; end
if nzern <=  9  ; nzern = 9 ; end
%
zern_fun = zeros(np,nzern,1);
%
   xpq = xpa.^2 ;
   ypq = ypa.^2 ;
   rpq = xpq + ypq ; 
   xpv = xpq.^2 ;      
   ypv = ypq.^2 ;
	xps = xpq.^3;
   yps = ypq.^3;
   rpq = xpq + ypq  ;
   rpv = rpq.^2 ; 
   rps = rpq.^3;
      %
         zern_fun(:,1)  = 1. ;                                %  Offset
         zern_fun(:,2)  = ypa ;                               %  Kipp y
         zern_fun(:,3)  = xpa ;                               %  Kipp x
         zern_fun(:,4)  = 2.*rpq - 1;                          %  Defokus
         zern_fun(:,5)  = ypq - xpq ;                         %  Astigmatismus
         zern_fun(:,6)  = 2.* xpa.* ypa ;                      %  Astigmatismus
         zern_fun(:,7)  = ypa .* ( 3.*rpq - 2 ) ;               %  Koma
         zern_fun(:,8)  = xpa .* ( 3.*rpq - 2  ) ;              %  Koma
         zern_fun(:,9)  = 6.*rpv - 6.*rpq + 1;                  %  Sphärisch
 %
if nzern > 9
         zern_fun(:,10) = ypa .* ( ypq - 3.*xpq ) ;             %  Dreiblatt
         zern_fun(:,11) = xpa .* ( 3.*ypq - xpq ) ;             %  Dreiblatt
         zern_fun(:,12) = ( ypq - xpq ).*( 4.*rpq - 3 ) ;       %  Astigmatismus 5. Ord
         zern_fun(:,13) = 2.*xpa.*ypa.*( 4.*rpq - 3 ) ;           %  Astigmatismus 5. Ord 
         zern_fun(:,14) = ypa.*( 10.*rpv -12.*rpq + 3 ) ;        %  Koma 5. Ord
         zern_fun(:,15) = xpa.*( 10.*rpv -12.*rpq + 3 ) ;        %  Koma 5. Ord
         zern_fun(:,16) = 20.*rps - 30.*rpv + 12.*rpq - 1 ;      %  Sphärisch 5. Ord
end
 %
if nzern > 16    
         zern_fun(:,17) = ypv+xpv-6.*xpq.*ypq;                  %  Vierblatt
         zern_fun(:,18) = 4.*xpa.*ypa.*(ypq-xpq);                %  Vierblatt
         zern_fun(:,19) = (5.*rpq-4).*ypa .* ( ypq - 3.*xpq  );
         zern_fun(:,20) = (5.*rpq-4).*xpa .* ( 3.*ypq - xpq  );
         zern_fun(:,21) = (15.*rpv-20.*rpq+6).*(ypq-xpq);
         zern_fun(:,22) = (15.*rpv-20.*rpq+6).*2.*xpa.*ypa;
         zern_fun(:,23) = (35.*rps-60.*rpv+30.*rpq-4).*ypa;
         zern_fun(:,24) = (35.*rps-60.*rpv+30.*rpq-4).*xpa;
         zern_fun(:,25) = 70.*rpq.^4-140.*rps+90.*rpv-20.*rpq+1;
end
 %
if nzern > 25
         zern_fun(:,26) = ypa.*(5.*xpv-10.*ypq.*xpq+ypv);
         zern_fun(:,27) = xpa.*(5.*ypv-10.*ypq.*xpq+xpv);
         zern_fun(:,28) = (6.*rpq-5).*(xpv+ypv-6.*xpq.*ypq);
         zern_fun(:,29) = (6.*rpq-5).*4.*xpa.*ypa.*(ypq-xpq);
         zern_fun(:,30) = (21.*rpv-30.*rpq+10).*ypa.*( ypq - 3.*xpq);
         zern_fun(:,31) = (21.*rpv-30.*rpq+10).*xpa.*(3.*ypq-xpq);
         zern_fun(:,32) = (56.*rps-105.*rpv+60.*rpq-10).*(ypq-xpq);
         zern_fun(:,33) = (56.*rps-105.*rpv+60.*rpq-10).*2.*xpa.*ypa;
         zern_fun(:,34) = (126.*rpv.^2-280.*rps+210.*rpv-60.*rpq+5).*ypa;
         zern_fun(:,35) = (126.*rpv.^2-280.*rps+210.*rpv-60.*rpq+5).*xpa;
         zern_fun(:,36) = 252.*rpq.^5-630.*rpq.^4+560.*rps-210.*rpv+30.*rpq-1;
end
%
if nzern > 36
         zern_fun(:,38) = ypa.*xpa.*( 6.*ypv-20.*ypq.*xpq+6.*xpv);
         zern_fun(:,37) = yps-15.*ypv.*xpq+15.*ypq.*xpv-xps;
         zern_fun(:,40) = xpa.*( 7.*xps-63.*xpv.*ypq-6.*xpv-35.*xpq.*ypv+60.*xpq.*ypq+35.*yps-30.*ypv );
         zern_fun(:,39) = ypa.*( 35.*xps-35.*xpv.*ypq-30.*xpv-63.*xpq.*ypv+60.*xpq.*ypq+7.*yps-6.*ypv );
         zern_fun(:,42) = xpa.*ypa.*( 112.*yps+112.*xpq.*ypv-112.*xpv.*ypq-168.*ypv+60.*ypq-112.*xps...
                           +168.*xpv-60.*xpq );
         zern_fun(:,41) = 28.*yps.*ypq-112.*xpq.*yps-280.*xpv.*ypv-42.*yps+210.*xpq.*ypv+15.*ypv-112.*xps.*ypq...
                          +210.*xpv.*ypq-90.*xpq.*ypq+28.*xpv.*xpv-42.*xps+15.*xpv ;
         zern_fun(:,44) = xpa.*( 252.*ypv.*ypv+672.*xpq.*yps+504.*xpv.*ypv-504.*yps-840.*xpq.*ypv...
                           -168.*xpv.*ypq+315.*ypv+210.*xpq.*ypq-60.*ypq-84.*xps.*xpq+168.*xps-105.*xpv...
                           +20.*xpq );
         zern_fun(:,43) = ypa.*( 84.*yps.*ypq-504.*xpv.*ypv-672.*xps.*ypq-168.*yps+168.*xpq.*ypv...
                           +840.*xpv.*ypq+105.*ypv-210.*xpq.*ypq-20.*ypq-252.*xpv.*xpv+504.*xps-315.*xpv...
                           +60.*xpq );
         zern_fun(:,46) = xpa.*ypa.*( 420.*ypv.*ypv+1680.*xpq.*yps+2520.*xpv.*ypv+1680.*xps.*ypq+420.*xpv.*xpv...
                           -1008.*yps-3024.*xpq.*ypv-3024.*xpv.*ypq-1008.*xps+840.*ypv+1680.*xpq.*ypq...
                           +840.*xpv-280.*ypq-280.*xpq+30 );
         zern_fun(:,45) = 210.*yps.*ypv+630.*xpq.*ypv.*ypv+1260.*xpv.*yps-420.*xps.*ypv-630.*xpv.*xpv.*ypq...
                           -504.*ypv.*ypv-1008.*xpq.*yps+1008.*xps.*ypq+420.*yps+420.*xpq.*ypv-420.*xpv.*ypq...
                           -140.*ypv+15.*ypq-840.*xpv.*yps-210.*xpv.*xps+504.*xpv.*xpv-420.*xps+140.*xpv-15.*xpq ;
         zern_fun(:,48) = xpa.*( 462.*xps.*xpv+xps.*xpq.*(2310.*ypq-1260)+xps.*(4620.*ypv-5040.*ypq+1260)...
                           +xpv.*(4620.*yps-7560.*ypv+3780.*ypq-560)+xpq.*(2310.*ypv.*ypv-5040.*yps...
                           +3780.*ypv-1120.*ypq+105)+462.*yps.*ypv-1260.*ypv.*ypv+1260.*yps-560.*ypv...
                           +105.*ypq-6 );
         zern_fun(:,47) = ypa.*( 462.*yps.*ypv+yps.*ypq.*(2310.*xpq-1260)+yps.*(4620.*xpv-5040.*xpq+1260)...
                           +ypv.*(4620.*xps-7560.*xpv+3780.*xpq-560)+ypq.*(2310.*xpv.*xpv-5040.*xps...
                           +3780.*xpv-1120.*xpq+105)+462.*xps.*xpv-1260.*xpv.*xpv+1260.*xps-560.*xpv...
                           +105.*xpq-6 );
         zern_fun(:,49) = 924.*rps.*rps-2772.*rps.*rpv+3150.*rpv.*rpv-1680.*rps+420.*rpv-42.*rpq+1;
end
%
if nzern > 49
         zern_fun(:,51) = xpa.*(-xps+21.*xpv.*ypq-35.*xpq.*ypv+7.*yps);
         zern_fun(:,50) = ypa.*(-7.*xps+35.*xpv.*ypq-21.*xpq.*ypv+yps);
         zern_fun(:,53) = xpa.*ypa.*( 48.*yps-42.*ypv-112.*xpq.*ypv-112.*xpv.*ypq+140.*xpq.*ypq...
                           +48.*xps-42.*xpv );
         zern_fun(:,52) = -8.*xpv.*xpv+7.*xps+8.*ypv.*ypv-7.*yps-112.*xpq.*yps+105.*xpq.*ypv...
                           +112.*xps.*ypq-105.*xpv.*ypq;
         zern_fun(:,55) = xpa.*( 180.*ypv.*ypv-504.*xpv.*ypv-288.*xps.*ypq+36.*xpv.*xpv...
                            -280.*yps+280.*xpq.*ypv+504.*xpv.*ypq-56.*xps+105.*ypv...
                            -210.*xpq.*ypq+21.*xpv );
         zern_fun(:,54) = ypa.*( 36.*ypv.*ypv-504.*xpv.*ypv-288.*xpq.*yps-56.*yps+504.*xpq.*ypv...
                           +280.*xpv.*ypq-210.*xpq.*ypq+180.*xpv.*xpv-280.*xps+105.*xpv +21.*ypv);
         zern_fun(:,57) = xpa.*ypa.*( 480.*ypv.*ypv+960.*xpq.*yps-960.*xps.*ypq-480.*xpv.*xpv...
                            -1008.*yps-1008.*xpq.*ypv+1008.*xpv.*ypq+1006.*xps...
                            +672.*ypv-672.*xpv-140.*ypq+140.*xpq);
         zern_fun(:,56) = 120.*yps.*ypv-360.*xpq.*ypv.*ypv-1680.*xpv.*yps-252.*ypv.*ypv...
                           +1008.*xpq.*yps+2520.*xpv.*ypv+168.*yps-840.*xpq.*ypv-35.*ypv...
                           -1680.*xps.*ypv-360.*xpv.*xpv.*ypq+1008.*xps.*ypq-840.*xpv.*ypq...
                           +210.*xpq.*ypq+120.*xps.*xpv-252.*xpv.*xpv+168.*xps-35.*xpv;
         zern_fun(:,59) = xpa.*( -330.*xps.*xpv+xpv.*xpv.*( -330.*ypq+840)+xps.*(1980.*ypv...
                           -756)+xpv.*(4620.*yps-5040.*ypv+756.*ypq+280)+xpq.*(3630.*ypv.*ypv...
                           -6720.*yps+3780.*ypv-560.*ypq-35)+990.*yps.*ypv-2520.*ypv.*ypv...
                           +2268.*yps-840.*ypv+105.*ypq );
         zern_fun(:,58) = ypa.*( -990.*xps.*xpv+xpv.*xpv.*(-3630.*ypq+2520)+xps.*(-4620.*ypv...
                           +6720.*ypq-2268)+xpv.*(-1980.*yps+5040.*ypv-3780.*ypq+840)...
                           +xpq.*(330.*ypv.*ypv-756.*ypv+560.*ypq-105)+330.*yps.*ypv...
                           -840.*ypv.*ypv+756.*yps-280.*ypv+35.*ypq );
         zern_fun(:,61) = xpa.*ypa.*( 1584.*xps.*xpv+xpv.*xpv.*(7920.*ypq-4620)+xps.*(15840.*ypv...
                           -18480.*ypq+5040)+xpv.*(15840.*yps-27720.*ypv+15120.*ypq-2520)...
                           +xpq.*(7920.*ypv.*ypv-18480.*yps+15120.*ypv-5040.*ypq+560)...
                           +1584.*yps.*ypv-4620.*ypv.*ypv+5040.*yps-2520.*ypv+560.*ypq-42 );
         zern_fun(:,60) = 792.*yps.*yps+3168.*xpq.*yps.*ypv+3960.*xpv.*ypv.*ypv-3960.*xpv.*xpv.*ypv...
                            -3168.*xps.*xpv.*ypq-792.*xps.*xps-2310.*yps.*ypv-6930.*xpq.*ypv.*ypv...
                            -4620.*xpv.*yps+4620.*xps.*ypv+6930.*xpv.*xpv.*ypq+2310.*xps.*xpv...
                            +2520.*ypv.*ypv+5040.*xpq.*yps-5040.*xps.*ypq-2520.*xpv.*xpv...
                            -1260.*yps-1260.*xpq.*ypv+1260.*xpv.*ypq+1260.*xps+280.*ypv-280.*xpv...
                            -21.*ypq+21.*xpq ;
         zern_fun(:,63) = xpa.*( 1716.*xps.*xps+xps.*xpv.*(10298.*ypq-5544)+xpv.*xpv.*(25740.*ypv...
                           -27720.*ypq+6930)+xps.*(34320.*yps-55440.*ypv+27720.*ypq-4200)...
                           +xpv.*(25740.*ypv.*ypv-55440.*yps+41580.*ypv-12600.*ypq+1260)...
                           +xpq.*(10296.*yps.*ypv-27720.*ypv.*ypv+27720.*yps-12600.*ypv...
                           +2520.*ypq-168)+1716.*yps.*yps-5544.*yps.*ypv+6930.*ypv.*ypv...
                           -4200.*yps+1260.*ypv-168.*ypq+7 );
         zern_fun(:,62) = ypa.*( 1716.*xps.*xps+xps.*xpv.*(10296.*ypq-5544)+xpv.*xpv.*(25740.*ypv...
                           -27720.*ypq+6930)+xps.*(34320.*yps-55440.*ypv+27720.*ypq-4200)...
                           +xpv.*(25740.*ypv.*ypv+41580.*ypv-12600.*ypq-55440.*yps+1260)...
                           +xpq.*(10296.*yps.*ypv-27720.*ypv.*ypv+27720.*yps-12600.*ypv...
                           +2520.*ypq-168)+1716.*yps.*yps-5544.*yps.*ypv+6930.*ypv.*ypv...
                           -4200.*yps+1260.*ypv-168.*ypq+7 );
         zern_fun(:,64) = 3432.*rps.*rpv.*rpv-12012.*rps.*rps+16632.*rps.*rpv-11550.*rpv.*rpv...
                           +4200.*rps-756.*rpv+56.*rpq-1 ;
end;                        
%
ind = find(rpq > 1); 
for k = 1: nzern
   help = zern_fun(:,k);
   help(ind) = 0.;
   zern_fun(:,k) = help; 
end; 
