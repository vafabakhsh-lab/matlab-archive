function dwellData_j = purifyDwell_J(dwellData, frame)
   
D(:, 1)=dwellData(:, 1);
D(:, 2)=dwellData(:, 2);
D(:, 3)=dwellData(:, 3);
D(:, 4)=1;
   
   fluct = find(D(:, 3)'<= frame);
         for n = fluct
    
            %for all short transitions, 
            %add dwelltime to the previous transition
            %and change the start FRET of next
            
           if isnan(D(n, 2)) == 1 | isnan(D(n-1, 2))==1
                D(n, 4)=0;
                
            else if abs(D(n-1, 2)-D(n-1, 1))<=abs(D(n, 1)-D(n, 2))                                           
                       if D(n-1, 4)~=0
                           D(n-1, 2)=D(n, 2);
                           D(n-1, 3)=D(n-1, 3)+D(n, 3);
                           D(n, 4)=0; 
                       else
                       end
                 else 
                     if D(n+1, 4)~=0                       
                       D(n+1, 1)=D(n, 1);
                       D(n+1, 3)=D(n+1, 3)+D(n, 3);
                       D(n, 4)=0;
                     else
                     end 
                 end
             end
         end
                        
            %delete transitions shorter than the defined frame number
       E=find(D(:, 4)'~=0);
       i = 1;
       for n = E
          dwellData_j(i, 1) = D(n, 1);
          dwellData_j(i, 2) = D(n, 2);
          dwellData_j(i, 3) = D(n, 3);
          i = i + 1;
      end
      F = find(dwellData_j(:, 3)'<= frame);
      size(F);     
     