clear
close all
clc

cisla = 2:1:10000;
prvocisla = 1;

while (prvocisla(end) < 3000)
    prvocisla(length(prvocisla)+1) = cisla(1);
    cisla = cisla(2:end);
    c1 = cisla./prvocisla(end);
    c2 = [];
    for i = 1:1:length(c1)
        if round(c1(i)) ~= c1(i)
            c2(end+1) = cisla(i);
        end
    end
    cisla = c2;
end
prvocisla(end-1)