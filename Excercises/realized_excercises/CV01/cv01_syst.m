clc
close all
clear

%% System 1. radu
p = tf('p');

K_1 = 3.5;    % Zesileni
T_1 = 0.5;    % Casova konstanta
t_1 = 0:0.001:4; % Cas simulace

F_1 = K_1/(T_1*p + 1);    % Operatorovy prenos systemu 1. radu
% F_1 = tf(K_1, [T_1 1])  % 2. zpusob vytvoreni operatoroveho prenosu systemu 1. radu
%zpk(F_1)   % Zero-pole-gain form

% Diferencialni rovnice
%sys = ss(F);   % Stavovy popis - Matice A,B,C,D
[num, den] = tfdata(F_1, 'v');    % Koeficienty numerator (= citatel) a denominator (= jmenovatel)

% Prechodova charakteristika
figure(1)
[y_1,t_out_1] = step(F_1,t_1);
plot(t_out_1,y_1);
xlabel('t [s]')
ylabel('h(t) [-]')
title('Přechodová charakteristika')
grid on
hold on

d = (y_1(2) - y_1(1)) / (t_1(2) - t_1(1));  % Derivace (smernice, sklon) tecny hned od pocatku                                                                                                                                                                                                                                                      
tecna = d * t_1;  % Tecna
plot(t_1, tecna, '--r');
ylim([0, y_1(end) + 1])
hold on
uroven_K = ones(length(t_1), 1) .* y_1(end);  % Rovnobezka s K
plot(t_1, uroven_K, '--k');
hold on

index_prusecik = find(tecna >= y_1(end), 1);
T_prusecik = t_1(index_prusecik);
plot(T_prusecik, tecna(index_prusecik), 'o', 'MarkerSize', 10)
disp(['Casova konstanta jako prusecik tecny a zesileni je T = ',num2str(T_prusecik)]);
hold on

index_0632 = find(y_1 >= y_1(end) * 0.632, 1);
T_0632 = t_1(index_0632);
plot(T_0632, tecna(index_0632), 'o', 'MarkerSize', 10)
disp(['Casova konstanta jako cas pri 63.2 % amplitudy y je T = ',num2str(T_0632)]);

% Impulsova charakteristika
figure(2)
impulse(F_1,t_1)
xlabel('t [s]')
ylabel('g(t) [-]')
title('Impulsová charakteristika')
grid on

% Poly a nuly
figure(3);
pzmap(F_1);    

% Korenovy hodograf - kam se bude posouvat se zesilenim
figure(4);
rlocus(F_1);   

% Frekvencni charakteristika v komplexni rovine
figure(5);
nyquist(F_1); 

% Frekvencni charakteristika v log souradnicich ( log10(K)*20 )
figure(6);
bode(F_1);    

%% System 1. radu se zpozdenim
p = tf('p');

K_1_zp = 3.5;    % Zesileni
T_1_zp = 0.5;    % Casova konstanta
t_1_zp = 0:0.001:6; % Cas simulace

F_1_zp = K_1_zp/(T_1_zp*p + 1)*exp(-2*p);  % Operatorovy prenos systemu 1. radu se zpozdenim 
%set(F, 'outputdelay', 2);  % 2. zpusob vytvoreni zpozdeni z operatoroveho prenosu systemu 1. radu

% Prechodova charakteristika
figure(11)
[y_1_zp,t_out_1_zp] = step(F_1_zp,t_1_zp);
plot(t_out_1_zp,y_1_zp);
xlabel('t [s]')
ylabel('h(t) [-]')
title('Přechodová charakteristika')
grid on
hold on

% Impulsova charakteristika
figure(12)
impulse(F_1_zp,t_1_zp)
xlabel('t [s]')
ylabel('g(t) [-]')
title('Impulsová charakteristika')
grid on

% Poly a nuly
figure(13);
pzmap(F_1_zp);    

% Frekvencni charakteristika v komplexni rovine
figure(15);
nyquist(F_1_zp); 

% Frekvencni charakteristika v log souradnicich ( log10(K)*20 )
figure(16);
bode(F_1_zp); 

%% System 2. radu
p = tf('p');

K_2 = 3.5;    % Zesileni
T_2 = 0.5;    % Casova konstanta
t_2 = 0:0.001:10; % Cas simulace

ksi1 = 1;
F_21 = K_2/(T_2^2*p^2 + 2*ksi1*T_2*p + 1);    % Na mezi aperiodicity (ksi = 1)

ksi2 = 2;
F_22 = K_2/(T_2^2*p^2 + 2*ksi2*T_2*p + 1);    % Pretlumeny system   (ksi > 1)

ksi3 = 0.5;
F_23 = K_2/(T_2^2*p^2 + 2*ksi3*T_2*p + 1);    % Kmitavy system   (ksi = (0,1))

ksi4 = 0;
F_24 = K_2/(T_2^2*p^2 + 2*ksi4*T_2*p + 1);    % Netlumeny system   (ksi = 0)

% Prechodova charakteristika
figure(21)
[y_21,t_out_21] = step(F_21,t_2);
[y_22,t_out_22] = step(F_22,t_2);
[y_23,t_out_23] = step(F_23,t_2);
[y_24,t_out_24] = step(F_24,t_2);
plot(t_out_21,y_21);
hold on
plot(t_out_22,y_22);
hold on
plot(t_out_23,y_23);
hold on
plot(t_out_24,y_24);
xlabel('t [s]')
ylabel('h(t) [-]')
title('Přechodová charakteristika')
grid on
legend('Na mezi aperiodicity (ksi = 1)', 'Pretlumeny system (ksi > 1)', 'Kmitavy system (ksi = (0,1))', 'Netlumeny system (ksi = 0)')

% Impulsova charakteristika
figure(22)
impulse(F_21,t_2)
hold on
impulse(F_22,t_2)
hold on
impulse(F_23,t_2)
hold on
impulse(F_24,t_2)
xlabel('t [s]')
ylabel('g(t) [-]')
title('Impulsová charakteristika')
grid on
legend('Na mezi aperiodicity (ksi = 1)', 'Pretlumeny system (ksi > 1)', 'Kmitavy system (ksi = (0,1))', 'Netlumeny system (ksi = 0)')

% Poly a nuly
figure(23);
pzmap(F_21);
hold on
pzmap(F_22);
hold on
pzmap(F_23);
hold on
pzmap(F_24);
legend('Na mezi aperiodicity (ksi = 1)', 'Pretlumeny system (ksi > 1)', 'Kmitavy system (ksi = (0,1))', 'Netlumeny system (ksi = 0)')

% Korenovy hodograf - kam se bude posouvat se zesilenim
figure(24);
rlocus(F_24);   

% Frekvencni charakteristika v komplexni rovine
figure(25);
nyquist(F_21);
hold on 
nyquist(F_22);
hold on 
nyquist(F_23);
hold on 
nyquist(F_24);
xlim([-5,5]);
legend('Na mezi aperiodicity (ksi = 1)', 'Pretlumeny system (ksi > 1)', 'Kmitavy system (ksi = (0,1))', 'Netlumeny system (ksi = 0)')

% Frekvencni charakteristika v log souradnicich ( log10(K)*20 )
figure(26);
bode(F_21);
hold on
bode(F_22);
hold on
bode(F_23);
hold on
bode(F_24);
legend('Na mezi aperiodicity (ksi = 1)', 'Pretlumeny system (ksi > 1)', 'Kmitavy system (ksi = (0,1))', 'Netlumeny system (ksi = 0)')

%% Integrator = astaticky system 1. radu
p = tf('p');

K_integ = 3.5;    % Zesileni
T_integ = 0.5;    % Casova konstanta
t_integ = 0:0.001:10; % Cas simulace

F_integ = K_integ/(T_integ*p);    % Operatorovy prenos integratoru

% Prechodova charakteristika
figure(31)
[y_integ,t_out_integ] = step(F_integ,t_integ);
plot(t_out_integ,y_integ);
xlabel('t [s]')
ylabel('h(t) [-]')
title('Přechodová charakteristika')
grid on
hold on

% Impulsova charakteristika
figure(32)
impulse(F_integ,t_integ)
xlabel('t [s]')
ylabel('g(t) [-]')
title('Impulsová charakteristika')
grid on

% Poly a nuly
figure(33);
pzmap(F_integ);    

% Korenovy hodograf - kam se bude posouvat se zesilenim
figure(34);
rlocus(F_integ);   

% Frekvencni charakteristika v komplexni rovine
figure(35);
nyquist(F_integ); 

% Frekvencni charakteristika v log souradnicich ( log10(K)*20 )
figure(36);
bode(F_integ);   