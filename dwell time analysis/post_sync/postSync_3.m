function F = postSync(cy3, cy5, limit)
% the function deletes the traces that don't sample the limit FRET value.
    
    Fs = getFRET2(cy3, cy5);
    
        %parameters 
    DELETE=10;
    AVER=2;
    KEEP=10;

    ms=size(Fs);
    cols=ms(2);
    rows=ms(1);
    
        %delete the first x frames (x=DELETE)
    Fs=Fs(DELETE:ms(1), :);
    
    ms=size(Fs);
    cols=ms(2);
    rows=ms(1);
    k=1;
    
    for j = 1:cols
        for i = 1:(rows-(KEEP+AVER))
            if mean(Fs(i:i+AVER,j))>limit
                    %make timepoint (i-KEEP) time zero if it is positive
                newTrace = Fs(max((i-KEEP), 1):rows, j);
                F(:, k) = NaN;
                F(1:length(newTrace), k) = newTrace;
                k=k+1;
                %  else F(:,j) = NaN;
                    %skip to next trace
              break;
            end
        end
    end