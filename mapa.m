function [  ] = mapa(rozwiazanie, liczba_dni)


global poz_cz;

% wczytuje plan
plan = imread('map_agh.png');

% nowe wspolzedne budynkow na planie
new_poz_bud = [ 618, 154;  %B1
                795, 145;  %C1
                763, 115;  %C2
                723, 113;  %C3
                190, 271]; %D8
                 
% nowe wspolzedne restauracji na planie
new_poz_rest = [ 352,  93; %Dagrasso
                 519, 260; %Krakus
                 526, 217; %Tawo
                 584, 277; %Nawojka
                 616, 175; %Labirynt
                 604,  47; %PastaMasta
                 659,  51; %Kebab
                 693,  99; %Lemon
                 851, 352; %Zaczek
                 779, 115]; %Barek

nazwa_budynku = {   'B1';
                    'C1';
                    'C2';
                    'C3';
                    'D8'};
                
nazwa_rest = {'Dagrasso  ';
              'Krakus    ';
              'Tawo      ';
              'Nawojka   ';
              'Labirynt  ';
              'PastaMasta';
              'Kebab     ';
              'Lemon     ';
              'Zaczek    ';
              'Barek     '};
             
% petla po liczbie dni             
for dzien=1:liczba_dni
    figure(dzien)
    imshow(plan);
    title(['dzien nr ' num2str(dzien)]);
    hold on;
    
    nr_budynku = zeros(4,1);
    %zaznaczam budynki z macierzy poz_cz:
    for i=1:4 
        
        % pobieram nr budynku z macierzy poz_cz:
        nr_budynku(i) = poz_cz(i, dzien); 
        
        % pobieram nowe wspolrzedne budynku z macierzy new_poz_bud:
        x_budynku = new_poz_bud(nr_budynku(i), 1); 
        y_budynku = new_poz_bud(nr_budynku(i), 2);
        
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
    %zaznaczam restauracje z macierzy rozwiazanie:
    for nr_slotu=1:3
        
        % pobieram nr restauracji z macierzy rozwiazanie:
        nr_rest(nr_slotu) = rozwiazanie(nr_slotu, dzien*2-1);
        
        % pobieram nowe wspolrzedne budynku z macierzy new_poz_rest:
        x_rest = new_poz_rest(nr_rest(nr_slotu), 1); 
        y_rest = new_poz_rest(nr_rest(nr_slotu), 2);
        
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
    
    %legenda
    for i=1:(3+4)
        if(mod(i,2) ~= 0)
            nr_b = nr_budynku((i+1)/2);
            text(10, 10+(i*20), [num2str(i) ': ']);
            text(30, 10+(i*20), nazwa_budynku(nr_b));
        else
            nr_r = nr_rest(i/2);
            text(10, 10+(i*20), [num2str(i) ': ']);
            text(30, 10+(i*20), nazwa_rest(nr_r));
        end
    
    end
end
end

