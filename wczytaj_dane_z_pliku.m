global R; global Z; global D; global poz_cz; global B; global S; global Ep;
global E_max;

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;

% polozenie czlowieka 
poz_bud = [  9, 3.5;
            14, 3.5;
            13,   4;
            12,   4;
             2, 1.5]; %B1, C1, C2, C3, D8
         
B1 = 1; C1 = 2; C2 = 3; C3 = 4; D8 = 5;

% macierz restauracji (wiersze: kolejne restauracje, kolumny: dwie pierwsze to polozenie (x,y), trzecia
% to ocena restauracji (1-10), nastêpne to parami zestawy (cena i czas
% wykonania)
load R.txt -ascii        

% licze ilosc restauracji
size_R = size(R);
ilosc_rest = size_R(1);


% zestawy (wiersze: kcal, czas konsumpcji, ocena, kolumny: kolejne zestawy)
load Z.txt -ascii  

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
     
% macierz odleglosci knajp od budynkow z zajeciami
% restauracje \ budynki

 
D = [(abs(R(:,1) - poz_bud(1,1)) + abs(R(:,2) - poz_bud(1,2))),...
     (abs(R(:,1) - poz_bud(2,1)) + abs(R(:,2) - poz_bud(2,2))),...
     (abs(R(:,1) - poz_bud(3,1)) + abs(R(:,2) - poz_bud(3,2))),...
     (abs(R(:,1) - poz_bud(4,1)) + abs(R(:,2) - poz_bud(4,2))),...
     (abs(R(:,1) - poz_bud(5,1)) + abs(R(:,2) - poz_bud(5,2)))];
 
%  polozenie czlowieka przed i po slocie (kolumny: kolejne dni, wiersze:
%  polozenie kolejno: przed slot 1 przed 10, po slot 1 przed 13, po slot 2
%  po 13, po slot 3 po 16:30)
% load poz_cz.txt -ascii  % NIE DZIALA, TRZEBA WYMYSLIC COS INNEGO!!!

         
% licze ilosc dni
size_poz_cz = size(poz_cz);
ilosc_dni = size_poz_cz(2);
