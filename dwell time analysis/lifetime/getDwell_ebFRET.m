function dwellData = getDwell_ebFRET(pathData)
    
    fileno = pathData(:, 1);
    FRET = pathData(:, 2);
    ebPath = pathData(:, 3);
    
        %transition no
    t = 1;
        %frame no in current transition
    n = 1;
    for i=(1:(length(FRET)-1))
        
            %new file
        if diff(fileno(i:i+1))
            dwellData(t, :) = [FRET(i) NaN n ebPath(i)];
            t = t + 1;
            n = 1;
            continue;
        end
            
            %transition
        if diff(FRET(i:i+1))
            dwellData(t, :) = [FRET(i) FRET(i + 1) n ebPath(i)];
            t = t + 1;
            n = 1;        
            %no transition
        else
            n = n + 1;
        end
    end