function eq = getEquilib(pathData, bounds)
    
    start_low = bounds(1);
    start_high = bounds(2);
    end_low = bounds(3);
    end_high = bounds(4);
    
    selection1 = find(pathData(:,2) > start_low & pathData(:,2) < start_high);
    selection2 = find(pathData(:,2) > end_low & pathData(:,2) < end_high);
    
    sel1 = length(selection1);
    sel2 = length(selection2);
    
    eq = sel1/sel2;
    
  
    
    
    