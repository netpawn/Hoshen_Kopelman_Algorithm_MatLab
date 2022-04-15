function A = HKCC(p,L)

if nargin == 0,0;                  % Argomenti di default 
    p = 0.4; 
    L = 20; 
end

A.reticolo = rand(L)<p;            % Creazione del reticolo 
A.p= p;
A.L= L; 
A.lol = zeros(1, L^2/2);           % Label Of Label, vettore per ricostruzione
A.label = zeros(L);                % Matrice etichette 
N = L;                             % Campo per cicli 
idx = reshape(1:L^2, L, L);        % helper ricerca vicini 
nnl = [zeros(L,1) idx(:,1:L-1)];   % ricerca vicino sx 
nnu = [zeros(1,L); idx(1:L-1,:)];  % ricerca vicino up 

A.qol = zeros(1, L^2/2);           %quantità per cluster 
A.maxclusize = [];  
A.sumclusize = []; 
A.dimclus = []; %quantità totale meno il cluster più grande 

largest_label = 1;                 % l'etichetta parte da 1 

    for i = 1:L^2 %cicliamo una volta l'intera matrice e guardiamo ogni sito

         if(A.reticolo(i) && ~A.label(i)) % se è colorato e non ha label 
              
              %ha vicino sx e up -> il caso "complicato" 
              if (nnu(i) && nnl(i) && A.reticolo(nnu(i)) && A.reticolo(nnl(i)))
                
                  %mi salvo la etichetta maggiore e la minore per dopo    
                  mini = min(A.label(i-L), A.label(i-1));
                  maxi = max(A.label(i-L), A.label(i-1));
                  
                  %mettiamo la label corretta (la minore) al sito 
                  A.label(i) = min(A.label(i-L), A.label(i-1)); 

                  A.qol(A.label(i)) = A.qol(A.label(i)) +1; 

                  if mini>0 && maxi>0 && mini ~= maxi
                      if A.lol(mini)>0 
                         A.lol(mini) = A.lol(mini)+1;
                      end
                      A.lol(maxi) = -mini;
                   elseif mini == maxi
                      if A.lol(mini)>0 
                         A.lol(mini) = A.lol(mini)+1;
                         
                      end 

                  elseif mini<0 && maxi >0 && mini ~= maxi
                      A.lol(maxi) = -mini; 
                  end 

              % ha un vicino up 
              elseif (nnu(i) && A.reticolo(nnu(i)))
                  A.label(i) = A.label(nnu(i));
                  A.qol(A.label(i)) = A.qol(A.label(i)) +1; 
                  if A.lol(A.label(i))>=0
                     A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                  end 
                 

              % ha un vicino sx 
              % mettiamo l'etichetta corretta, incrementiamo la LOL
              % solamente se questa non punta ad un altro cluster 
              elseif (nnl(i) && A.reticolo(nnl(i)))
                  A.label(i) = A.label(nnl(i));
                  A.qol(A.label(i)) = A.qol(A.label(i)) +1; 
                  if A.lol(A.label(i))>=0
                     A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                  end
         
              % non ha vicini 
              else, A.label(i) = largest_label; 
                    largest_label = largest_label +1;  
                    if A.lol(A.label(i))>=0
                        A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                        A.qol(A.label(i)) = A.qol(A.label(i)) +1; 
                    end 
              end      
         end 
    end 


%+++++++++Ricerca cluster di taglia maggiore e somma dei cluster+++++++++++
for j=length(A.lol):-1:1 %mettiamo a posto i cluster 
    if A.lol(j) < 0 
       A.qol(abs(A.lol(j))) =  A.qol(abs(A.lol(j))) + A.qol(j);
       A.qol(j) = 0; 
    end 
end 

A.maxclusize=max(A.qol); 
A.sumclusize=sum(A.qol);
A.dimclus= A.sumclusize - A.maxclusize;
A.clu = max(A.qol(A.qol<max(A.qol)));


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end