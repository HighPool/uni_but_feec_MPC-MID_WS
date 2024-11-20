%% Cviceni 1 - reseni 5
clc
clear
close all

t = 0:0.01:100;                         % Generovani casoveho vektoru
uv = ones(size(t));                     % Generovani vstupniho vektoru - skok v case 0
u = uv * 10000;                         % zesileni soustavy
yp = cviceni02_5(u,t);                  % Odezva systemu na vstupni data
y = yp / 10000; 

Ks  = y(end)-y(1);                      % zesileni soustavy
y = y - y(1);                           % posunutí poèátku, odstranìní ss odchylky
yn = y / Ks;                             % Normalizace na zesileni 1

figure(1)
plot(t,yn,'b')
title('Odezva systemu na vstupni signal')
xlabel('t')
ylabel('yn')
hold on
[d I] = max(diff(yn)./(t(2)-t(1)));      % d je smernice tecny v inflexnim bode a I je pozice inflexniho bodu.
yi = yn(I); ti = t(I);                   % zjisteni parametru inflexniho bodu
% rovnice primky: y = d*t + yi - d*ti, resime pro y=0 a pro y=1
plot(t, d*t+yi-d*ti,'--r')
plot(t,(uv(1:end)-1),'--k')
plot(t(I),yn(I),'+g')                    % poloha inflexniho bodu
hold off
axis([0 100 -0.1 1])
Tu = ti - yi/d                          % cas ve kterem primka protina y=0             
Tn = 1/d                                % cas ve kterem primka protina y=1 minus Tu 
tau = Tu / Tn;
yi = 0.264;                             % dosazeni tabulkove hodnoty yi
n = 2;                                  % dosazeni tabulkove hodnoty n
I = find(yn>yi,1);                      % nalezeni indexu s hodnotou yi
T = t(I)/(n-1);                         % vypocet casove konstanty
  
s = tf('s');
disp('Identifikovany prenos soustavy:')
F = Ks/(T*s+1)^n
T
tau

figure(2)
plot(t,y,'b')
hold on
yv = lsim(F,u,t)/10000;
plot(t,yv,'r')
legend('y(t)','yv(t)')
hold off