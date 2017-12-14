function [ rozwiazanie ] = poprawaE( rozwiazanie )
%POPRAWA E - poprawa energii w rozwiazaniu 

global R; global Z; global S; global D; global poz_cz;
global Ep; global E_max;
global Bledy; %flagi dopuszczalnosci
%uniwersalne rozmiary macierzy:
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;
sp = 150; %spalanie w [kcal/h]
przerwa = [2, 3, 3.5, 1.5]; %w [h]

iter =0;

for dzien = 1:ilosc_dni
    energia = Ep - sp*przerwa(1); %danego dnia o 10, 2h po sniadaniu
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        cena_s = R(r,2*k+2); % cena w danym slocie
        do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
        od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
        czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
        
        %poprawa energii
        energia_przed = energia;
        energia = energia_przed - sp*przerwa(slot+1) + Z(1,k);
        if(Bledy(slot,dzien,3) ~= 0) 
            %jezeli w tablicy bledow byl tutaj blad i nadal jest po powyuzszych zmianach
            while((energia > E_max || energia < 0 || czas_zuzyty > (S(slot,ceil(dzien/2)) + 15) || R(r,2*k+2) > cena_s) && iter < 10)
                %dopoki energia sie nie zgadza i czas i cena beda rowne lub mniejsze poprzednim
                rozwiazanie(slot,dzien*2-1)= randi([1 ilosc_rest], 1);
                rozwiazanie(slot,dzien*2)= randi([1 ilosc_zestawow], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
                do_rest = D(r,poz_cz(slot,dzien)); % czas dojscia do restauracji
                od_rest = D(r,poz_cz(slot + 1,dzien)); % czas dojscia na zajecia potem
                czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
                energia = energia_przed - sp*przerwa(slot+1) + Z(1,k);
                iter = iter + 1;
             end    
         end
    end   
end

end