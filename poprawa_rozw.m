function [ rozwiazanie ] = poprawa_rozw( rozwiazanie )
global R;
global Bledy; %flagi dopuszczalnosci

for dzien = 1:5
    for slot = 1:3
        r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
        k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
        if(Bledy(slot,dzien,1) ~= 0) % tylko dla budzetu sprawdzamy warunek <1000
            while(R(r,2*k+2) == 1000)
                rozwiazanie(slot,dzien*2-1)=randi([1 10], 1);
                rozwiazanie(slot,dzien*2)=randi([1 10], 1);
                r = rozwiazanie(slot, dzien*2-1);   % r-ta restauracja
                k = rozwiazanie(slot, dzien*2);  % k-ty zestaw
            end
        end
    end   
end
end

