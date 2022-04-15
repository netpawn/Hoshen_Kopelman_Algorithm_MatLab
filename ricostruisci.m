function A = ricostruisci()

%--------Ricostruzione della matrice con le etichette corrette---------
    % per ricostruire, cicliamo una volta l'intera matrice delle etichette
    % (A.label) e da qui utilizziamo il vettore A.lol per vedere che
    % etichetta mettere in ogni sito. Con questo metodo, può succedere che
    % il numero di una etichetta si perda - avremo un nuovo cluster dove
    % le etichette vanno da 2 a 4 perdendosi il 3 - ma questo non importa
    % perché non ci interessa con quale "nome o etichetta" venga chiamato
    % il cluster. L'importante è che sia separato dagli altri nel modo
    % corretto. 
    
    for i = 1:L^2 
      try % il try catch copre il caso in cui A.lol(A.label) restituisca unù
          % indice uguale a 0, non supportato da matlab. Questo caso però
          % ci serve perché indica il caso in cui incontriamo un sito vuoto
          % sulla matrice. In questo caso andremo a scrivere semplicemente
          % 0
            


          % Abbiamo 3 casi da coprire: 
          % Il caso in cui abbiamo incontrato un sito etichettato
          % positivamente e possiamo direttamente scriverlo nella ricostruita 

          if A.lol(A.label(i))> 0
            A.ricostruita(i) = A.label(i); 
            
          % Il caso in cui incotnriamo un sito che però punta ad un altro
          % cluster. Dobbiamo quindi risalire (usando il ciclo sotto) al
          % sito a cui punta e la sua etichetta corretta. 

            elseif A.lol(A.label(i))< 0 
            
            ciclo = A.lol(A.label(i)); 
            while true 
            ciclo = abs(ciclo);
                
                if A.lol(ciclo) > 0 
                    A.ricostruita(i) = ciclo;
                    break
                
                elseif A.lol(ciclo) < 0
                   ciclo = (A.lol(ciclo));
    
                end 
            end
         end 

      catch %vedi sopra - Caso in cui c'è uno 0, mettiamo uno 0 
            A.ricostruita(i) = 0; 
      end 
    end 