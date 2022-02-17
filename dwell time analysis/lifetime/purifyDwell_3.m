function dwellData_3 = purifyDwell_3(dwellData)
   
   D(:, 1)=dwellData(:, 1);
   D(:, 2)=dwellData(:, 2);
   D(:, 3)=dwellData(:, 3);
   D(:, 4)=1;
   NO = find(isnan(D(:, 2)'));
   first = NO+1;
   for n = first
       D(n, 4)=0;
   end
   f = find (D(:,4)'== 1);
       i = 1;
       for n = f
          dwellData_3(i, 1) = D(n, 1);
          dwellData_3(i, 2) = D(n, 2);
          dwellData_3(i, 3) = D(n, 3);
          i = i + 1;
      end
   
     