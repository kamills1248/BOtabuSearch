function [ rozwiazanie ] = poprawa_rozw( rozwiazanie )
global R;
global Bledy; %flagi dopuszczalnosci

for dzien = 1:5
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        
        %poprawa budzetu
        if(Bledy(slot,dzien,1) ~= 0) % tylko dla budzetu sprawdzamy warunek <1000
            %znajdz najdrozsze i dla niego wylosuj cos innego, sprawdzajac
            %czy jest tanszy niz to co bylo
            
%             while(R(r,2*k+2) == 1000)
%                 rozwiazanie(slot,dzien*2-1)= randi([1 10], 1);
%                 rozwiazanie(slot,dzien*2)= randi([1 10], 1);
%                 r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
%                 k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
%             end
        end
        
        %poprawa czasu
            %tutaj tylko dla tego konkretnego slotu - jesli nie spelnia to 
            %losuj (i sprawdz czy jest krocej niz bylo?)
        
        %poprawa energii
            %np. wylosuj w tym slocie inny posilek (w tej samej
            %restauracji?) o wyzszej wartosci energetycznej
            
    end   
end
end

