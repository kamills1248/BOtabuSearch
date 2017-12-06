function [ f ] = fc_przeglad_zupelny( rozwiazanie )
global R; global Z; global D; global poz_cz;

const1 = 10; %czas
const2 = 10; %cena
const3 = 0.001; %zadowolenie

f  = 0;
zaplacone = 0;

for dzien=1:2:9 %idziemy 1,3,5,7,9; jest 10 kolumn   
    for slot = 1:3
        r = rozwiazanie(slot, dzien);   % r-ta restauracja
        k = rozwiazanie(slot, dzien+1); % k-ty zestaw
        do_rest = D(r,poz_cz(slot,ceil(dzien/2))); % czas dojscia do restauracji
        %ceil bo po dniach idziemy co 2, a w macierzy poz_cz chcemy co 1
        od_rest = D(r,poz_cz(slot + 1,ceil(dzien/2))); % czas dojscia na zajecia potem
            
        %sprawdzenie dopuszczalnosci rozwiazania
        %budzet
        zaplacone = zaplacone + R(r,2*k+2);
                    
        %czas
        czas_zuzyty = Z(2,k)+ R(r,2*k+3) + do_rest + od_rest;
               
        %energia: to co bylo - spalona + zjedzone
        %czy to co zjedlismy w danym slocie starczy do nastepnego posilku
                
        %f = f + czas(konsumpcja + przygotowanie + dojscie "*2") +
        % + cena - zadowolenie(zestaw * restauracja * energetycznosc)
        f = f + const1*(czas_zuzyty) + const2*(R(r,2*k+2)) - ...
            const3*(Z(3,k)*R(r,3)*Z(1,k));  
        
    end
end
end
