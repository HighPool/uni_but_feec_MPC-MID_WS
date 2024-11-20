%% Cviceni 1 - reseni 6
clc
clear
close all

t = 0:0.01:15;          %Generovani casoveho vektoru
u = ones(size(t));      %Generovani vstupniho vektoru - skok v case 0
y = cviceni02_6(u,t);   %Odezva systemu na vstupni data
figure(1)
plot(t,y)
title('Odezva systemu na vstupni signal')
xlabel('t')
ylabel('y')
hold on

K  = mean(y((end-3):end))-mean(y(1:3)); %Zesileni z prumeru poslednich trech hodnot
TI1 = find(y>K,1);                  % 1. pruchod hodnotou K - index zacatku periody
TI2 = find(y(TI1+1:end)<K,1)+TI1+1; % 2. pruchod hodnotou K 
TI3 = find(y(TI2+1:end)>K,1)+TI2+1; % 3. pruchod hodnotou K - index konce periody
TA = t(TI3)-t(TI1);                 % vypocet periody z indexu pruchodu
[A1,I1] = max(y);                   % nalezeni globalniho maxima
[A2,I2] = max(y(TI2+5:end));        % nalezeni druheho vrcholu - je umisten za druhym pruchodem hodnotou K
A1 = A1 - K;                        % odecteni hodnoty zesileni
A2 = A2 - K;
theta = log(A1/A2);                 % vypocet theta
ksi = theta/sqrt(4*pi^2+theta^2);   % vypocet tlumeni
T = TA/2/pi*sqrt(1-ksi^2);          % vypocet casove konstanty T
I = find(y>0.05,1);    % Index prvni nenulove hodnoty - pro odstraneni dop. zpozdeni
Td = (I-1)*(t(2)-t(1));

disp('Identifikovany prenos soustavy:')
s = tf('s');
F = K/(T^2*s^2+2*ksi*T*s+1)*exp(-Td*s)

figure(1)
yv = lsim(F,u,t);
plot(t,yv,'r')
hold on

%% 2. zpusob podle prednasky a pdf
% rovnice o 2 neznamych K a M (viz prez.) vychazi do tvaru kvadraticke rovnice
% y1*M^2 + y2*M - (y2-y1) = 0   
% kde y1 je 1. lok. maximum a y2 je 2. lok. maximum

a = A1;     % y1
b = A2;     % y2
M = (a - b) / a;    % M

ksi = -log(M)/sqrt(4*pi^2 + (log(M))^2);
w = (2*pi) / (TA * sqrt(1 - ksi^2));
F1 = K*(w^2)/(s^2+2*ksi*w*s+(w^2))*exp(-Td*s);
yv2 = lsim(F1,u,t);
plot(t,yv2,'m')
hold on
plot(t,(ones(size(t))).*K, '--k')   % zesileni K
legend('y(t)','yv(t)', 'yv2(t)', 'K')
hold off