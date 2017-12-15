function [ f ] = fc( rozwiazanie)
% Funkcja celu
global R; global Z; global D; global poz_cz; global B; global S;
global Ep; global E_max;

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest; global ilosc_dni

global Bledy; %flagi dopuszczalnosci
Bledy = zeros(3, ilosc_dni, 3); %sloty, dni, flagi: budzet, czas, energia

const1 = 100; %czas
const2 = 200; %cena
const3 = 0.005; %zadowolenie
sp = 150; %spalanie w [kcal/h]
przerwa = [2, 3, 3.5, 1.5]; %w [h]

juz_jedlismy = ones(ilosc_zestawow) * ilosc_dni*3; %ilosc_dni*3 (sloty) = ile razy maksymalnie jemy
f  = 0; %do sumowania funkcji celu w kolejnych iteracjach; zerujemy przy wywolaniu fc
zaplacone = 0;

for dzien=1:2:(2*ilosc_dni - 1) %idziemy 1,3,5,7,9...; bo jest wiecej kolum niz dni
    energia = Ep - sp*przerwa(1); %danego dnia o 10, 2h po sniadaniu
    
    for slot = 1:3
        r = rozwiazanie(slot, dzien);   % r-ta restauracja
        k = rozwiazanie(slot, dzien+1); % k-ty zestaw
        do_rest = D(r,poz_cz(slot,ceil(dzien/2))); % czas dojscia do restauracji
        %ceil bo po dniach idziemy co 2, a w macierzy poz_cz chcemy co 1
        od_rest = D(r,poz_cz(slot + 1,ceil(dzien/2))); % czas dojscia na zajecia potem
        juz_jedlismy(k) = juz_jedlismy(k) - 1; % gdy zjemy to samo to zadowolenie maleje
        
        %sprawdzenie dopuszczalnosci rozwiazania
        %budzet
        zaplacone = zaplacone + R(r,2*k+2);
        if(zaplacone > B)
           Bledy(slot, ceil(dzien/2), 1) = 1;
        end
                    
        %czas
        czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
        if(czas_zuzyty > S(slot,ceil(dzien/2)) + 15) %kwadrans akademicki
         %ceil bo po dniach idziemy co 2, a w macierzy poz_cz chcemy co 1
           Bledy(slot, ceil(dzien/2), 2) = 1;
        end
               
        %energia: to co bylo - spalona + zjedzone
        %czy to co zjedlismy w danym slocie starczy do nastepnego posilku
        energia = energia - sp*przerwa(slot+1) + Z(1,k);
        if(energia < 0)
           Bledy(slot, ceil(dzien/2), 3) = -1;
        elseif (energia > E_max)
           Bledy(slot, ceil(dzien/2), 3) = 1;
        end
                
        %f = f + czas(konsumpcja + przygotowanie + dojscie "*2") + cena 
        % - zadowolenie(roznorodnosc * zestaw * restauracja * energetycznosc)
        f = f + const1*(czas_zuzyty) + const2*(R(r,2*k+2)) - ...
            const3*(juz_jedlismy(k)*Z(3,k)*R(r,3)*Z(1,k));  
        
    end
end
end
