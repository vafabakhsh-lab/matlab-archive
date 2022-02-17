function N = TransitionEventN(dwellData, bounds)
    
    start_low = bounds(1);
    start_high = bounds(2);
    end_low = bounds(3);
    end_high = bounds(4);
    
    selection = find(dwellData(:,1) > start_low & dwellData(:,1) < start_high & dwellData(:,2) > end_low & dwellData(:,2) < end_high);
    A = size(selection);
    N = A(1)
    %figure, plot(ts, N, '.')
    %title(['Decay curve for state bounded by: start=[' num2str(start_low) ', ' num2str(start_high) '], end=[' num2str(end_low) ', ' num2str(end_high) ']'])
    %ylabel('Population')
    %xlabel('t (s)')