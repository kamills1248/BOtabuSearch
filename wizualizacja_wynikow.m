function [ ] = wizualizacja_wynikow(fc_wektor_new, fc_wektor_new_tabu, ...
    fc_wektor_optym, mapa_kolorow, mapa_kolorow_sasiedzi, x_optym, ...
    iteracje_lim, fc_optym, CAcount)
% WIZUALIZACJA OTRZYMANYCH WYNIKOW - przeniesiona z maina
global ilosc_zestawow; global ilosc_rest; global ilosc_dni;
x_size = size(x_optym);
liczba_slotow = x_size(1);

set(0,'defaultfigurecolor',[1 1 1]); %ustawia tlo figur na biale

figure() %fc najlepszych: sasiad, sasiad z TL i globalny
% figure() %fc - najlepszy sasiad
subplot(3,1,1)
plot(fc_wektor_new)
title('Wartoœæ funkcji celu dla najlepszego s¹siada');
xlabel('Numer iteracji');
ylabel('Wartoœæ funkcji celu');

subplot(3,1,2)
% figure() %fc - najlepszy sasiad z TL
plot(fc_wektor_new_tabu)
title('Wartoœæ funkcji celu dla najlepszego s¹siada z TL');
xlabel('Numer iteracji');
ylabel('Wartoœæ funkcji celu');

subplot(3,1,3)
% figure() %fc - najlepszy dotad znaleziony
plot(fc_wektor_optym)
title('Wartoœæ funkcji celu dla najlepszego znalezionego wêz³a');
xlabel('Numer iteracji');
ylabel('Wartoœæ funkcji celu');
%%
figure() %histogram wezly wybrane i sasiednie
subplot(2,1,1)
% figure() %histogram wezly wybrane
imagesc(mapa_kolorow); % "sc" na koncu image okresla wyskalowanie kolorow
colormap(jet) % okreslenie kolorystyki 
colorbar % wyswietlenie skali kolorystycznej 
title('Histogram wêz³ów wybranych')
% rysowanie linii oddzielaj¹cych dni (tylko pomiedzy dniami)
for d = 1:ilosc_dni-1
    line([ilosc_rest*d+0.5, ilosc_rest*d+0.5], ...
        [0, ilosc_zestawow*liczba_slotow+0.5],...
        'Color','black','LineWidth',3)
end
% rysowanie linii oddzielaj¹cych sloty (tylko pomiedzy slotami)
for s = 1:liczba_slotow-1
    line([0.5, ilosc_dni*ilosc_rest+0.5], ...
        [s*ilosc_zestawow+0.5, s*ilosc_zestawow+0.5],...
        'Color','black','LineWidth',3)
end

subplot(2,1,2)
% figure() %histogram wezly sasiednie
imagesc(mapa_kolorow_sasiedzi);  % "sc" na koncu image okresla wyskalowanie kolorow
colormap(jet) % okreslenie kolorystyki 
colorbar % wyswietlenie skali kolorystycznej
title('Histogram wêz³ów s¹siednich')
% rysowanie linii oddzielajacych dni (tylko pomiedzy dniami)
for d = 1:ilosc_dni-1
    line([ilosc_rest*d+0.5, ilosc_rest*d+0.5], ...
        [0, ilosc_zestawow*liczba_slotow+0.5],...
        'Color','black','LineWidth',3)

end
% rysowanie linii oddzielaj¹cych sloty (tylko pomiedzy slotami)
for s = 1:liczba_slotow-1
    line([0.5 ilosc_dni*ilosc_rest + 0.5], ...
        [s*ilosc_zestawow+0.5, s*ilosc_zestawow+0.5],...
        'Color','black','LineWidth',3)
end

%%
% Podsumowanie przebiegu algorytmu - mozna dodawac kolejne rzeczy
% w nawiasach klamrowych przecinkami oddzielone kolejne linie, drugi
% argument msgbox to tytul okienka
summary = msgbox({sprintf('Liczba iteracji = %d', iteracje_lim), ...
    sprintf('Najlepsza wartoœæ funkcji celu = %d', fc_optym), ...    
    sprintf('Liczba zadzia³añ kryterium aspiracji = %d', CAcount),}, ...
    'Podsumowanie przebiegu algorytmu');
set(summary, 'position', [100 400 500 100]); % makes box bigger
    %odleglosc od: lewej strony ekranu, dolu, rozmiar x, rozmiar y



end

