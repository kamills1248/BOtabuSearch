function [ rozwiazanie ] = poprawaB( rozwiazanie )
%POPRAWA B - poprawa budzetu w rozwiazaniu

global R;
global Bledy; %flagi dopuszczalnosci

% jesli budzet jest przekroczony, to szukamu najwiekszej ceny posilku
if (Bledy(:,:,1) ~= zeros(3,5)) 
    cena=0;
    for dzien = 1:5
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
         
            
for dzien = 1:5
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        
        %poprawa budzetu
        
        % jesli ten posilek jest najdrozszym, to zamieniamy do na tanszy
        % (jezli jest pare tak samo drogich, to wszystkie zmniejszymy)
        cena_s = R(r,2*k+2); % cena w danym slocie
        if (cena_s == cena)
            while(cena_s >= cena) %dopoki cena sie nie zmiejszy
                rozwiazanie(slot,dzien*2-1)= randi([1 10], 1);
                rozwiazanie(slot,dzien*2)= randi([1 10], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                cena_s = R(r,2*k+2);
            end
        end
        
    end   
end
end