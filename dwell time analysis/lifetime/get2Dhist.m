
function H = get2Dhist(cy3, cy5, cy3min, cy3max, cy5min, cy5max, bins)
    
    [cy3, cy5, labels]=removeLabels(cy3, cy5);
    ms=size(cy3);
        
        %save traces as single-row vectors with same length of individual traces
    if ms(2) > 1
        [cy3, L1]=makeVector(cy3);
        [cy5, L2]=makeVector(cy5, L1);
    end
    
        %something is wrong
    if length(cy3)~=length(cy5), return; end

        %build histogram
    X = linspace(cy3min,cy3max,bins)';
    Y = linspace(cy5min,cy5max,bins)';
    H = zeros(bins,bins) ;
    for i = 1:length(cy3)
        x = dsearchn(X,cy3(i)) ;
        y = dsearchn(Y,cy5(i)) ;
        H(y,x) = H(y,x) + 1 ;
    end ;
