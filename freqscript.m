%script per frequenza di percolazione, prove in parallelo (test parfor)
np=30; %numero probabilità 
np_range=linspace(0.05,0.95,np); %range probabilità 
N = 1000; %numero di tentativi eseguiti 

for dim=[20, 60, 120, 180] %dimensioni dei reticoli considerati 
    freqperc = zeros(1,np);
    parfor i=1:np %numero di tentativi in parallelo 
        p = np_range(i); %probabilità di colorazione 
        perc = zeros(1,N);
            for t = 1 : N
            A=HK4(p,dim) %utilizzo HK-compelto 
                if   A.vertPerc ~= 0 %ricerco percolazione 
                    freqperc(i) = freqperc(i) + 1;
                    perc(t) = 1;
                elseif A.orizPerc ~=0%ricerco percolazione 
                    freqperc(i) = freqperc(i) + 1;
                    perc(t) = 1;
                end %NB: da chiedere per || 
            end
       
                
         freqperc(i) = freqperc(i)/N; %calcolo della frequenza di percolazione
         errperc(i) = std(perc)/sqrt(N); %calcolo dell'errore 
    end
% GENERO IL GRAFICO
hold all
errorbar(np_range,freqperc,errperc); %usiamo errorbar 
end
hold off