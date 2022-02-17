function dwellData_s = purifyDwellJF(dwellData)
   
        ms = size(dwellData);

            %locate significant & unsignificant transitions
        signif = find(dwellData(:, 3)'>= 2);
        i = 1;
        for n = signif 
            dwellData_s(i, :) = dwellData(n, :);
            i = i + 1;
        end
 