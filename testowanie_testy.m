% To wrzucamy do odpowiedniego katalogu z testami
% przed uruchomieniem wykomentowac w main wyswietlanie wszystkich wynikow
clear all;
close all; 

%liczba wywolan maina
LIMIT = 3;

% tworze macierz wynikow
wyniki = zeros(LIMIT,6);

lastwarn(''); % wyzerowanie ostatniego warninga (teraz jest rowny '' i jego size to [0 0])
licznik = 1;
while(licznik <= LIMIT) 
%   UWAGA! w main nie moze byc clear all, bo usuwa licznik!!!!!!!!!!!!!!!!!
    main;
    % tu ponizej sprawdzamy czy wykonal sie warning, jesli tak, to
    % pomijamy to rozwiazanie i jeszcze raz uruchamiamy main (licznik sie
    % nie inkrementuje)
    size_warn = size(lastwarn);
    if(size_warn(2) == 0 && size_warn(1) == 0)
        nazwa = strcat(num2str(licznik), '.mat'); % tutaj tworzymy nazwe pliku (taka jak liczba iteracji)
        save(nazwa);
        
        wyniki(licznik, 1) = licznik; % numer workspace'a
        wyniki(licznik, 2) = fc_optym;% optymalna wartosc funkcji celu
        wyniki(licznik, 3) = CAcount; % ile razy zadzialalo kryterium aspisracji
        wyniki(licznik, 4) = sr_E;    % srednia wartosc energii z calego tygodnia
        wyniki(licznik, 5) = sr_B;    % srednia ilosc wydanych pieniedzy w jeden slot
        wyniki(licznik, 6) = sr_C;    % srednia ilosc zurzytego czasu na jeden slot
        licznik = licznik + 1;
    end
    lastwarn('');
%   na wszelki wypadek usuwam te dane zapisane tu
    varlist = {'fc_chwilowe','fc_new','fc_new_tabu','fc_optym','fc_wektor_new',...
        'fc_wektor_new_tebu','fc_wektor_optym','fc_wezel','x_chwilowe','x_diff',...
        'x_diff','x_new','x_new_tabu','x_optym','x_size','x_wezel'};
    clear(varlist{:})
end

%liczenie srednich wartosci i odchylen
fc_optym_sr = mean(wyniki(:,2));
fc_optym_odchy = std(wyniki(:,2));
CAcount_sr = mean(wyniki(:,3));
CAcount_odchy = std(wyniki(:,3));
sr_E_sr = mean(wyniki(:,4));
sr_E_odchy = std(wyniki(:,4));
sr_B_sr = mean(wyniki(:,5));
sr_B_odchy = std(wyniki(:,5));
sr_C_sr = mean(wyniki(:,6));
sr_C_odchy = std(wyniki(:,6));

% najmniejsza wartosc z fc_optym
[Min, Nr_best_workspace] = min(wyniki(:,2));

% najgorsza wartosc z fc_optym
[Max, Nr_worst_workspace] = max(wyniki(:,2));

% dla dwóch powyrzych workspace-ow mozna wyswietlic wizualizacje wynikow i
% mape

% Na wszelki wypadek wyniki testu te¿ zapisujemy do pliku .mat
save('wyniki_testu.mat','wyniki','Min','Nr_best_workspace','Max','Nr_worst_workspace',...
    'fc_optym_sr','fc_optym_odchy','CAcount_sr','CAcount_odchy','sr_E_sr','sr_E_odchy',...
    'sr_B_sr','sr_B_odchy','sr_C_sr','sr_C_odchy');

