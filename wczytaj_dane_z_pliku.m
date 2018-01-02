global R; global Z; global D; global poz_cz; global B; global S; global Ep;
global E_max; global poz_bud; global nazwa_budynku; global nazwa_rest;
global nazwa_zestawu; global kwadrans_akademicki

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;

% WCZYTYWANE DANE:
% macierz restauracji (wiersze: kolejne restauracje, kolumny: dwie pierwsze 
% to polozenie (x,y), trzecia to ocena restauracji (1-10), nastepne to 
% parami zestawy (cena i czas wykonania)

% zestawy (wiersze: kcal, czas konsumpcji, ocena, kolumny: kolejne zestawy)

% sloty czasowe - dlugosci (kolumny: kolejne dni, wiersze: sloty kolejno: 
% slot 1 od 10, slot 2 od 13, slot 3 od 16:30)

% polozenie czlowieka przed i po slocie (kolumny: kolejne dni, wiersze:
% polozenie kolejno: przed slot 1 przed 10, po slot 1 przed 13, po slot 2
% po 13, po slot 3 po 16:30)

% DANE RZECZYWISTE
% load testy\dane_testowe_rzeczywiste_r10_z10_d5\R.txt -ascii
% load testy\dane_testowe_rzeczywiste_r10_z10_d5\Z.txt -ascii
% load testy\dane_testowe_rzeczywiste_r10_z10_d5\S.txt -ascii
% load testy\dane_testowe_rzeczywiste_r10_z10_d5\poz_cz.txt -ascii

% Rest = 4, Zest = 7, Dni = 5
% load testy\dane_testowe_r4_z7_d5\R_4.txt -ascii
% load testy\dane_testowe_r4_z7_d5\Z_7.txt -ascii
% load testy\dane_testowe_r4_z7_d5\S.txt -ascii
% load testy\dane_testowe_r4_z7_d5\poz_cz.txt -ascii
% R = R_4; Z = Z_7;

% Rest = 4, Zest = 7, Dni = 5; BEZ '1000' w R
% load testy\dane_testowe_r4_z7_d5_bez_1000\R_4_bez_1000.txt -ascii
% load testy\dane_testowe_r4_z7_d5_bez_1000\Z_7.txt -ascii
% load testy\dane_testowe_r4_z7_d5_bez_1000\S.txt -ascii
% load testy\dane_testowe_r4_z7_d5_bez_1000\poz_cz.txt -ascii
% R = R_4_bez_1000; Z = Z_7;

% Rest = 1, Zest = 1, Dni = 5
% load testy\dane_testowe_r1_z1_d5\R_1.txt -ascii
% load testy\dane_testowe_r1_z1_d5\Z_1.txt -ascii
% load testy\dane_testowe_r1_z1_d5\S.txt -ascii
% load testy\dane_testowe_r1_z1_d5\poz_cz.txt -ascii
% R = R_1; Z = Z_1;

% Rest = 10, Zest = 10, Dni = 10
% Pamietac, zeby zwiekszyc budzet!
load testy\dane_testowe_r10_z10_d10\R.txt -ascii
load testy\dane_testowe_r10_z10_d10\Z.txt -ascii
load testy\dane_testowe_r10_z10_d10\S_d10.txt -ascii
load testy\dane_testowe_r10_z10_d10\poz_cz_d10.txt -ascii
S = S_d10; poz_cz = poz_cz_d10;

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

% licze ilosc restauracji
size_R = size(R);
ilosc_rest = size_R(1);


% ZESTAWY
% ponizej dwa wektory nazw, zwroccie uwage ze sa w nawiasach klamrowych 
% { } oraz, ze kazdy element macierzy musi miec tyle samo znakow
nazwa_zestawu = {   'Pizza            ';
                    'Makaron          ';
                    'Miêso & ziemniaki';
                    'Ryba & ry¿       ';
                    'Kebab            ';
                    'Zupa             ';
                    'Burger           ';
                    'Zapiekanka       ';
                    'Pierogi          ';
                    'Precel/dro¿d¿ówka'};

% licze ilosc zestawow
size_Z = size(Z);
ilosc_zestawow = size_Z(2);
      

% SPRAWDZENIE WYMIAROW MACIERZY:
if(((size_R(2) - 3)/2) > size_Z(2))
   error('Error: W macierzy restauracji jest wiêcej zestawów ni¿ w macierzy zestawów');
end

% budzet tygodniowy
% B = 120;
B = 240; %budzet na 10 dni

% energia poczatkowa
Ep = 700;


% "pelnosc brzucha"
E_max = 1000; %energia, ktora maksymalnie na raz mozna miec w sobie

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

% licze ilosc dni
size_poz_cz = size(poz_cz);
ilosc_dni = size_poz_cz(2);
