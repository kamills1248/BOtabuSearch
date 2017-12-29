function [ ] = wyswietl_E_B_C( rozwiazanie )
%WYSWIETL_E_B_C Summary of this function goes here
%   Detailed explanation goes here


global R; global Z; global D; global poz_cz; global B; global S;
global Ep; global E_max; global kwadrans_akademicki;

%uniwersalne rozmiary macierzy
global ilosc_zestawow; global ilosc_rest; global ilosc_dni


sp = 2.5; %spalanie w [kcal/min]
przerwa = [2, 3, 3.5, 1.5]; %w [h]


zaplacone = zeros(3*ilosc_dni, 1);
czas_zuzyty = zeros(3*ilosc_dni, 1);
gorne_ograniczenie_czasu = zeros(3*ilosc_dni, 1); % porzebne do rysowania max czasu slotu
i = 1; % ta zmienna przydaje sie dalej do wektora zaplacone i zuzyty_czas

srednia_energia = 0;
sredni_budzet = 0;
sredni_czas = 0;

figure() % do rysowania wykresow energii

for dzien=1:2:(2*ilosc_dni - 1) %idziemy 1,3,5,7,9...; bo jest wiecej kolum niz dni
    
    energia = [];                           % czyszcze wektor energia
    time = 0:(przerwa(1)*60-1);             % wektor czasu (w minutach)
    E = Ep - sp*time;                       % tworze wektor aktualnego poziomu energii
    energia_przed_posilkiem = E(przerwa(1)*60); % energia po zakonczeniu zajec
    energia = [energia, E];            % dolaczam obliczony przebieg do wekora energia
    
    for slot = 1:3
        r = rozwiazanie(slot, dzien);   % r-ta restauracja
        k = rozwiazanie(slot, dzien+1); % k-ty zestaw
        
        % BUDZET
        if(i == 1)
            zaplacone(i) = R(r,2*k+2);
        else
            zaplacone(i) = zaplacone(i-1) + R(r,2*k+2);
        end          
        
        % CZAS
        % ceil bo po dniach idziemy co 2, a w macierzy poz_cz chcemy co 1
        do_rest = D(r,poz_cz(slot,ceil(dzien/2))); % czas dojscia do restauracji
        od_rest = D(r,poz_cz(slot + 1,ceil(dzien/2))); % czas dojscia na zajecia potem
        % czas calkowity: dojscie + oczekiwanie + jedzenie + powrot
        czas_zuzyty(i) = do_rest + R(r,2*k+3) + Z(2,k) + od_rest;
        gorne_ograniczenie_czasu(i) = S(slot, ceil(dzien/2)) + kwadrans_akademicki;
        i = i + 1;
               
        % ENERGIA:                
        time = 0:(przerwa(slot+1)*60-1);
        E = energia_przed_posilkiem + Z(1,k) - sp*time;
        energia_przed_posilkiem = E(przerwa(slot+1)*60);
        energia = [energia, E];       
    end
    
    % zaczyna sie rysowanie energii na wykesie
    if(mod(ilosc_dni,2)==1) % to mi sie przydaje potem do wypisywania sredniej
        subplot(ceil(ilosc_dni/2),2,ceil(dzien/2));
    else
        subplot(ceil(ilosc_dni/2)+1,2,ceil(dzien/2));
    end
    maksimum = ones(600)*E_max; % robie to zeby narysowac ten max limit energii
    time = 1:600;
    plot(time,energia,time, maksimum);
    axis([0 600 0 E_max+200]);
    title(['Dzieñ ' num2str(ceil(dzien/2))]);
    xlabel('Czas [min]');
    ylabel('Energia [kcal]');
    
    % do liczenia sredniej
    srednia_E_dnia = sum(energia)/600;
    srednia_energia = srednia_energia + srednia_E_dnia;
    
end

% wyliczenie sredniej energii w tygodniu:
srednia_energia = srednia_energia/ilosc_dni;

% wypisanie œredniej energi na subplocie:
if(mod(ilosc_dni,2)==1) % ten if jest po to, aby ladnie sie wypisalo w odpowiednim oknie
    subplot(ceil(ilosc_dni/2),2,ilosc_dni+1);
    text(0,1,'œredni poziom energii w ci¹gu'); 
    text(0,0.75,['wszystkich dni wynosi ' num2str(srednia_energia) ' kcal']); 
    axis off;
else
    subplot(ceil(ilosc_dni/2)+1,2,ilosc_dni+1);
    text(0,1,'œredni poziom energii w ci¹gu'); 
    text(0,0.75,['wszystkich dni wynosi ' num2str(srednia_energia) ' kcal']); 
    axis off;
end


% rysowanie wykresu budzetu
figure()
subplot(2,2,1)
maksimum = ones(3*ilosc_dni)*B; % robie to zeby narysowac ten max limit budzetu
i = i - 1; % robie to, zeby zgadzal sie rozmiar wektorow
time = 1:i;
plot(time,zaplacone,time, maksimum);
axis([1 i 0 B+10]);
title(['Bud¿et w ci¹gu ' num2str(ilosc_dni) ' dni']);
xlabel('Sloty w dniach');
ylabel('Wydane pieni¹dze [zl]');


% rysowanie wykresu czasu w slotach 
subplot(2,2,2)
time = 1:i;
plot(time,czas_zuzyty,'o',time, gorne_ograniczenie_czasu, 'o');
axis([0.5 (i+0.5) 0 (max(gorne_ograniczenie_czasu)+20)]);
title(['Czas w przerwach w ci¹gu ' num2str(ilosc_dni) ' dni']);
xlabel('Sloty w dniach');
ylabel('Czas [min]');
legend('Czas zu¿yty na jedzenie', 'Czasowy limit slotu');

grid on
grid minor

% % rysowanie linii pionowych
% for d = 1:(ilosc_dni*3)
%     line([d, d], ...
%         [0, max(gorne_ograniczenie_czasu)+20],...
%         'Color','black','LineWidth',1);
% end


% wyliczenie sredniego budzetu:
sredni_budzet = zaplacone(i)/ilosc_dni;

% wypisanie sredniego budzetu:
subplot(2,2,3)
text(0,1,'œrednio wydane zosta³o ');
text(0,0.9,[ num2str(sredni_budzet) ' z³ na dzieñ']);
axis off;


% wyliczenie sredniego zuzytego czasu:
sredni_czas = sum(czas_zuzyty)/i;

% wypisanie sredniego zuzytego:
subplot(2,2,4)
text(0,1,'œrednio wykorzystaliœmy ');
text(0,0.9,[num2str(sredni_czas) ' minut na jeden slot']);
axis off;


end
