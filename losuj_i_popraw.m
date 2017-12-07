function [ poprawione, wynik ] = losuj_i_popraw( )
global Bledy; %flagi dopuszczalnosci
Bez_bledow = zeros(3,5,3);

%% Losujemy rozwiazanie poczatkowe
rozw = randi([1 10], 3, 10);
fc(rozw); %obliczamy fc I USTAWIAMY FLAGI BLEDOW; nie chcemy wyniku

%% Poprawa rozwiazania
[ poprawione, wynik ] = poprawa_rozw(rozw);

% sprawdzic, czy rozwiazanie dopuszczalne - jesli nie to petla az
% dostaniemy dopuszczalne
if (~isequal(Bledy, Bez_bledow))
    i = 0;
    while(~isequal(Bledy, Bez_bledow) && i < 20)
        rozw = randi([1 10], 3, 10);
        [ poprawione, wynik] = poprawa_rozw(rozw);
        i = i + 1;
    end
    if (i >= 20)
       warning('Brak rozwiazania dopuszczalnego');
    end
end
end
