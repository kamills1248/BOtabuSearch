clear all;
% close all; !!!!!!!!!!!!!!!!!!!!!!!

t_MAX_ITER = 100;
tWektor = zeros(1,t_MAX_ITER);
for tIter = 1:t_MAX_ITER
tic;

dane_testowe;

%flagi dopuszczalnosci rozwiazania; 1 gdy niedopuszczalne
global Bledy;
%uniwersalne rozmiary macierzy:
global ilosc_zestawow; global ilosc_rest;

% Bledy = zeros(3, 5, 3); %sloty, dni, flagi: budzet, czas, energia
% inicjowane przy pierwszym przebiegu fc
Bez_bledow = zeros(3,5,3);
x_zeros = zeros(3,10);

%% Losujemy rozwiazanie poczatkowe i poprawiamy je
[ x_wezel, fc_wezel] = losuj_i_popraw();
% x_wezel - rozwiazanie w aktualnym wezle
% fc_wezel - jego wartosc funkcji celu


%% Przykladowe zapisane rozwiazanie, zeby potestowac parametry
load przykladowe_poczatkowe_rozw;
x_wezel = przykladowe;
fc_wezel = fc(x_wezel);

%% Glowny algorytm
x_optym = x_wezel; % najlepsze dotad znalezione rozwiazanie (dopuszczalne)
fc_optym = fc_wezel; % jego wartosc funkcji celu

% zmienne do uogolnienia przebiegu algorytmu
x_size = size(x_optym);
liczba_slotow = x_size(1); %liczba slotow w danej instancji; zakladamy = 3
liczba_dni = x_size(2)/2; %liczba dni w danej instancji /2 bo na kazdy dzien 
       %po 2 kolumny - restauracje i zestawy; moze sie zmieniac

TL = zeros(x_size); %Lista Tabu - zabronienia niedawnych ruchow
TT = 5; %Tabu Tenure - czas trwania zabronienia

iteracje = 0; %iteracje algorytmu (ruchy)
iter_bez_poprawy = 0; %liczba iteracji bez poprawy wartosci fc_optym

iteracje_lim = 500; %limit liczby iteracji algortymu (ruchow)
iter_bez_poprawy_lim = 50; %limit liczby iteracji bez poprawy fc_optym gdy
%osiagniemy ten limit to losujemy nowe rozwiazanie i zerujemy iter_bez_poprawy

% prealokacja pamieci dla wektorow, zeby bylo jeszcze szybciej
fc_wektor_new = zeros(1, iteracje_lim);
fc_wektor_new_tabu = zeros(1, iteracje_lim);
fc_wektor_optym = zeros(1, iteracje_lim);


while(iteracje < iteracje_lim )
    x_new = zeros(x_size); % inicjalizacja zeby sprawdzic czy jest dopuszczalny sasiad
    fc_new = inf; % wartosc funkcji celu najlepszego sasiada nie na TL
    fc_new_tabu = inf; % wartosc funkcji celu najlepszego sasiada na TL
    
    for dzien = 1:liczba_dni %przejscie po macierzy rozwiazania
        for slot = 1:liczba_slotow
            r = x_wezel(slot, dzien*2-1);   % r-ta restauracja
            k = x_wezel(slot, dzien*2);  % k-ty zestaw

            %zadajem liczbe sasiadow, jeszcze nie w pelni automatyczne
            liczba_sasiadow = 3; %liczba sasiadow + 1 bo uwzgledniamy srodek otoczenia
            srodek_otoczenia = ceil(liczba_sasiadow/2); %nr srodka otoczenia

% wrzucic w fora to nizej
            %sasiednie restauracje
            rw = r + 1; %wieksza
            if (rw == (ilosc_rest + 1)) 
                rw = 1;
            end
            rm = r - 1; %mniejsza
            if (rm == 0) 
                rm = ilosc_rest;
            end

            %sasiednie zestawy
            kw = k + 1;
            if (kw == (ilosc_zestawow + 1)) 
                kw = 1;
            end
            km = k - 1;
            if (km == 0) 
                km = ilosc_zestawow;
            end

            %wektory sasiadow
            neigh_r = [rm, r, rw];
            neigh_k = [km, k, kw];
% wrzucic w fora to wyzej

            %sprawdzenie funkcji celu dla sasiadow
            for rest = 1:liczba_sasiadow
                for zestaw = 1:liczba_sasiadow
                    if(rest == srodek_otoczenia && zestaw == srodek_otoczenia) 
                       continue; %srodek otoczenia - to nie sasiad
                    end

                    % wyznaczenie sasiada
                    x_chwilowe = x_wezel;
                    x_chwilowe(slot, dzien*2-1) = neigh_r(rest);
                    x_chwilowe(slot, dzien*2) = neigh_k(zestaw);

                    % obliczenie funkcji celu (+ustawienie flag Bledy)
                    fc_chwilowe = fc(x_chwilowe);

                    % sprawdzamy dopuszczalnosc rozwiazania
                    if(~isequal(Bledy, Bez_bledow))
                        fc_chwilowe = inf;
                        continue;
                    end

                    % SPRAWDZ CZY x_chwilowe jest na TL
                    % If nie jest na TL
                    if(TL(slot, dzien*2-1) == 0 &&  TL(slot, dzien*2) == 0)
                        % szukamy najlepszego sasiada nie na TL
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
    end %end: przejscie po macierzy rozwiazania


    if(~isequal(x_new, x_zeros) && iter_bez_poprawy < 50) 
    % jesli jest dopuszczalny sasiad i 'niedawno' byla poprawa
      % WYKONAJ RUCH
        if (fc_new < fc_optym) % dla rozwiazania nie z TL
            x_optym = x_new;
            fc_optym = fc_new;
            iter_bez_poprawy = 0; % jest poprawa
        end
        % Kryterium aspiracji dla rozwiazania z TL
        if (fc_new_tabu < fc_optym) %(wazna silna nierownosc!)
            x_optym = x_new_tabu;
            fc_optym = fc_new_tabu;
            iter_bez_poprawy = 0; % jest poprawa
            x_new = x_new_tabu; % zeby moc latwo skorygowac TL
        end

        % KOREKTA LISTY TABU
        x_diff = x_new - x_wezel; % sprawdzamy gdzie sie ruszylismy
        for i = 1:3 % Przeiteruj po TL, 
            for j = 1:10
                if(TL(i,j) > 0) %jesli element jest > 0 to zmniejsz go o 1 
                   TL(i,j) = TL(i,j) - 1; 
                end
                % Na podstawie x_wezel i x_new (czyli gdzie bylismy i gdzie jestesmy)
                if(x_diff(i,j) ~= 0) %zabronienie wykonanego ruchu
                    TL(i,j) = TT; %Tabu Tenure
                end
            end
        end %end: przeiteruj po TL
    else % jesli nie ma dopuszczalnego sasiada lub 'dlugo' nie bylo poprawy
            % to wylosuj nowe rozwiazanie i idz do niego
        i = 0;
        [ x_new, fc_wezel ] = losuj_i_popraw();
        while(~isequal(Bledy, Bez_bledow) && i < 20) %jakby nie wylosowal dopuszczalnego
            [ x_new, fc_wezel ] = losuj_i_popraw();
            i = i + 1;
        end
        iter_bez_poprawy = 0; % zaczynamy od nowego rozwiazania, dajemy mu szanse
    end
    x_wezel = x_new; % wykonaj ruch - zmien aktualny wezel
    iteracje = iteracje + 1;
    iter_bez_poprawy = iter_bez_poprawy + 1;
    fc_wektor_new(iteracje) = fc_new;
    fc_wektor_new_tabu(iteracje) = fc_new_tabu;
    fc_wektor_optym(iteracje) = fc_optym;
end
    tWektor(tIter) = toc;
end %tIter

%Sprawdzmy jak wygladaja czasy:
tMin = min(tWektor);
tMax = max(tWektor);
tMean = mean(tWektor);
tSTD = std(tWektor);



% format bank
% figure() %najlepszy sasiad
% plot(fc_wektor_new)
% title('Warto�� funkcji celu dla najlepszego s�siada');
% xlabel('Numer iteracji');
% ylabel('Warto�� funkcji celu');
% 
% figure() %najlepszy sasiad z TL
% plot(fc_wektor_new_tabu)
% title('Warto�� funkcji celu dla najlepszego s�siada z TL');
% xlabel('Numer iteracji');
% ylabel('Warto�� funkcji celu');
% 
% figure() %najlepszy dotad znaleziony
% plot(fc_wektor_optym)
% title('Warto�� funkcji celu dla najlepszego znalezionego w�z�a');
% xlabel('Numer iteracji');
% ylabel('Warto�� funkcji celu');
% 
% 
% mapa(x_optym, liczba_dni);
