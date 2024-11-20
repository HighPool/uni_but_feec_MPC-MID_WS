%% Cviceni 1 - reseni
clc
clear
close all

t = 0:0.01:10;           %Generovani casoveho vektoru
u = ones(size(t));      %Generovani vstupniho vektoru - skok v case 0
y = cviceni02_1(u,t);   %Odezva systemu na vstupni data

figure(1)
plot(t,y,'b')
title('Odezva systemu na vstupni signal')
xlabel('t')
ylabel('y')
hold on

I = find(y>0,1);        %Index prvni nenulove hodnoty - pro odstraneni dop. zpozdeni
% I = 1;
K = mean(y(end-2:end)); %Zesileni z prumeru poslednich trech hodnot
d = (y(I+1)-y(I))/(t(I+1)-t(I));    %Vypocet derivace v pocatku
T = K / d;              %Vypocet casove konstanty z derivace a zesileni
disp('Identifikovany prenos soustavy:')
s = tf('s');
F = K/(T*s+1)

figure(1)
yv = lsim(F,u,t);
plot(t,yv,'r')
legend('y(t)','yv(t)')
hold off