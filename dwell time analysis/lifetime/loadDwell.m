function dwellData = loadDwell()
    
        i = 1;
        filename = [int2str(i) 'dwell.dat'];
        while(exist(filename))
            disp(['reading file ' int2str(i)])
            newDwellData = load(filename);
            if (i == 1)
                dwellData = newDwellData;
            else
                dwellData = [dwellData; newDwellData];
            end
            i=i+1;
            filename = [int2str(i) 'dwell.dat'];
        end