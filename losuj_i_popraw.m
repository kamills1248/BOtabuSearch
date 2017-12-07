function [ poprawione, wynik ] = losuj_i_popraw( )
global Bledy; %flagi dopuszczalnosci
Bez_bledow = zeros(3,5,3);

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest;

%% Losujemy rozwiazanie poczatkowe
rozw = zeros(3,10); % 3 sloty na dzien, 5 restauracji i 5 zestawow

for dzien = 1:5
    for slot = 1:3 
        % losowanie restauracji:
        rozw(slot, dzien*2-1) = randi([1 ilosc_rest], 1);
        % losowanie zestawu:
        rozw(slot, dzien*2) = randi([1 ilosc_zestawow], 1);
    end
end

fc(rozw); %obliczamy fc I USTAWIAMY FLAGI BLEDOW; nie chcemy wyniku

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to ponizej zostawiam, bo jakby cos wyzej nie dzialalo, to to ponizej juz
% dzialalo
% rozw = randi([1 10], 3, 10);
% fc(rozw); %obliczamy fc I USTAWIAMY FLAGI BLEDOW; nie chcemy wyniku
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Poprawa rozwiazania
[ poprawione, wynik ] = poprawa_rozw(rozw);

% sprawdzic, czy rozwiazanie dopuszczalne - jesli nie to petla az
% dostaniemy dopuszczalne
if (~isequal(Bledy, Bez_bledow))
    i = 0;
    while(~isequal(Bledy, Bez_bledow) && i < 20)
        % losowanie kolejnego rozwiazania:
        for dzien = 1:5
            for slot = 1:3 
                % losowanie restauracji:
                rozw(slot, dzien*2-1) = randi([1 ilosc_rest], 1);
                % losowanie zestawu:
                rozw(slot, dzien*2) = randi([1 ilosc_zestawow], 1);
            end
        end
        [ poprawione, wynik] = poprawa_rozw(rozw);
        i = i + 1;
    end
    if (i >= 20)
       warning('Brak rozwiazania dopuszczalnego');
    end
end
end
