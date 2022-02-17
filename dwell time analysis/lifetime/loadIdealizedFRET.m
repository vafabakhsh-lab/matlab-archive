function path = loadIdealizedFRET(IT)
    ms=size(IT);
    cols=ms(2);
    rows=ms(1);
    i=1;
    
    for j = 1:cols
         select = find (isnan((IT(:,j))));
         M = min(select)-1;
        for k = 1:M
                path(i,1) = j;
                path(i,2) = IT(k,j);
                i=i+1;
        end
    end
end

      