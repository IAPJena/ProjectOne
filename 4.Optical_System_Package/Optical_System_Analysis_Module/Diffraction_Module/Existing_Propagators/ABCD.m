
function M = ABCD(varargin)

%______________________________________________________________________________________________________________________
%
% Copyright by Carl Zeiss AG    
% Confidence: OD internal          
%
% Aufruf:
% M = ABCD(typ,parameterlist);
% M = ABCD(typ1,param1,typ2,param2,...);
% Mges = ABCD(M1,M2,M3);
% M = ABCD('dis',L); 
% M = ABCD('lens',f); 
% M = ABCD('lens',n1,n2,R1,R2,d); 
% M = ABCD('dis',50,'lens',50,'dis',75);
% m = ABCD('surf',1,1.5,50,'dist',10,'surf',1.5,1,-50) 
%           % dicke Linse radien 50, Dicke 10, Brechzahl 1.5 
% m = ABCD('lens',1,1.5,50,-50,10) % dicke Linse wie vor
%
% Schlagworte:
% ABCD, matrix, matrix, paraxial element, paraxial system, propagation, raytrace   
%
% Kurzbeschreibung:
% Rückgabe der ABCD-Strahlmatrizen für das gewünschte Element oder die Elemet-Folge    
%
% Beschreibung:
% Rückgabe der ABCD-Strahlmatrizen für das gewünschte Element. Es gilt   
%   (x'  )    (      ) ( x  )
%   (alf') =  (   M  ) ( alf)
% Bei mehreren Elementen beginnt die Eingabe mit dem Element, auf das der
% Strahl zuerst trifft. Bei Vorliegen von Strahlmatrizen am Input wird die
% Gesamtmatrix zurückgegeben. 
%
% Version:
% 27.04.2008    Beate Böhme Matlab 7.3.0 
% 15.06.2008    Erweiterungen 
% 29.09.2008    Erweiterung Schlüsselwort dist = dis 
% Owner: 	 Beate Böhme 
%
% Input:   
%               typ         P  
% Frei-Raum     'dis'      L               mit konstanter Brechzahl
% Grenzfläche   'surf'      n1,n2,(R)       von n1 nach n2 mit Radius R 
%                                           R>0 Mittelpunkt bei größeren z 
%                                           für R=Inf Angabe nicht notwendig   
% Planplatte    'plate'     n1,n2, L        n1 umgebendes Medius  
% dünne Linse   'lens'      f               Brennweite 
% dicke Linse   'lens'      n1,n2,R1,R2,d   umgebendes Medium n1, Dicke d 
%                                           bikonvex: R1>0, R2<0
%                                           beachte Druckfehler in Gross, Bd1, S47    
% Spiegel       'mirror'    R               Radius 
% Teleskop      'telescope' f1,f2           Teleskop mit d = f1+f2
% Gradienten-Medium 'gardient'  L, Gam      L = Dicke des Mediums, Gam 
%                                           n(r)=n0(1 - Gam^2*r^2/2); 
%                                           vgl. Gross, Bd 1, S 46
% 
%
% Output:   
%           M(2,2)          : Strahlmatrix
%
% Abhängigkeiten in 1. Ordnung: --
% Referenzen: --
% Beispiel: --
% Testfile: --
% ToDo: Vorzeichen kontrollieren, 4-dim.  
%____________________________________________________________________________________________________________________

fl = 0; % Kontroll-Flag
M0 = [1 0 ; 0 1]; 

% Liegen am Input nur Matrizen vor ?? 
m=0; for k=1:nargin; if ~isstr(varargin{k}); m=m+1; end; end; 
if nargin == m; % ja !! falls nur matrizen am Input, diese multiplizieren !
    for k=1:nargin
        M = varargin{k}; 
        if size(M,1) ~= 2 | size(M,2) ~= 2; error('keine 2x2-Matrix am Input'); end; 
        M0 = M*M0;
    end; 
else 
    for k = 1:nargin
        if strcmp(varargin{k},'dist') | strcmp(varargin{k},'dis')
            L = varargin{k+1}; 
            M = [ 1 L; 0 1]; fl = 1; 
        elseif strcmp(varargin{k},'surf')
            n1 = varargin{k+1}; 
            n2 = varargin{k+2};
            try; R  = varargin{k+3}; catch; R=Inf; end;  
            C = (n1-n2)/n2/R; 
            D = n1/n2;
            M = [1 0 ; C D]; fl = 1; 
        elseif strcmp(varargin{k},'plate')
            n1 = varargin{k+1}; 
            n2 = varargin{k+2};
            L  = varargin{k+3}; 
            B  = L*n1/n2; 
            M = [1 B; 0 1]; fl = 1; 
        elseif strcmp(varargin{k},'mirror')
            R = varargin{k+1}; 
            M = [1 0; 2/R 1]; fl = 1; 
        elseif strcmp(varargin{k},'lens')
            % if isstr(varargin{k+2})      % dünne Linse: noch 1 parameter, dann strig 
            if nargin-k == 1 | (nargin-k>1 & isstr(varargin{k+2}));        
                f = varargin{k+1}; 
                M = [1 0; -1/f 1]; fl = 1; 
            % elseif isstr(varargin{k+6})  % dicke Linse: noch 5 paramter, dann string 
            elseif nargin-k == 5 | (nargin-k>5 & isstr(varargin{k+6}));    
                n1 = varargin{k+1}; 
                n2 = varargin{k+2};
                R1 = varargin{k+3};          
                R2 = varargin{k+4};
                d  = varargin{k+5}; 
                A = 1 - (n2-n1)*d/n2/R1; 
                B = n1*d/n2; 
                 fm1 = (n2-n1)*(1/R2 - 1/R1)/n1;
                 fm2 = (n2-n1)^2*d/n1/n2/R1/R2; 
                C = fm1 - fm2; 
                D = 1 + (n2-n1)*d/n2/R2;
                M = [A B ; C D ]; fl = 1; 
            end; 
        elseif strcmp(varargin{k},'telescope')
            f1 = varargin{k+1}; 
            f2 = varargin{k+2};
            M = [-f2/f1   f1+f2; 0 -f1/f2];  fl = 1; 
        elseif strcmp(varargin{k},'gradient')
            par1 = varargin{k+1}; par2=varargin{k+2}; 
            m1 = cos(par1*par2) ;
            m2 = sin(par1*par2)/par2 ;
            m3 = - m2;
            m4 = m1;
            M  = [m1 m2; m3 m4]; fl = 0; 
        end;   
        if fl == 1; 
            M0 = M*M0; fl = 0;
        end; 
    end; 
end; 

M = M0; % Rückgabe 
