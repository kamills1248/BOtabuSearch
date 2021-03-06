global R; global Z; global D; global poz_cz; global B; global S; global Ep;
global E_max; global poz_bud; global nazwa_budynku; global nazwa_rest;
global nazwa_zestawu; global kwadrans_akademicki;

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;


% BUDYNKI
nazwa_budynku = {   'B1';
                    'C1';
                    'C2';
                    'C3';
                    'D8'};

% nowe wspolzedne budynkow na planie
poz_bud = [ 618, 154;  %B1
            795, 145;  %C1
            763, 115;  %C2
            723, 113;  %C3
            190, 271]; %D8
         
B1 = 1; C1 = 2; C2 = 3; C3 = 4; D8 = 5;


% RESTAURACJE
% ponizej dwa wektory nazw, zwroccie uwage ze sa w nawiasach klamrowych 
% { } oraz, ze kazdy element macierzy musi miec tyle samo znakow
nazwa_rest = {'Dagrasso  ';
              'Krakus    ';
              'Tawo      ';
              'Nawojka   ';
              'Labirynt  ';
              'PastaMasta';
              'Kebab     ';
              'Lemon     ';
              'Zaczek    ';
              'Barek     '};
                
%       x   y    ocena    c1    t1    c2    t2   c3   t3    c4    t4  
r1 = [ 352,   93,   8,    25,   20,   16,   15, 1000, 100, 1000,  100;  %Dagrasso
       519,  260,   6,  1000,  100,    8,    2,   10,   3,   10,   3 ;  %Krakus
       526,  217,   7,  1000,  100,   10,    5,    9,   2,    9,   2 ;  %Tawo
       584,  277,   4,  1000,  100,    9,    3,   11,   4,   11,   4 ;  %Nawojka
       616,  175,   3,  1000,  100,    7,    8,   15,   5, 1000, 100 ;  %Labirynt
       604,   47,   8,  1000,  100,   15,    5, 1000, 100, 1000, 100 ;  %PastaMasta
       659,   51,   7,    22,   20, 1000,  100, 1000, 100, 1000, 100 ;  %Kebab
       693,   99,   8,    30,   15,   20,    8,   15,   8,   16,   7 ;  %Lemon
       851,  352,   4,  1000,  100,   11,    4,   12,   5,   12,   4 ;  %Zaczek
       779,  115,   2,  1000,  100, 1000,  100,    8,   6,   10,   7];  %Barek
        
%       c5     t5   c6    t6   c7    t7    c8    t8   c9   t9   c10   t10
r2 = [ 1000,  100,    5,   2,    7,   5,    6,    4, 1000, 100, 1000, 100  ;  %Dagrasso
       1000,  100,    4,   1, 1000, 100, 1000,  100,   10,   2, 1000, 100  ;  %Krakus
       1000,  100,    3,   1, 1000, 100, 1000,  100,    9,   3, 1000, 100  ;  %Tawo
       1000,  100,    4,   2, 1000, 100, 1000,  100,   10,   2, 1000, 100  ;  %Nawojka
          9,    7,    3,   2,    6,   5,    5,    4,    8,   5,    2,   1  ;  %Labirynt
       1000,  100, 1000, 100, 1000, 100, 1000,  100, 1000, 100,    3,   1  ;  %PastaMasta
         12,    5, 1000, 100,    8,   3,    7,    4, 1000, 100, 1000, 100  ;  %Kebab
       1000,  100,    5,   3,    7,   4, 1000,  100, 1000, 100,    4,   1  ;  %Lemon
       1000,  100,    3,   2, 1000, 100, 1000,  100,    9,   4, 1000, 100  ;  %Zaczek
       1000,  100,    4,   3, 1000, 100,    8,    5,    9,   8,    3,   1 ];  %Barek
        
R = [r1, r2];

% licze ilosc restauracji
size_R = size(R);
ilosc_rest = size_R(1);


% ZESTAWY
% ponizej dwa wektory nazw, zwroccie uwage ze sa w nawiasach klamrowych 
% { } oraz, ze kazdy element macierzy musi miec tyle samo znakow
nazwa_zestawu = {   'pizza            ';
                    'makaron          ';
                    'mieso & ziemniaki';
                    'ryba & ryz       ';
                    'kebab            ';
                    'zupa             ';
                    'burger           ';
                    'zapiekanka       ';
                    'pierogi          ';
                    'precel/drozdzowka'};

%       z1     z2    z3    z4    z5    z6    z7    z8    z9   z10
Z = [   600,  405,  800,  600,  820,  200,  400,  350,  650,  100  ;  %kcal
         20,   10,   13,   15,   10,    4,    8,    5,   10,    3  ;  %czas konsumpcji
          9,    8,    7,    6,    9,    4,    6,    3,    5,    2 ];  %ocena
   
% licze ilosc zestawow
size_Z = size(Z);
ilosc_zestawow = size_Z(2);
      
      
% budzet tygodniowy
B = 120;


% energia poczatkowa
Ep = 700;


% "pelnosc brzucha"
E_max = 1000; %energia, ktora maksymalnie na raz mozna miec w sobie


% sloty czasowe
%      dz1     dz2     dz3     dz4     dz5
S = [   30,     20,     25,     15,     30 ;  %slot 1 od 10
        45,     60,     90,     50,     60 ;  %slot 2 od 13
        15,     20,     15,     35,     15];  %slot 3 od 16:30

kwadrans_akademicki = 15;
    
    
% macierz odleglosci knajp od budynkow z zajeciami
% restauracje \ budynki
D = [(abs(R(:,1) - poz_bud(1,1)) + abs(R(:,2) - poz_bud(1,2))),...
     (abs(R(:,1) - poz_bud(2,1)) + abs(R(:,2) - poz_bud(2,2))),...
     (abs(R(:,1) - poz_bud(3,1)) + abs(R(:,2) - poz_bud(3,2))),...
     (abs(R(:,1) - poz_bud(4,1)) + abs(R(:,2) - poz_bud(4,2))),...
     (abs(R(:,1) - poz_bud(5,1)) + abs(R(:,2) - poz_bud(5,2)))];

% dziele przez 60, poniewaz mapa ma rozmiar 360x900 a zalozylismy, ze
% przejscie jej z zachodu na wschod zajmuje 15 minut, no i 900/15=60 
D = D./60;


%  polozenie przed i po slocie
%            dz1     dz2     dz3     dz4     dz5
poz_cz = [   B1,     C1,     B1,     D8,     C3 ;  %przed slot 1 przed 10
             B1,     C1,     C2,     B1,     C2 ;  %po slot 1 przed 13
             C1,     D8,     B1,     B1,     C1 ;  %po slot 2 po 13
             C2,     B1,     C3,     B1,     B1];  %po slot 3 po 16:30
         
% licze ilosc dni
size_poz_cz = size(poz_cz);
ilosc_dni = size_poz_cz(2);
