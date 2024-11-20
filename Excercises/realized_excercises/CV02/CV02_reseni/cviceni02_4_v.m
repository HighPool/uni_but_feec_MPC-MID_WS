%% Cviceni 1 - reseni 4
clc
clear
close all

t = 0:0.01:10;                          % Generovani casoveho vektoru
uv = ones(size(t));                     % Generovani vstupniho vektoru - skok v case 0
u = uv * 10000;                         % zesileni soustavy
yp = cviceni02_4(u,t);                  % Odezva systemu na vstupni data
y = yp / 10000; 

Ks  = y(end)-y(1);                      % zesileni soustavy
y = y - y(1);                           % posunutí poèátku, odstranìní ss odchylky
yn = y / Ks;                            % Normalizace na zesileni 1

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
axis([0 10 -0.1 1.1])
Tu = ti - yi/d                          % cas ve kterem primka protina y=0             
Tn = 1/d                                % cas ve kterem primka protina y=1 minus Tu 
tau = Tu / Tn;

I = find(yn>0.720,1);                    % zjisteni indexu prvku se kterym budeme pracovat
T12 = t(I)/1.2564;                      % vypocet T1+T2
t2 = 0.3574*T12;                        % zjisteni casu t2
It2 = find(t>t2,1);                     % zjisteni indexu s casem t2
y2 = yn(It2);                            % vypocet y2

tau2=0.4031;                            % dosazeni tabulkove hodnoty tau2 z hodnoty y2
T1 = T12 / (1+tau2);
T2 = T12 - T1;      
s = tf('s');
disp('Identifikovany prenos soustavy:')
F = Ks/(T1*s+1)/(T2*s+1)
T1
T2

figure(2)
plot(t,y,'b')
hold on
yv = lsim(F,u,t)/10000;
plot(t,yv,'r')
legend('y(t)','yv(t)')
hold off