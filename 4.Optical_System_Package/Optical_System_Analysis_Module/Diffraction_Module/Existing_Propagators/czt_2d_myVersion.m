function xout = czt_2d( xin , scalex , scaley , dimension )
    %___________________________________________________________________________________
    %
    %  Aufruf:
    %  xout = czt_two(xin,scalx,scaly,idir);
    %
    %  Beschreibung:
    %  Berechnung der zweidimensionalen Chirp-z-Transformation mittels Faltung
    %  mit Skalierungsfaktoren scalx bzw. scaly für ein zweidimensionales Feld
    %  xin. Beide Koordinatenschnitte werden unabhängig behandelt.
    %  Das Feld kann rechteckig sein mit Dimensionen npx / npy.
    %  Basis ist die Routine czt aus der Signal-Toolbox von Matlab.
    %  Für scalx/scaly = 1 entsteht die FFT. Die Frequenzachsen werden um die Faktoren
    %  scalx/scaly gespreizt.
    %  Es muß scalx/scaly => 1 gelten.
    %  Die Index-Shiftfunktion ist bereits enthalten, die Frequenz s = 0 liegt beim Index np/2+1.
    %  Es gilt für die Frequenzrasterweite :    ds = 1 / ( npx * dx * scalx )  (y analog)
    %
    
    %% English
    % Calculation of two-dimensional chirp z-transform means convolution
    % With scaling factors scalx or scaly for a two-dimensional field
    % Xin. Both coordinates cuts are treated independently.
    % The field can be rectangular with dimensions npx / NPY.
    % Base is the routine czt from the signal toolbox of Matlab.
    % For scalx / scaly = 1 arises the FFT. The frequency axes are the factors
    % Scalx / spread scaly.
    % It must scalx / scaly apply => 1.
    % The index shift function is included, the frequency of s = 0 is the index np / 2 +1.
    % It applies to the frequency screen width: ds = 1 / (dx * scalx * npx) (dy * scaly * npy)
    %%
    
    %  Version:
    %  23.06.06   Herbert Gross  7.0  Überarbeitete Version
    %
    %  Input:   xin(npx,npy)  : Inputfeld, zweidimensional
    %           scalx         : Lupenfaktor in x-Richtung
    %           scaly         : Lupenfaktor in y-Richtung
    %           idir          : Steuerparameter
    %                           idir = 0 : Transformation in x und y
    %                           idir = 1 : Transformation nur in x-Richtung
    %                           idir = 2 : Transformation nur in y-Richtung
    %
    %  Output:  xout(npx,npy) : Outputfeld, zweidimensional
    %
    %  Abhängigkeiten : keine
    %
    %  Referenzen:
    %  Rabiner, Schafer, Rader, The Chirp z-Transform Algorithm, IEEE Trans AU 17(1969) p. 86
    %
    %  Beispiel: Transformation eines Gaussprofils, verschiedene Punktzahlen und
    %  Spreizungsfaktoren
    %
    %  npx = 256  ; npy = 128 ;
    %  scalx = 8 ;  scaly = 4 ; idir = 0 ;
    %  a = 1; xmax = 2.;xmin = -xmax;
    %  dx = ( xmax-xmin ) / (npx-1); dy = ( xmax-xmin ) / (npy-1);
    %  for j=1:npx ;   x(j) = xmin + (j-1)*dx; end
    %  for k=1:npy ;   y(k) = xmin + (k-1)*dy ; end
    %  [yp xp] = meshgrid(y,x); rp = sqrt(xp.^2+yp.^2);indin = find( rp < a );
    %  xin = zeros(npx,npy,1); xin(indin) = 1 ;
    %  xout = czt_2d( xin , scalx , scaly , idir );
    %  figure(1);
    %  pcolor(abs(xout));shading flat
    %___________________________________________________________________________________
    %
    % Make the output sampling points equal to the input sampling points.
    [ npy,npx ] = size( xin );
    xout = zeros(npx,npy,1);
    
    N_y = npy;
    M_y = npy;
    L_y = N_y + M_y - 1;
    n_y = [0:N_y-1];
    k_y = [0:M_y-1];
    n1_y = L_y-(N_y-1):L_y-1;
    
    N_x = npx;
    M_x = npx;
    L_x = N_x + M_x - 1;
    n_x = [0:N_x-1];
    k_x = [0:M_x-1];
    n1_x = L_x-(N_x-1):L_x-1;
    % A = A0*exp(1i*2*pi*thetha_0);
    % W = W0*exp(1i*2*pi*phi_0);
    % For points on a unit circle A0 = 1; W0 = 1;
    A0 = 1;
    W0 = 1;
    % Frequency spacing is determined by del_omega = 2*pi*phi_0
    phi_0_x = (1/(N_x*scalex));
    del_omega_x = 2*pi*phi_0_x;
    
    phi_0_y = (1/(N_y*scaley));
    del_omega_y = 2*pi*phi_0_y;
    
    % So total bandwidth will be (M-1)*del_omega
    % The initial frequency will be omega_0 = 2*pi*thetha_0
    
    % To get symetric result : frequency sampling centered to zero
    omega_0_x = ((M_x/2)*del_omega_x);
    
    omega_0_y = (M_y*del_omega_y)/2;
    
    A_x = A0*exp(-1i*omega_0_x);
    W_x = W0*exp(-1i*del_omega_x);
    
    A_y = A0*exp(1i*omega_0_y);
    W_y = W0*exp(1i*del_omega_y);
    
    %
    %  x-Direction, dimension == 2
    %
    if dimension == 0 | dimension == 2
        %                         % To be equivalent to FT the points should be on uniformly distributed
        %                         % over unit circle. Their number is scaled by the given scale.
        % Step 2 : Premultiply data.
        ynx = zeros(N_y,L_x);
        ynx(:,1:N_x) = (ones(N_y,1)*(((A_x).^(-n_x)).*((W_x).^((n_x.^2)/2)))).*(xin);
        % Step 3 : Compute FFT
        ft_ynx = fft(ynx,L_x,2);
        % Step 4 :
        vnx = (ones(N_y,1)*([((W_x).^-((k_x.^2)/2)),((W_x).^-(((fliplr(n_x)).^2)/2))]));
        % Step 5 :
        ft_vnx = fft(vnx,L_x,2);
        % Step 6 :
        ft_Gnx = ft_ynx.*ft_vnx;
        % Step 7 :
        gkx = ifft(ft_Gnx,L_x,2);
        % Step 8 : Final multiply.
        Xkx = (ones(N_y,1)*(((W_x).^-((k_x.^2)/2)))).*gkx(:,1:M_x);
        xout = Xkx;
    else
        xout = xin ;
    end
    %
    %  y-Direction, dimension = 1
    %
    if dimension == 0 | dimension == 1
        %
        % Step 2
        yny = zeros(L_y,N_x);
        yny(1:N_y,:) = ((((A_y).^(-n_y)).*((W_y).^((n_y.^2)/2)))'*ones(1,N_x)).*(xout);
        % Step 3
        ft_yny = fft(yny,L_y);
        % Step 4
        vny = (([((W_y).^-((k_y.^2)/2)),((W_y).^-(((fliplr(n_y)).^2)/2))])'*ones(1,N_x));
        % Step 5
        ft_vny = fft(vny,L_y);
        % Step 6
        ft_Gny = ft_yny.*ft_vny;
        
        % Step 7
        gky = ifft(ft_Gny,L_y);
        % Step 8
        Xky = ((((W_y).^-((k_y.^2)/2)))'*ones(1,N_x)).*gky(1:M_y,:);
        xout = Xky;
    end
    xout = (xout);
