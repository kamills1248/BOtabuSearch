if (exist('summary')) %sprawdza czy to nie pierwszy przebieg gdy nie ma okna
    delete(summary); %zamyka msgbox z podsumowaniem dzialania algorytmu
end

clear all;
close all; 

lastwarn(''); % wyzerowanie ostatniego warninga (teraz jest rowny '' i jego size to [0 0])

licznik = 1;


while(licznik < 3) 
%     save licznik.mat
    main;
%     na wszelki wypadek usuwam te dane zapisane tu
    varlist = {'fc_chwilowe','fc_new','fc_new_tabu','fc_optym','fc_wektor_new',...
        'fc_wektor_new_tebu','fc_wektor_optym','fc_wezel','x_chwilowe','x_diff',...
        'x_diff','x_new','x_new_tabu','x_optym','x_size','x_wezel'};
    clear(varlist{:})
    size_warn = size(lastwarn);
    lastwarn;
    if(size_warn(2) == 0 && size_warn(1) == 0)
       
%         nazwa = strcat(iter, '.mat')

        
        
        save nazwa.mat;

%         load licznik.mat
        licznik = licznik + 1;

    end
    lastwarn('');
end

