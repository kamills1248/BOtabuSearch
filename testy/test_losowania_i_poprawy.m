%ten plik przed odpaleniem przeniesc do glownego katalogu (albo
%zmodyfikowac)
dane_testowe;

global Bledy;
Bez_bledow = zeros(3,5,3);

%%
good = 0;
for iter = 1:10000 %dla 10k liczy sie kilka/kilkanascie minut i mnie dalo wszystkie dobre
    [ x_new, fc_wezel ] = losuj_i_popraw();
    if(isequal(Bledy, Bez_bledow) )
       good = good + 1; 
    end
end

good
