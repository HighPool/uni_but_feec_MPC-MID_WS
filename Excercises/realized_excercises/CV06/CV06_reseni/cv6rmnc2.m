function TH = cv6rmnc2 (U,Y,P0,th0,lbd)
th = th0;       % inicializace vektoru neznamych parametru                                  
P = P0;         % inicialiyae kovarincni matice
TH = zeros(4,length(U)); TH(:,1) = th0; TH(:,2) = th0; % priprava vystupni matice parametru
for k = 3:length(U)                             
    phi = [-Y(k-1), -Y(k-2), U(k-1), U(k-2)]';   % vypocet phi pro aktualni krok
    e = Y(k) - phi'*th;                          % vypocet odchylky
    K = P*phi /  (lbd + phi'*P*phi);             % vypocet korekce
    P = 1/lbd*(P - K*phi'*P);                    % aktualizace kovarincni matice
    th = th + K * e;                             % vypocet odhadu parametru v aktualnim koroce
    TH(:,k) = th;                                
end
end