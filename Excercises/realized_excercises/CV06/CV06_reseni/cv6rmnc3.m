function [TH,LBD] = cv6rmnc3 (U,Y,P0,th0,lbd0)
th = th0;       % inicializace vektoru neznamych parametru                                  
P = P0;         % inicialiyae kovarincni matice
TH = zeros(4,length(U)); TH(:,1) = th0; TH(:,2) = th0; % priprava vystupni matice parametru
LBD = zeros(4,length(U));
lbd = lbd0;                 % inicializace koef. zapominani
for k = 3:length(U)
    lbd = 0.99*lbd + (1-0.99);      % vypocet koef. yapominani pro aktualni krok
    if(abs(U(k)-U(k-1))>0.5)        % pokud dojde ke ymene vstupniho
        lbd = 0.95;
    end
    phi = [-Y(k-1), -Y(k-2), U(k-1), U(k-2)]';   % vypocet phi pro aktualni krok
    e = Y(k) - phi'*th;                          % vypocet odchylky
    K = P*phi /  (lbd + phi'*P*phi);             % vypocet korekce
    P = 1/lbd*(P - K*phi'*P);                    % aktualizace kovarincni matice
    th = th + K * e;                             % vypocet odhadu parametru v aktualnim koroce
    TH(:,k) = th;   
    LBD(:,k) = lbd;
end
end