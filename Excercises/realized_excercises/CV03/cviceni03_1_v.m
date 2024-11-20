clear
% close all
% clc;

Ts = 0.1;
t = 0:Ts:20000;
[m,N] = size(t); 
% u = randn(m,N);
u = idinput(N,'prbs',[0 1],[-1 1]);
[y,gt,tt] = cviceni03_1(u,t);

%% vlastni vypocet
figure(1)
plot(t,u,t,y)
legend('u(k)','y(k)');

M = 300;    % pocet kroku impulsove charakteristiky
Ruu = zeros(M,1);  % priprava prazdneho pole
Ruy = zeros(M,1);

% N = length(u);

for k = 1:M
    for i = 1:N-k   % vypocet autokorelacni a vzajemne korelacni funkce
        Ruu(k) = Ruu(k)+u(i)*u(i+k-1);
        Ruy(k) = Ruy(k)+u(i)*y(i+k-1);
    end
    Ruu(k) = Ruu(k)/N; % normalizace (1/N*sum()...)
    Ruy(k) = Ruy(k)/N;
end

%% spocitani impulsovky dle wiener-hopfa

g = Ruy./Ruu(1)/Ts; % vypocet impulzovky
figure(2)
plot(tt(1:M),gt(1:M),t(1:M)',g(1:M)');
legend('gt(k)','g(k)');