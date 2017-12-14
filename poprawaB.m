function [ rozwiazanie ] = poprawaB( rozwiazanie )
%POPRAWA B - poprawa budzetu w rozwiazaniu

global R;
global Bledy; %flagi dopuszczalnosci

%uniwersalne rozmiary macierzy:
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;

iter = 0;

% jesli budzet jest przekroczony, to szukamu najwiekszej ceny posilku
if (~isequal(Bledy(:,:,1),zeros(3,ilosc_dni))) 
    cena=0;
    for dzien = 1:ilosc_dni
        for slot = 1:3
            r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
            k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
            if (R(r,2*k+2) > cena)
                cena = R(r,2*k+2); % to najwieksza cena posilku w rozwiazaniu
            end
        end
    end
else
    cena = 1000;
end
         
            
for dzien = 1:ilosc_dni
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        
        %poprawa budzetu
        
        % jesli ten posilek jest najdrozszym, to zamieniamy do na tanszy
        % (jezli jest pare tak samo drogich, to wszystkie zmniejszymy)
        cena_s = R(r,2*k+2); % cena w danym slocie
        if (cena_s == cena)
            while(cena_s >= cena && iter <10) %dopoki cena sie nie zmiejszy
                rozwiazanie(slot,dzien*2-1)= randi([1 ilosc_rest], 1);
                rozwiazanie(slot,dzien*2)= randi([1 ilosc_zestawow], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                cena_s = R(r,2*k+2);
                iter = iter + 1;
            end
        end
        
    end   
end
end