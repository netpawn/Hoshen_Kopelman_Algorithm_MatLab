function A = HK4(p,L)

if nargin == 0,0;                  % Argomenti di default 
    p = 0.55; 
    L = 4; 
end
 A.reticolo = [ 1 1 1 0
                1 0 0 1 
                0 1 0 1 
                1 1 1 1];
%A.reticolo = rand(L)<p;            % Creazione del reticolo 
A.p= p;
A.L= L; 
A.lol = zeros(1, L^2/2);             % Label Of Label, vettore per ricostruzione
A.label = zeros(L);                % Matrice etichette 
N = L;                             % Campo per cicli 
idx = reshape(1:L^2, L, L);        % helper ricerca vicini 
nnl = [zeros(L,1) idx(:,1:L-1)];   % ricerca vicino sx 
nnu = [zeros(1,L); idx(1:L-1,:)];  % ricerca vicino up 
A.vertPerc = [];                   % check percolazioene verticale 
A.orizPerc = [];                   % check percolazioene orizzontale
percolaO = false; 
pervolaV = false; 

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
                  if A.lol(A.label(i))>=0
                     A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                  end 
                 

              % ha un vicino sx 
              % mettiamo l'etichetta corretta, incrementiamo la LOL
              % solamente se questa non punta ad un altro cluster 
              elseif (nnl(i) && A.reticolo(nnl(i)))
                  A.label(i) = A.label(nnl(i));
                  if A.lol(A.label(i))>=0
                     A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                  end
         
              % non ha vicini 
              else, A.label(i) = largest_label; 
                    largest_label = largest_label +1;  
                    if A.lol(A.label(i))>=0
                        A.lol(A.label(i)) = A.lol(A.label(i)) +1;
                    end 
              end      
         end 
    end 
    

%++++++++++RICERCA DELLA PERCOLAZIONE+++++++++++++++++++++++++++++++++ 

    FR = nonzeros(unique(A.label(1,:)));    %prima riga 
    FC = nonzeros(unique(A.label(:,1)));    %prima colonna 
    LR = nonzeros(unique(A.label(end,:)));  %ultima riga 
    LC = nonzeros(unique(A.label(:,end)));  %ultima colonna

    for i=1:length(FR)
        if A.lol(FR(i)) < 0 
            ciclo = A.lol(FR(i)); 
            while true 
            ciclo = abs(ciclo);
                
                if A.lol(ciclo) > 0   
                    FR(i) = ciclo; 
                    break
                
                elseif A.lol(ciclo) < 0
                   ciclo = (A.lol(ciclo));
    
                end 
            end
        end 
    end 
    for i=1:length(LC)
        if A.lol(LC(i)) < 0 
            ciclo = A.lol(LC(i)); 
            while true 
            ciclo = abs(ciclo);
                
                if A.lol(ciclo) > 0 
                   
                    LC(i) = ciclo; 
                    break
                
                elseif A.lol(ciclo) < 0
                   ciclo = (A.lol(ciclo));
    
                end 
            end
        end 
    end 
    for i=1:length(LR)
        if A.lol(LR(i)) < 0 
            ciclo = A.lol(LR(i)); 
            while true 
            ciclo = abs(ciclo);
                
                if A.lol(ciclo) > 0 
                     
                    LR(i) = ciclo; 
                    
                    break
                
                elseif A.lol(ciclo) < 0
                   ciclo = (A.lol(ciclo));
    
                end 
            end
        end 
    end
 A.orizPerc= intersect(FC,LC);
 A.vertPerc= intersect(FR,LR); 
   
end 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++