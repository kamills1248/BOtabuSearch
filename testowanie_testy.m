if (exist('summary')) %sprawdza czy to nie pierwszy przebieg gdy nie ma okna
    delete(summary); %zamyka msgbox z podsumowaniem dzialania algorytmu
end

clear all;
close all; 

lastwarn(''); % wyzerowanie ostatniego warninga (teraz jest rowny '' i jego size to [0 0])

licznik = 1;

while(licznik <= 2) 
    main;
    size_warn = size(lastwarn)
    if(size_warn(2) ~=0 && size_warn(1) ~= 0)
        i = 1
       
%         nazwa = strcat(iter, '.mat')
        i = 2
        save nazwa.mat;
        i=4
        licznik = licznik + 1;
        i=5
    end
    i = 3
    lastwarn('');
    
end

