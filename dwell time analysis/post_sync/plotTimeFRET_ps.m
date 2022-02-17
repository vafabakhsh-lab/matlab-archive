    %Generates and plots a 2D histogram of the FRET time evolution.
    %'FRETbins' and 'Tbins' are the number of bins in each dimension.
    %cutoffT is the cutoff time in datapoints. If no cutoff time is given,
    %no cutoff is applied.

    %default parameters:
    %plotTimeFRET_ps(cy3x, cy5x, 24, 2, 3);
    % use postSync_3 function, automatically delete the traces that don't
    % show the transition to the limit FRET value.
    % use postSync function, don't delete the traces that don't show the
    % transition to the limit FREt value
function [T, Y, H] = plotTimeFRET_ps(cy3, cy5, FRETbins, Tbinsize, cutoffT)

        %Post-synchronization limit
    LIMIT = 0.25;

        %Exposure time = 50 ms
    FPS = 10;
    
        %Minimum/maximum count shown
    MINCOUNT = 4;
    MAXCOUNT = 16;
    RESOLUTION = 800;
    WHITE = 5;

    F = postSync_3(cy3, cy5, LIMIT);
    ms=size(F);

        %generate the histogram
    T = (Tbinsize:Tbinsize:ms(1))'/FPS;
    Y = linspace(-0.2, 1.2, FRETbins)';
    H = getTimeFRET(F, FRETbins, Tbinsize);
    
        %apply cutoff in time dimension
    if nargin == 5
        cutoffT = cutoffT*FPS;
        T = T(1:min(floor(cutoffT/Tbinsize), ms(1)));
        H = H(:, 1:min(floor(cutoffT/Tbinsize), ms(1)));
    end
    
    TI = linspace(min(T), max(T), RESOLUTION);
    YI = linspace(-0.2, 1.2, RESOLUTION);
    HI = interp2(T', Y, H, TI', YI, 'cubic');

        %plot figure
    figure, pcolor(TI', YI, HI); 
    colormap([1 1 0.8; ones(WHITE, 3); JET]);
    hold on
    
    MAXCOUNT = max(max(H))*0.75;
    
        %minimum intensity: MINCOUNT
        %minimum intensity: MAXCOUNT
    caxis([MINCOUNT MAXCOUNT]);
    axis([min(T) max(T) min(Y) max(Y)]);
    
        %plot contour lines
    %contour(T, Y, H, (MINCOUNT:1:MAXCOUNT))
     
    colorbar; shading interp; axis tight square;
    
        %add labels
    xlabel('T (seconds)') ; ylabel('FRET') ; title('FRET Time Evolution Histogram') ;
    
        %set tick marks between data points
    %set(gca,'XTick',([2*T(1):2*(T(2)-T(1)):max(T)] + T(1)/2))
    %set(gca,'XTickLabel',T)