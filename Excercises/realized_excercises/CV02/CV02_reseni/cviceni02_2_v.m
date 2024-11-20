%% Cviceni 1 - reseni 2
clc
clear
close all

t = 0:0.1:30;              %Generovani casoveho vektoru
u = ones(size(t));          %Generovani vstupniho vektoru - skok v case 0

% RESENI PRO LINEARNI SOUSTAVY
u = u * 10000;              % zesileni soustavy
yp = cviceni02_2(u,t);
y = yp / 10000;             % Zpìtná normalizace na jednotkový skok
figure(1)
plot(t,y)
title('Odezva systemu na vstupni signal')
xlabel('t')
ylabel('y')
hold on

I = find(y>2e-5,1);         %Index prvni nenulove hodnoty - pro odstraneni dop. zpozdeni
K  = mean(y((end-3):end))-mean(y(1:3)); %Zesileni z prumeru poslednich trech hodnot
d = (y(I+3)-y(I))/(t(I+3)-t(I));           %Vypocet derivace v pocatku
T = K / d;                  %Vypocet casove konstanty z derivace a zesileni
Td = (I-1)*(t(2)-t(1))      %Casovy vektor zacina od 0, takze pro dt = 0.1 je pro index I=5 cas T=0.4 -> proto je Td = (5-1)*0.1 = 0.4
disp('Identifikovany prenos soustavy:')
s = tf('s');
F1 = K/(T*s+1)*exp(-Td*s)

figure(1)
yv = lsim(F1,u,t)/10000;
plot(t,yv,'r')
legend('y(t)','yv(t)')
grid on
hold off

% RESENI PRO CASOVE INVARIANTNI SOUSTAVY
u = ones(size(t));
u = u * 10; 
y = cviceni02_2(u,t);
yp = y * 0.1;   % inicializace 1. prvku
for i=1:99
  yp = yp + 0.1*cviceni02_2(u,t);
end
y = yp ./ (100);         % Zpìtná normalizace na jedno volani funkce
figure(2)
plot(t,y,'b')
title('Odezva systemu na vstupni signal')
xlabel('t')
ylabel('y')
hold on

I = find(y>0.0005,1);         %Index prvni nenulove hodnoty - pro odstraneni dop. zpozdeni
K  = mean(y((end-3):end))-mean(y(1:3)); %Zesileni z prumeru poslednich trech hodnot
d = (y(I+3)-y(I))/(t(I+3)-t(I));    %Vypocet derivace v pocatku
T = K / d;                  %Vypocet casove konstanty z derivace a zesileni
Td = (I-1)*(t(2)-t(1))
disp('Identifikovany prenos soustavy:')
s = tf('s');
F2 = K/(T*s+1)*exp(-Td*s)

figure(2)
yv = lsim(F2,0.1*u,t);
plot(t,yv,'r')
legend('y(t)','yv(t)')
grid on
hold off