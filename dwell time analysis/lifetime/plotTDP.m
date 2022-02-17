    %type:
    %caxis([3500 7000])
    %to set the color limits

function [X, Y, Z] = plotTDP(dwellData, res)
    
        %size of gaussians in TDP
    VAR = 0.001
    
    RESOLUTION = 800;
    
    X = linspace(-0.2, 1.2, res)';
    Y = X';

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
    
        %start and stop vectors
    start = dwellData(:, 1);
    stop = dwellData(:, 2);
    
    size(start)
    
        %build TDP function
    for j = (1:res)
        for i = (1:res)
            Z(j, i) = sum((1/(2*pi*VAR))*exp(-((X(i) - start).^2 + (Y(j) - stop).^2)/(2*VAR)));
        end
    end
    
    %figure, pcolor(X, Y, Z), colormap([0 0 0; jet]), shading flat, axis square tight
    
        %interpolate
    XI = linspace(-0.2, 1.2, RESOLUTION);
    ZI = interp2(X, Y, Z, XI', XI, 'cubic');
    figure, pcolor(XI', XI, ZI), colormap([1 1 1; jet]), shading flat, axis square tight