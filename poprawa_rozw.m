function [ rozwiazanie ] = poprawa_rozw( rozwiazanie )
global R; global Z; global S; global D; global poz_cz;
global Ep; global E_max;
global Bledy; %flagi dopuszczalnosci
sp = 150; %spalanie w [kcal/h]
przerwa = [2, 3, 3.5, 1.5]; %w [h]

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
    energia = Ep - sp*przerwa(1); %danego dnia o 10, 2h po sniadaniu
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
        
        %poprawa czasu
        do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
        od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
        czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
        if(Bledy(slot,dzien,2) ~= 0 && czas_zuzyty > S(slot,dzien) + 15) 
            %jezeli w tablicy bledow byl tutaj blad i nadal jest po zmianach w budzecie
            while(czas_zuzyty >= (S(slot,dzien) + 15) || R(r,2*k+2) >= cena_s) %dopoki czas sie nie zmniejszy i cena bedzie taka jak byla lub mniejsza
                rozwiazanie(slot,dzien*2-1)= randi([1 10], 1);
                rozwiazanie(slot,dzien*2)= randi([1 10], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
                do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
                od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
            end    
        end
        
         %poprawa energii
         energia = energia - sp*przerwa(slot+1) + Z(1,k);
         if(Bledy(slot,dzien,3) ~= 0 && (energia < 0 || energia > E_max)) 
             %jezeli w tablicy bledow byl tutaj blad i nadal jest po powyuzszych zmianach
             while(energia > E_max || energia < 0 || czas_zuzyty <= (S(slot,ceil(dzien/2)) + 15) || R(r,2*k+2) <= cena_s) 
                 %dopoki energia sie nie zgadza i czas i cena beda rowne lub mniejsze poprzednim
                 rozwiazanie(slot,dzien*2-1)= randi([1 10], 1);
                 rozwiazanie(slot,dzien*2)= randi([1 10], 1);
                 r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                 k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                 czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
                 energia = energia - sp*przerwa(slot+1) + Z(1,k);
             end    
         end
    end   
end

end

