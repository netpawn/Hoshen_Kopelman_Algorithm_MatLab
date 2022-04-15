% numero tentativi 
N=1000; 
% probabilità 
np = 30; 
% probabilita nel range [0.01 0.99]
np_range=linspace(0.01, 0.99, np);  
% dimensioni del reticolo 
for dim=[30, 60, 120, 180]
    % numero tentativi parallelizzati 
    parfor j=1:np 
        p=np_range(j); 
        RACS = zeros(1,N);
        for i=1:N 
            A=HKCC(p,dim); 
            RACS(i) = A.clu*p; 
        end     
        avg_racs(j) = mean(RACS); 
        err_racs(j) = std(RACS)/sqrt(N);
    end
    % GRAFICO
    hold all
    errorbar(np_range,avg_racs,err_racs); 

end 