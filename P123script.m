%Test per P1,2,3 utilizzando parfor 

% probabilita nel range da 0.01 a 1
np_range=linspace(0.01,1,np);
% N Probalità 
np=30;
% N tentativi per probabilità 
N = 1000;
% dimensione reticolo
for dim=[20, 60, 120, 180]
    % Tentativi in parfor
    parfor i=1:np
        p = np_range(i);
            p1 = zeros(1,N);
            p2 = zeros(1,N);
            p3 = zeros(1,N);
                
            for t = 1 : N
            A=HKCC(p,dim); %HK CC variante mostrata sopra 
            
            % Singolo tentativo 
            p1(t) = A.maxclusize/(dim^2);
            p2(t) = p1(t)/p;
            p3(t) = A.maxclusize^2/A.sumclusize;
            end
        % Medie ed errori per P1,2,3 
        Avg_P1(i) = mean(p1);
        Avg_P2(i) = mean(p2);
        Avg_P3(i) = mean(p3);
        Err_P1(i) = std(p1)/sqrt(N); 
        Err_P2(i) = std(p2)/sqrt(N); 
        Err_P3(i) = std(p3)/sqrt(N);
     end
    % Sezione grafici 
    hold all
    figure(1);
    errorbar(np_range,Avg_P1,Err_P1); 
    hold all
    figure(2)
    errorbar(np_range,Avg_P2,Err_P2);
    hold all
    figure(3)
    errorbar(np_range,Avg_P3,Err_P3);
end