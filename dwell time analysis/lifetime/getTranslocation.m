function [ts, N] = gettranslocation(X)

    %selection = find(dwellData(:,1) > start_low & dwellData(:,1) < start_high & dwellData(:,2) > end_low & dwellData(:,2) < end_high);
    maxT = max(X(:));
    t = 1:1:(maxT+1);
    ts = t*0.1;
    for i = t
        N(i) = length(find(X> t(i)));
    end
    
    %figure, plot(ts, N, '.')
    %title(['Decay curve for state bounded by: start=[' num2str(start_low) ', ' num2str(start_high) '], end=[' num2str(end_low) ', ' num2str(end_high) ']'])
    %ylabel('Population')
    %xlabel('t (s)')