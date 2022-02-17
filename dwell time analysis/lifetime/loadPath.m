function pathData = loadPath()
    
        i = 1;
        filename = [int2str(i) 'path.dat'];
        while(exist(filename))
            disp(['reading file ' int2str(i)])
            newPathData = load(filename);
            FRET = newPathData(:, 5);
            if (i == 1)
                pathData = [i*ones(length(FRET), 1) FRET];
            else
                %size(pathData)
                %size(FRET)
                %size([i*ones(length(FRET)) FRET])
                pathData = [pathData; i*ones(length(FRET), 1) FRET];
            end
            i=i+1;
            filename = [int2str(i) 'path.dat'];
        end