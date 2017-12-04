function [ poprawione, wynik, bledy ] = poprawa_rozw( rozw )
global Bledy; %flagi dopuszczalnosci

iter = 0;
Bez_bledow = zeros(3,5,3);

poprawioneB = poprawaB(rozw); 
% wynik_poprB = fc(poprawioneB); 
% Bledy_poprB = Bledy;

poprawioneC = poprawaC(poprawioneB); %funkcja poprawiajaca rozwiazanie
% wynik_poprC = fc(poprawioneC); 
% Bledy_poprC = Bledy;

poprawioneE = poprawaB(poprawioneC); %funkcja poprawiajaca rozwiazanie
% wynik_poprE = fc(poprawioneE); 
Bledy_poprE  = Bledy;

iter = 0;
while (~isequal(Bledy_poprE, Bez_bledow) && iter < 20)
    poprawioneB = poprawaB(rozw); 
%     wynik_poprB = fc(poprawioneB); 
%     Bledy_poprB = Bledy;

    poprawioneC = poprawaC(poprawioneB); %funkcja poprawiajaca rozwiazanie
%     wynik_poprC = fc(poprawioneC); 
%     Bledy_poprC = Bledy;

    poprawioneE = poprawaB(poprawioneC); %funkcja poprawiajaca rozwiazanie
    wynik_poprE = fc(poprawioneE); 
    Bledy_poprE  = Bledy;
    iter = iter + 1;
end

poprawione = poprawioneE;
wynik = wynik_poprE;
bledy = Bledy_poprE;


end

