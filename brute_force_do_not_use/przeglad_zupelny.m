% przeglad zupelny - nie ma opcji przejrzec wszystkich rozwiazan
clear all;
close all;
cd ..;
dane_testowe;
cd brute_force_do_not_use;

rozw = ones(3, 10);
wynik = fc(rozw);
iter = 0;

rozw_min = rozw;
wynik_min = wynik;

for i310 = 1:10
rozw(3,10) = i310;
for i39 = 1:10
rozw(3,9) = i39;
for i38 = 1:10
rozw(3,8) = i38;
for i37 = 1:10
rozw(3,7) = i37;
for i36 = 1:10
rozw(3,6) = i36;
for i35 = 1:10
rozw(3,5) = i35;
for i34 = 1:10
rozw(3,4) = i34;
for i33 = 1:10
rozw(3,3) = i33;
for i32 = 1:10
rozw(3,2) = i32;
for i31 = 1:10
rozw(3,1) = i31;
for i210 = 1:10
rozw(2,10) = i210;
for i29 = 1:10
rozw(2,9) = i29;
for i28 = 1:10
rozw(2,8) = i28;
for i27 = 1:10
rozw(2,7) = i27;
for i26 = 1:10
rozw(2,6) = i26;
for i25 = 1:10
rozw(2,5) = i25;
for i24 = 1:10
rozw(2,4) = i24;
for i23 = 1:10
rozw(2,3) = i23;
for i22 = 1:10
rozw(2,2) = i22;
for i21 = 1:10
rozw(2,1) = i21;
    for i110 = 1:10
        rozw(1,10) = i110;
        for i19 = 1:10
            rozw(1,9) = i19;
            for i18 = 1:10
                rozw(1,8) = i18;
                for i17 = 1:10
                    rozw(1,7) = i17;
                    for i16 = 1:10
                        rozw(1,6) = i16;
                        for i15 = 1:10
                            rozw(1,5) = i15;
                            for i14 = 1:10
                                rozw(1,4) = i14;
                                for i13 = 1:10
                                    rozw(1,3) = i13;
                                    for i12 = 1:10
                                        rozw(1,2) = i12;
                                        for i11 = 1:10
                                            rozw(1,1) = i11;
                                            wynik = fc_przeglad_zupelny(rozw);
                                            if(wynik < wynik_min)
                                                wynik_min = wynik;
                                                rozw_min = rozw;
                                            end
                                            iter = iter + 1;
                                            if(iter > 10e6)
                                               return;
                                            end
                                        end
                                    end
                                end
                               iter %co 1000
                            end
                        end

                    end
                end
%                 iter
            end
        end
    end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end

rozw
wynik
