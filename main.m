clear all;
close all;
dane_testowe;

%flagi dopuszczalnosci rozwiazania; 1 gdy niedopuszczalne
global Bledy;
% Bledy = zeros(3, 5, 3); %sloty, dni, flagi: budzet, czas, energia
% inicjowane przy pierwszym przebiegu fc
Bez_bledow = zeros(3,5,3);
x_zeros = zeros(3,10);

%% Losujemy rozwiazanie poczatkowe i poprawiamy je
[ x_wezel, fc_wezel] = losuj_i_popraw();
% x_wezel - rozwiazanie w aktualnym wezle
% fc_wezel - jego wartosc funkcji celu

%% Glowny algorytm
% Tutaj mamy juz pierwsze rozwiazanie dopuszczalne

% na razie tutaj, jak uda sie poprawic rozwiazanie w 1 wywolaniu funkcji 
% poprawy to przypisanie lepiej zrobic od razu wyzej
 
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

TL = zeros(3,10);
TT = 5; %Tabu Tenure - czas trwania zabronienia

% Takie przemyslenie:
% musimy pamietac wokol kogo szukamy, zeby sprawdzic cale jego sasiedztwo 
% i nie zmieniac sobie wezla, wokol ktorego szukamy w trakcie szukania

% To ponizej to PROPOZYCJA jednej iteracji algorytmu (limit liczby iteracji!) 
% - tzn. jednego ruchu
iteracje = 0; %iteracje algorytmu (ruchy)
while(iteracje < 100)
    x_new = zeros(3,10); % inicjalizacja zeby sprawdzic czy jest dopuszczalny sasiad
    fc_new = inf; % wartosc funkcji celu najlepszego sasiada nie na TL
    fc_new_tabu = inf; % wartosc funkcji celu najlepszego sasiada na TL
    for dzien = 1:5
        for slot = 1:3
            r = x_wezel(slot, dzien*2-1);   % r-ta restauracja
            k = x_wezel(slot, dzien*2);  % k-ty zestaw

            %sasiednie restauracje
            rw = r + 1; %wieksza
            if (rw == 11) 
                rw = 1;
            end

            rm = r - 1; %mniejsza
            if (rm == 0) 
                rm = 10;
            end

            %sasiednie zestawy
            kw = k + 1;
            if (kw == 11) 
                kw = 1;
            end
            km = k - 1;
            if (km == 0) 
                km = 10;
            end

            %wektory sasiadow
            neigh_r = [rm, r, rw];
            neigh_k = [km, k, kw];

            %sprawdzenie funkcji celu dla sasiadow
            for rest=1:3
                for zestaw=1:3
                    if(rest == 2 && zestaw == 2) 
                       continue; %srodek otoczenia - to nie sasiad
                    end

                    % wyznaczenie sasiada
                    x_chwilowe = x_wezel;
                    x_chwilowe(slot, dzien*2-1) = neigh_r(rest);
                    x_chwilowe(slot, dzien*2) = neigh_k(zestaw);

                    % obliczenie funkcji celu
                    fc_chwilowe = fc(x_chwilowe);

                    % sprawdzamy dopuszczalnosc rozwiazania
                    if(~isequal(Bledy, Bez_bledow))
                        fc_chwilowe = inf;
                       continue;
                    end

                    % szukamy najlepszego sasiada nie na TL


                    % SPRAWDZ CZY x_new TL
                    % If nie jest na TL
                    if(TL(slot, dzien*2-1) == 0 &&  TL(slot, dzien*2) == 0)
                        if(fc_chwilowe < fc_new)
                            x_new = x_chwilowe;
                            fc_new = fc_chwilowe;
                        end
                    else % jest na TL
                    % szukamy najlepszego sasiada na TL
                        if(fc_chwilowe < fc_new_tabu)
                            x_new_tabu = x_chwilowe;
                            fc_new_tabu = fc_chwilowe;
                        end
                    end % koniec sprawdzenia czy x_new jest na TL             
                end
            end     
        end   
    end


    if(~isequal(x_new, x_zeros)) % jesli jest dopuszczalny sasiad
        % I JESLI NIE BYLO POPRAWY PRZEZ 'JAKIS' CZAS
        
      % WYKONAJ RUCH
        if (fc_new < fc_optym) % dla rozwiazania nie z TL
            x_optym = x_new;
            fc_optym = fc_new;
        end
        % Kryterium aspiracji
        if (fc_new_tabu < fc_optym) %(wazna silna nierownosc!)
            x_optym = x_new_tabu;
            fc_optym = fc_new_tabu;
            x_new = x_new_tabu; % zeby moc skorygowac TL
        end

        % KOREKTA LISTY TABU
        x_diff = x_new - x_wezel; % sprawdzamy gdzie sie ruszylismy
        for i = 1:3 % Przeiteruj po TL, 
            for j = 1:10
                if(TL(i,j) > 0)
                   TL(i,j) = TL(i,j) - 1; %jesli element jest > 0 to zmniejsz go o 1 
                end
                % Na podstawie x_wezel i x_new (czyli gdzie bylismy i gdzie jestesmy)
                if(x_diff(i,j) ~= 0) 
                    TL(i,j) = TT; %Tabu Tenure
                end
            end
        end
    else % jesli nie ma dopuszczalnego sasiada
          % wylosuj nowe rozwiazanie i idz do niego
        [ x_new, fc_wezel ] = losuj_i_popraw();
    end
    x_wezel = x_new; % wykonaj ruch - zmien aktualny wezel
    iteracje = iteracje + 1;
    fc_optym %sprawdzenie chwilowo w kodzie
end
