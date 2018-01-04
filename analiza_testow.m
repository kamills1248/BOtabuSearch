clear all;
% close all; 

global Bledy;
load('testy\dane_testowe_rzeczywiste_r10_z10_d5\wyniki_testu.mat');

% Uwaga, okazalo sie, ze nie zapisywalismy tego osobno w pliku dlatego
% trzeba tu jeszzce raz wyciagnac to z wynikow
TLcount_sr = mean(wyniki(:,4));
TLcount_odchy = std(wyniki(:,4));

% Dla szybszego kopiowania danych:
Tabela_wynikow_1 = {'minimalna osi�gni�ta warto�� fc                                   ';
                    'maksymalna osi�gni�ta warto�� fc                                  ';
                    '�rednia warto�� fc                                                ';
                    'odchylenie wartosci fc                                            ';
                    '�rednia liczba zadzia�a� kryterium aspiracjii                     ';
                    'odchylenie liczby zadzia�a� kryterium aspiracji                   ';
                    '�rednia liczba zadzia�a� zabronienia                              ';
                    'odchylenie liczby zadzia�a� zabronienia                           ';
                    '�rednia ze �redniej warto�ci energii w ci�gu tygodnia             ';
                    'odchylenie ze �redniej warto�ci energii w ci�gu tygodnia          ';
                    '�rednia ze �redniej warto�ci pieni�dzy  wydanych w ci�gu slotu    ';
                    'odchylenie ze �redniej warto�ci pieni�dzy  wydanych w ci�gu slotu ';
                    '�rednia ze �redniej warto�ci czasu wykorzystanego w ci�gu slotu   ';
                    'odchylenie ze �redniej warto�ci czasu wykorzystanego w ci�gu slotu'};                
Tabela_wynikow_2 = [Min;
                    Max;
                    fc_optym_sr;
                    fc_optym_odchy;
                    CAcount_sr;
                    CAcount_odchy;
                    TLcount_sr;
                    TLcount_odchy;
                    sr_E_sr;
                    sr_E_odchy;
                    sr_B_sr;
                    sr_B_odchy;
                    sr_C_sr;
                    sr_C_odchy];               

            
%% BEST i wizualizacja

licznik = Nr_best_workspace; %zeby bylo jawnie
nazwa = strcat('testy\dane_testowe_rzeczywiste_r10_z10_d5\dane_testowe_rzeczywiste_r10_z10_d5_',...
    num2str(licznik),'.mat'); % tutaj tworzymy nazwe pliku (taka jak liczba iteracji)
load(nazwa);

%Sprawdzamy czy najlepsze rozwiazanie jest dopuszczalne
Bez_bledow = zeros(3,ilosc_dni,3); %3 sloty, liczba dni, 3 rodzaje bledow
fc(x_optym);
if(~isequal(Bledy, Bez_bledow))
    %nie jest dopuszczalne
    warning('Rozwiazanie niedopuszczalne');
    
end

%% WIZUALIZACJA OTRZYMANYCH WYNIKOW
% mapa(x_optym);

% zwracamy srednie, zeby potem moc je zapisac w wokrspace i ew sprawdzic 
% jakie byly bez rysowania wszystkiego
% do funkcji przekazujemy druga rzecz "0" lub "1" - "0" oznacza tylko zwroc
% srednie, "1" - zwroc srednie i narysuj wszystko (wyswietla figury
% wszystkie)
[sr_E, sr_B, sr_C] = wyswietl_E_B_C( x_optym, 1 ); 

wizualizacja_wynikow(fc_wektor_new, fc_wektor_new_tabu,fc_wektor_optym,...
     mapa_kolorow, mapa_kolorow_sasiedzi, x_optym);

%%
% Podsumowanie przebiegu algorytmu - mozna dodawac kolejne rzeczy
% w nawiasach klamrowych przecinkami oddzielone kolejne linie, drugi
% argument msgbox to tytul okienka
summary = msgbox({sprintf('Liczba iteracji = %d', iteracje_lim), ...
    sprintf('Najlepsza warto�� funkcji celu = %d', fc_optym), ...    
    sprintf('Liczba zadzia�a� kryterium aspiracji = %d', CAcount),}, ...
     'Podsumowanie przebiegu algorytmu');
set(summary, 'position', [100 400 500 100]); % makes box bigger
%odleglosc od: lewej strony ekranu, dolu, rozmiar x, rozmiar y
