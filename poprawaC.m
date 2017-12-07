function [ rozwiazanie ] = poprawaC( rozwiazanie )
%POPRAWA C - poprawa czasu w rozwiazaniu

global R; global Z; global S; global D; global poz_cz;
global Bledy; %flagi dopuszczalnosci
%uniwersalne rozmiary macierzy:
global ilosc_zestawow; global ilosc_rest;

iter = 0;
            
for dzien = 1:5
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        cena_s = R(r,2*k+2); % cena w danym slocie
       
        %poprawa czasu
        do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
        od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
        czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
        if(Bledy(slot,dzien,2) ~= 0) 
            %jezeli w tablicy bledow byl tutaj blad i nadal jest po zmianach w budzecie
            while((czas_zuzyty >= (S(slot,dzien) + 15) || R(r,2*k+2) >= cena_s) && iter < 10) 
                %dopoki czas sie nie zmniejszy i cena bedzie taka jak byla lub mniejsza
                rozwiazanie(slot,dzien*2-1)= randi([1 ilosc_rest], 1);
                rozwiazanie(slot,dzien*2)= randi([1 ilosc_zestawow], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
                od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
                czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
                iter = iter +1;
            end    
        end
        
    end   
end

end