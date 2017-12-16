function [  ] = mapa(rozwiazanie)


global poz_cz; global S; global poz_bud; global R; global nazwa_budynku; 
global nazwa_rest; global nazwa_zestawu; global ilosc_dni;

% wczytuje plan
plan = imread('map_agh.png');
             
% petla po liczbie dni             
for dzien=1:ilosc_dni
    figure()
    imshow(plan);
    title(['Dzieñ nr ' num2str(dzien)]);
    hold on;
    
    nr_budynku = zeros(4,1);
    %zaznaczam budynki z macierzy poz_cz:
    for i=1:4 
        
        % pobieram nr budynku z macierzy poz_cz:
        nr_budynku(i) = poz_cz(i, dzien); 
        
        % pobieram wspolrzedne budynku z macierzy poz_bud:
        x_budynku = poz_bud(nr_budynku(i), 1); 
        y_budynku = poz_bud(nr_budynku(i), 2);
        
        % teraz sprawdzam, czy juz wczesniej pojawil sie ten budynek, bo jak
        % tak, to przypal, i trza cos z tym zrobic:
        bylo = 0;
        for j=1:4
            if(nr_budynku(i) == nr_budynku(j) && i~=j)
                bylo = bylo + 1;
            end
        end
        
        % rysuje kropke na planie (if bylo>0, to przesuwa kropke w prawo):
        plot(x_budynku+(bylo*10), y_budynku, '.', 'MarkerSize', 40,'MarkerEdge', 'b');
        
        % pisze liczbe na planie (if bylo>0, to przesuwa numer w prawo):
        text(x_budynku-5+(bylo*10),y_budynku, num2str(2*i-1));
    end
    
    
    nr_rest = zeros(3,1);
    nr_zestawu = zeros(3,1);
    %zaznaczam restauracje z macierzy rozwiazanie:
    for nr_slotu=1:3
        
        % pobieram nr restauracji z macierzy rozwiazanie:
        nr_rest(nr_slotu) = rozwiazanie(nr_slotu, dzien*2-1);
        nr_zestawu(nr_slotu) = rozwiazanie(nr_slotu, dzien*2);
        
        % pobieram wspolrzedne budynku z macierzy R:
        x_rest = R(nr_rest(nr_slotu), 1); 
        y_rest = R(nr_rest(nr_slotu), 2);
        
        % teraz sprawdzam, czy juz wczesniej pojawila sie ta restauracja, 
        % bo jak tak, to przypal, i trza cos z tym zrobic:
        bylo = 0;
        for j=1:3
            if(nr_rest(nr_slotu) == nr_rest(j) && nr_slotu~=j)
                bylo = bylo + 1;
            end
        end
          
        % rysuje kropke na planie (if bylo>0, to przesuwa kropke w prawo):
        plot(x_rest+(bylo*10), y_rest,'.','MarkerSize',40,'MarkerEdge','r');
        
        % pisze liczbe na planie (if bylo>0, to przesuwa numer w prawo):
        text(x_rest-4+(bylo*10), y_rest, num2str(2*nr_slotu));
    end
    
    
    % wyliczanie czasow zajec i posilkow
    for i=1:3 % ide po liczbie slotow
        mm = mod(S(i,dzien),60); % ile jest minut w slocie
        hh = (S(i,dzien) - mm)/60; % ile jest godzin w slocie
        
        switch i
            case 1 % godzina rozpoczecia zajec drugich
                hh = hh + 10; %
                if(mm < 10)
                    % funkcja strcat() skleja stringi 
                    godzina_zajec_2 = strcat(num2str(hh), ':0', num2str(mm));
                else
                    godzina_zajec_2 = strcat(num2str(hh), ':', num2str(mm));
                end        
            case 2 % godzina rozpoczecia zajec trzecich
                hh = hh + 13;
                if(mm < 10)
                    godzina_zajec_3 = strcat(num2str(hh), ':0', num2str(mm));
                else
                    godzina_zajec_3 = strcat(num2str(hh), ':', num2str(mm));
                end  
            case 3 % godzina rozpoczecia zajec czwartych
                hh = hh + 16;
                mm = mm + 30; % tutaj dochodzi problem, bo nie liczymy od rownej godziny
                if(mm >= 60) % a w tym if-ie rozwiazuje ten problem
                    hh = hh + 1;
                    mm = mm - 60;
                end
                if(mm < 10)
                    godzina_zajec_4 = strcat(num2str(hh), ':0', num2str(mm));
                else
                    godzina_zajec_4 = strcat(num2str(hh), ':', num2str(mm));
                end
            otherwise
                continue
        end
    end
    
    czas = {    '8:00 ';            % zajecia 1
                '10:00';            % przerwa 1
                godzina_zajec_2;    % zajecia 2
                '13:00';            % przerwa 2
                godzina_zajec_3;    % zajecia 3
                '16:30';            % przerwa 3
                godzina_zajec_4;    % zajecia 4
                '18:00';};          % koniec zajec 4
    
    
    %legenda
    for i=1:(3+4)
        if(mod(i,2) ~= 0)
            nr_b = nr_budynku((i+1)/2);
            
            %podzielilem to na trzykrotne wypisywanie tekstu, bo za cholere
            %nie chcialo dzialac jak bylo w jednej linijce:
            text(10, 10+(i*20), czas(i));
            text(40, 10+(i*20), ' - ');
            text(50, 10+(i*20), nazwa_budynku(nr_b));
        else
            nr_r = nr_rest(i/2);
            
            %podzielilem to na trzykrotne wypisywanie tekstu, bo za cholere
            %nie chcialo dzialac jak bylo w jednej linijce:
            text(10, 10+(i*20), czas(i));
            text(40, 10+(i*20), ' - ');
            text(50, 10+(i*20), strcat(nazwa_rest(nr_r), ' ', nazwa_zestawu(nr_r)));
        end
    
    end
end
end
