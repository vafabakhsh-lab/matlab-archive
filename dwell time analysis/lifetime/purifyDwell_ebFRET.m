function dwellData_s = purifyDwell_ebFRET(dwellData, signif_trans)
    

        %transition magnitude vector
    dif = diff([dwellData(:, 2)'; dwellData(:,1)']);

           %repeat until there are no more unsignificant transitions
    if    length(find(abs(dif) <= signif_trans)) > 0;  %Added by Reza to prevent crashing if there is no transitions to be removed.    
    while length(find(abs(dif) <= signif_trans)) 
        ms = size(dwellData);
                %transition magnitude vector
        dif = diff([dwellData(:, 2)'; dwellData(:,1)']);

            %locate significant & unsignificant transitions
        signif = find(abs(dif) > signif_trans | isnan(dif));
        unsignif = find(abs(dif) <= signif_trans);
    
            %for all unsignificant transitions, 
            %add dwelltime to next transition
            %and change the start FRET of next
        for n = unsignif
            if n < ms(1)
                    %same trace
                if dwellData(n+1, 1) == dwellData(n, 2)
                    dwellData(n+1, 3) = dwellData(n+1, 3) + dwellData(n, 3);
                    dwellData(n+1, 1) = dwellData(n, 1);
                    %new trace - add transition to NaN
                else
                    dwellData = [dwellData; dwellData(n, 1) NaN dwellData(n, 3)];
                    ms = size(dwellData);
                    signif = [signif  ms(1)];
                %last trace - add transition to NaN
                end
            else
                dwellData = [dwellData; dwellData(n, 1) NaN dwellData(n, 3) dwellData(n,4)];
                ms = size(dwellData);
                signif = [signif ms(1)];
            end
        end
        
            %delete unsignificant transitions
        i = 1;
        for n = signif
            dwellData_s(i, :) = dwellData(n, :);
            i = i + 1;
        end
        
        disp(['deleted ' int2str(length(unsignif)) ' unsignificant transitions'])
        
        dwellData = dwellData_s;
        dif = diff([dwellData(:, 2)'; dwellData(:,1)']);
    end                                                             %Added by Reza to prevent crashing if there is no transitions to be removed.
    else
        dwellData_s = dwellData;
    end