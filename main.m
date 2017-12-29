if (exist('summary')) %sprawdza czy to nie pierwszy przebieg gdy nie ma okna
    delete(summary); %zamyka msgbox z podsumowaniem dzialania algorytmu
end
% clear all;
close all; % !!!!!!!!!!!!!!!!!!!!!!!

% dane_testowe;
wczytaj_dane_z_pliku;
%flagi dopuszczalnosci rozwiazania; 1 gdy niedopuszczalne
global Bledy;
%uniwersalne rozmiary macierzy:
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;

% Bledy = zeros(3, 5, 3); %sloty, dni, flagi: budzet, czas, energia
% inicjowane przy pierwszym przebiegu fc
Bez_bledow = zeros(3,ilosc_dni,3); %3 sloty, liczba dni, 3 rodzaje bledow
x_zeros = zeros(3,2*ilosc_dni); %rozwiazanie: 3 sloty, 2*liczba_dni (bo na 
    %kazdy dzien restauracja i zestaw)

%% Losujemy rozwiazanie poczatkowe i poprawiamy je
[ x_wezel, fc_wezel] = losuj_i_popraw();
% x_wezel - rozwiazanie w aktualnym wezle
% fc_wezel - jego wartosc funkcji celu


%% Przykladowe zapisane rozwiazanie, zeby potestowac parametry
% load przykladowe_poczatkowe_rozw;
% x_wezel = przykladowe;
% fc_wezel = fc(x_wezel);

%% Glowny algorytm
x_optym = x_wezel; % najlepsze dotad znalezione rozwiazanie (dopuszczalne)
fc_optym = fc_wezel; % jego wartosc funkcji celu

% zmienne do uogolnienia przebiegu algorytmu
x_size = size(x_optym);
liczba_slotow = x_size(1); %liczba slotow w danej instancji; zakladamy = 3
% liczba_dni = x_size(2)/2; %liczba dni w danej instancji /2 bo na kazdy dzien 
%        %po 2 kolumny - restauracje i zestawy; moze sie zmieniac

TL = zeros(x_size); %Lista Tabu - zabronienia niedawnych ruchow
TT = 5; %Tabu Tenure - czas trwania zabronienia
CAcount = 0; %liczba zadzialan kryterium aspiracji (Aspiration Criteria)

iteracje = 0; %iteracje algorytmu (ruchy)
iter_bez_poprawy = 0; %liczba iteracji bez poprawy wartosci fc_optym

iteracje_lim = 500; %limit liczby iteracji algortymu (ruchow)
iter_bez_poprawy_lim = 50; %limit liczby iteracji bez poprawy fc_optym gdy
%osiagniemy ten limit to losujemy nowe rozwiazanie i zerujemy iter_bez_poprawy

% prealokacja pamieci dla wektorow, zeby bylo jeszcze szybciej
fc_wektor_new = zeros(1, iteracje_lim);
fc_wektor_new_tabu = zeros(1, iteracje_lim);
fc_wektor_optym = zeros(1, iteracje_lim);

% mapy kolorow - kolorystycznie zaznaczenie odwiedzonych miejsc
% na poczatku wszystkie punktu maja wartosc zero, a jesli w dane miejce
% pojdziemy (restauracja i zestaw w danym dniu i slocie) to dodajemy 1 i
% dzieki temu zmienia sie kolor na cieplejszy
mapa_kolorow = zeros(liczba_slotow*ilosc_zestawow,ilosc_dni*ilosc_rest); % dla wybranych wezlow rozwiazania
mapa_kolorow_sasiedzi = zeros(liczba_slotow*ilosc_zestawow,ilosc_dni*ilosc_rest); % dla wszystkich sasiadow, ktorych sprawdzamy

while(iteracje < iteracje_lim )
    x_new = zeros(x_size); % inicjalizacja zeby sprawdzic czy jest dopuszczalny sasiad
    fc_new = inf; % wartosc funkcji celu najlepszego sasiada nie na TL
    fc_new_tabu = inf; % wartosc funkcji celu najlepszego sasiada na TL
    
    for dzien = 1:ilosc_dni %przejscie po macierzy rozwiazania
        for slot = 1:liczba_slotow
            r = x_wezel(slot, dzien*2-1);   % r-ta restauracja
            k = x_wezel(slot, dzien*2);  % k-ty zestaw
            
            % dodajemy 1 do mapy kolorow rozwiazania
            mapa_kolorow((slot-1)*ilosc_zestawow+k,(dzien-1)*ilosc_rest+r) =...
                mapa_kolorow((slot-1)*ilosc_zestawow+k,(dzien-1)*ilosc_rest+r) + 1; 
            
              
            %zadajemy liczbe sasiadow
            liczba_sasiadow = 5; %liczba sasiadow w wierszu i kolumnie + 1 
                %bo uwzgledniamy srodek otoczenia; 'kwadratowe' otoczenie
            srodek_otoczenia = ceil(liczba_sasiadow/2); %nr srodka otoczenia
        
            %wyznaczenie indeksow sasiadow
            %sasiednie restauracje
            neigh_r = ones(1, liczba_sasiadow) * r; %wszedzie wpisuje srodek otoczenia
            %sasiednie zestawy
            neigh_k = ones(1, liczba_sasiadow) * k; %wszedzie wpisuje srodek otoczenia

            %zmieniam indeksy na lewo od srodka otoczenia
            for i = 1:(srodek_otoczenia-1)
                odleglosc_sasiada = srodek_otoczenia - i; %jak dalego od srodka
                %dla restauracji
                neigh_r(i) = neigh_r(i) - odleglosc_sasiada;
                while(neigh_r(i) < 1) %sprawdzenie czy sie nie przekrecilo
                    neigh_r(i) = neigh_r(i) + ilosc_rest;
                end
                %dla zestawow
                neigh_k(i) = neigh_k(i) - odleglosc_sasiada;
                while(neigh_k(i) < 1)
                    neigh_k(i) = neigh_k(i) + ilosc_zestawow;
                end
            end
            
            %zmieniam indeksy na prawo od srodka otoczenia
            for i = (srodek_otoczenia+1):liczba_sasiadow
                odleglosc_sasiada = i - srodek_otoczenia; %jak dalego od srodka
                %dla restauracji
                neigh_r(i) = neigh_r(i) + odleglosc_sasiada;
                while(neigh_r(i) > ilosc_rest) %sprawdzenie czy sie nie przekrecilo
                    neigh_r(i) = neigh_r(i) - ilosc_rest;
                end
                %dla zestawow
                neigh_k(i) = neigh_k(i) + odleglosc_sasiada;
                while(neigh_k(i) > ilosc_zestawow)
                    neigh_k(i) = neigh_k(i) - ilosc_zestawow;
                end
            end
            %koniec wyznaczenia indeksow sasiadow
            
            %sprawdzenie funkcji celu dla sasiadow
            for rest = 1:liczba_sasiadow
                for zestaw = 1:liczba_sasiadow
                    mapa_kolorow_sasiedzi((slot-1)*ilosc_zestawow+neigh_k(zestaw),(dzien-1)*ilosc_rest+neigh_r(rest)) =...
                        mapa_kolorow_sasiedzi((slot-1)*ilosc_zestawow+neigh_k(zestaw),(dzien-1)*ilosc_rest+neigh_r(rest)) + 1;
                    
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
        % Kryterium aspiracji (CA) dla rozwiazania z TL
        if (fc_new_tabu < fc_optym) %(wazna silna nierownosc!)
            x_optym = x_new_tabu;
            fc_optym = fc_new_tabu;
            iter_bez_poprawy = 0; % jest poprawa
            x_new = x_new_tabu; % zeby moc latwo skorygowac TL
            CAcount = CAcount + 1; %licznik zadzialan kryterium aspiracji
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

%% WIZUALIZACJA OTRZYMANYCH WYNIKOW
% Uwaga: docelowo przy wywolywaniu maina 100 razy, zeby przyspieszyc proces
% nie wyswietlajac za kazdym razem wszystkiego ponizsze rzeczy musza byc
% wykomentowane!!!

% mapa(x_optym);

% zwracamy srednie, zeby potem moc je zapisac w wokrspace i ew sprawdzic 
% jakie byly bez rysowania wszystkiego
% do funkcji przekazujemy druga rzecz "0" lub "1" - "0" oznacza tylko zwroc
% srednie, "1" - zwroc srednie i narysuj wszystko (wyswietla figury
% wszystkie)
[sr_E, sr_B, sr_C] = wyswietl_E_B_C( x_optym, 0 ); 

% tutaj wrzucilam cala reszte, zeby moc mniej komentowac
% duzo przekazuje do tej funkcji, wiem, ale potem bedzie mozna ja w osobnym
% skrypcie poza main tez wyswietlic i bedzie git!
wizualizacja_wynikow(fc_wektor_new, fc_wektor_new_tabu,fc_wektor_optym,...
    mapa_kolorow, mapa_kolorow_sasiedzi, x_optym);

%%
% Podsumowanie przebiegu algorytmu - mozna dodawac kolejne rzeczy
% w nawiasach klamrowych przecinkami oddzielone kolejne linie, drugi
% argument msgbox to tytul okienka
% summary = msgbox({sprintf('Liczba iteracji = %d', iteracje_lim), ...
%     sprintf('Najlepsza wartoœæ funkcji celu = %d', fc_optym), ...    
%     sprintf('Liczba zadzia³añ kryterium aspiracji = %d', CAcount),}, ...
%     'Podsumowanie przebiegu algorytmu');
% set(summary, 'position', [100 400 500 100]); % makes box bigger
%     %odleglosc od: lewej strony ekranu, dolu, rozmiar x, rozmiar y

