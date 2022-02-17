function count=getDecay_J(dwellData, bounds)
    
    start_low = bounds(1);
    start_high = bounds(2);
    end_low = bounds(3);
    end_high = bounds(4);
    
    selection = find(dwellData(:,1) > start_low & dwellData(:,1) < start_high & dwellData(:,2) > end_low & dwellData(:,2) < end_high);
    i = 1; 
       for n = selection'
          count(i, 1) = dwellData(n, 3);
          i = i + 1;
      end
    count(:, 2)=log(count(:, 1)*0.05);
  %  x = linspace(1, 1000, 1000);
   % h = hist(count(:), x);
    %X = log(x*0.05)';
    %H = sqrt(h)';
    