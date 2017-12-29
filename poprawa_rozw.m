function [ poprawione, wynik ] = poprawa_rozw( rozw )
global Bledy; %flagi dopuszczalnosci
global ilosc_dni;

Bez_bledow = zeros(3,ilosc_dni,3); %3 sloty, liczba dni, 3 rodzaje bledow

poprawioneB = poprawaB(rozw); %funkcja poprawiajaca budzet
poprawioneC = poprawaC(poprawioneB); %funkcja poprawiajaca czas
poprawioneE = poprawaE(poprawioneC); %funkcja poprawiajaca energie

iter = 0;
while (~isequal(Bledy, Bez_bledow) && iter < 100)
    poprawioneB = poprawaB(rozw); %funkcja poprawiajaca budzet
    poprawioneC = poprawaC(poprawioneB); %funkcja poprawiajaca czas
    poprawioneE = poprawaE(poprawioneC); %funkcja poprawiajaca energie
    wynik_poprE = fc(poprawioneE); 
    iter = iter + 1;
end

poprawione = poprawioneE;
wynik = wynik_poprE;

end

