clear all;
close all;
dane_testowe;

%flagi dopuszczalnosci rozwiazania; 1 gdy niedopuszczalne
global Bledy;

% rozw_na_pale = ones(3,10);
% wynik_na_pale = fc(rozw_na_pale);

%% Losujemy rozwiazanie poczatkowe
rozw = randi([1 10], 3, 10);
wynik= fc(rozw);
% %trzeba robic algorytm poprawy
% dobre = 0;
% A = zeros(3,5,3);
% for i = 1:1000000
%     rozw = randi([1 10], 3, 10);
%     wynik= fc(rozw);
%     if(Bledy == A)
%        dobrze = dobrze + 1;
%     end
% end

%% Poprawa rozwiazania
iter = 0;
Bez_bledow = zeros(3,5,3);
Bledy_pocz = Bledy; %flagi ustawione po sprawdzeniu rozwiazania poczatkowego
    %to tylko dla naszej informacji
    
poprawione = poprawa_rozw(rozw); %funkcja poprawiajaca rozwiazanie
wynik2 = fc(poprawione); 
Bledy_popr = Bledy; %flagi ustawione po sprawdzeniu rozwiazania poprawionego

while (~isequal(Bledy_popr, Bez_bledow) && iter < 1000)
    poprawione = poprawa_rozw(rozw); %funkcja poprawiajaca rozwiazanie
    wynik2 = fc(poprawione); 
    Bledy_popr = Bledy; %flagi ustawione po sprawdzeniu rozwiazania poprawionego
    iter = iter + 1;
end

%linia dodana do testu gita
