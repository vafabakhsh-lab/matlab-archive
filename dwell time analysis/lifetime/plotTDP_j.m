    %type:
    %caxis([3500 7000])
    %to set the color limits

function [X, Y, Z] = plotTDP_j(dwellData, res)
    
        %size of gaussians in TDP
    VAR = 0.00075
    
    RESOLUTION = 800;
    
    X = linspace(-0.2, 1.2, res);
    Y = linspace(-0.2, 1.2, res);

        %remove NaN transitions
    n = 1;
    ms = size(dwellData);
    while n <= ms(1)
        if isnan(dwellData(n, 2))
            if n == 1
                dwellData = dwellData(2:ms(1), :);
            elseif n == ms(1)
                dwellData = dwellData(1:(n-1), :);
                break;
            else
                dwellData = [dwellData(1:(n-1), :); dwellData((n+1):ms(1), :)];
            end
            ms = size(dwellData);
        else
            n = n + 1;
        end
    end
    
       % start and stop vectors
   % start = dwellData(:, 1);
    %stop = dwellData(:, 2);
    
    ms=size(dwellData)
    rows=ms(1);
    
        %build TDP function
   %total=0;
   step=1.4/res;  
   Z=zeros(res, res);
     for j = (1:res-1)
        for i = (1:res-1)
            Z(j, i)=0;
            for k = 1:rows      
              if dwellData(k, 1) <= X(i+1) && dwellData(k, 1)>X(i) && dwellData(k, 2) <= Y(j+1) && dwellData(k, 2)>Y(j);
                 Z(j,i) = Z(j,i) + 1 ;
            end
         %   total=total+Z(Y(j), X(i));
        end
    end
end
 
   % total
   %figure, pcolor(X, Y, Z), colormap([1 1 1; JET]), shading flat, axis square tight
    
        %interpolate
    XI = linspace(-0.2, 1.2, RESOLUTION);
    %ZI = cubic(X, Y, Z, XI', XI);
    ZI = interp2(X, Y, Z, XI', XI, 'cubic');
    figure, pcolor(XI', XI, ZI); colormap([1 1 0.8; JET]);
    minimum = max(max(Z(:, :)))*0.15;
    maxium = max(max(Z(:, :)))*0.85;
    caxis([minimum, maxium]);
    shading flat, axis square tight;