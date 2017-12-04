clear all;
close all;
dane_testowe;

%flagi dopuszczalnosci rozwiazania; 1 gdy niedopuszczalne
global Bledy;

%% Losujemy rozwiazanie poczatkowe
rozw = randi([1 10], 3, 10);
wynik= fc(rozw);

%% Poprawa rozwiazania

bledy_przed = Bledy;
[ poprawione, wynik2, bledy_po ] = poprawa_rozw(rozw);



%% Glowny algorytm
% Tutaj mamy juz pierwsze rozwiazanie dopuszczalne

% na razie tutaj, jak uda sie poprawic rozwiazanie w 1 wywolaniu funkcji 
% poprawy to przypisanie lepiej zrobic od razu wyzej
x_wezel = poprawione; % rozwiazanie w aktualnym wezle
fc_wezel = wynik2; % jego wartosc funkcji celu
 
% dalej juz normalnie
x_optym = x_wezel; % najlepsze dotad znalezione rozwiazanie (dopuszczalne)
fc_optym = fc_wezel; % jego wartosc funkcji celu


%UWAGA sciana tekstu:
% Pomysl na ruch (i jego zabronienie): ruchem jest zmiana w ktoryms slocie
% w restauracji albo w zestawie
% nasza lista tabu (TL) moglaby byc macierz taka jak rozwiazanie, a w komorce
% byloby info czy ruch jest zabroniony: jesli nie jest to 0, jesli zrobimy
% ruch to wpisujemy np. 5 (osobna zmienna na 'dlugosc listy tabu', podobno
% uzywa sie oznaczenia tt - tabu tenure
% (przez 5 nastepnych ruchow zmiana w tym dniu, w
% tym slocie restauracji albo zestawie jest 'zabroniona') - co iteracje
% algorytmu (przejscie do kolejnego sasiada) wszystkie niezerowe elementy
% TL sa zmniejszane o 1

% Takie przemyslenie:
% musimy pamietac wokol kogo szukamy, zeby sprawdzic cale jego sasiedztwo 
% i nie zmieniac sobie wezla, wokol ktorego szukamy w trakcie szukania

% To ponizej to PROPOZYCJA jednej iteracji algorytmu (limit liczby iteracji!) 
% - tzn. jednego ruchu


% Przeiteruj po wszystkich sasiadach : +-1 w kazdym slocie, dla kazdej
% restauracji i zestawu (2^30 sasiadow) i znajdz 'nalepszego' sasiada (x_new) 
% i najlepszego sasiada tabu (x_new_tabu):

% Dla kazdego sasiada sprawdz czy jest dopuszczalny (jesli nie to pomijamy)
% czyli wszystko ponizej w if'ie sprawdzajacym dopuszczalnosc rozwiazania
% bedacego sasiadem

% Sprawdz czy ten sasiad (x_temp) nie jest zabroniony (czy TL(...) ~= 0)

% Jesli tak (nie jest zabroniony) to oblicz dla niego funkcje celu i 
% porownaj z fc_new (najlepszy sasiad), jesli dla nowego wezla jest mniejsza to 
% x_new = x_temp, fc_new = fc_temp

% Else (sasiad jest na TL) to oblicz dla niego funkcje celu i porownaj z 
% fc_new_tabu (naljepszy "tabu-sasiad")
% x_new_tabu = x_temp, fc_new_tabu = fc_temp


% WYKONAJ RUCH
% Jesli fc_new < fc_optym to 
% x_optym = x_new, fc_optym = fc_new

% Teraz (To chyba NIE jest else): sprawdz kryterium aspiracji:
% Jesli fc_new_tabu < fc_optym (wazna silna nierownosc!) to 
% x_optym = x_new_tabu, fc_optym = fc_new_tabu

% x_new = x_new_tabu - zeby moc skorygowac TL

% KOREKTA LISTY TABU
% Przeiteruj po TL, jesli element jest > 0 to zmniejsz go o 1
% Nastepnie:
% Na podstawie x_wezel i x_new (czyli gdzie bylismy i gdzie jestesmy)
% trzeba wyznaczyc w ktore miejsce TL wpisac tt (czas trwania zabronienia)
% - no i go tam wpisac...
