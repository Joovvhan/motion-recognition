function PlotStackedPattern(stackedPattern)

    figure();
    plotNum = size(stackedPattern, 1) + 1;
    x = ceil(sqrt(plotNum));
    y = ceil(plotNum/x);
    
    p = [];
    
    for i=1:size(stackedPattern, 1)
        p(i) = subplot(x, y, i);
        plot(stackedPattern(i, :), 'Color', [0.3, 0.4, 0.7]);
    end
    
    p(i+1) = subplot(x, y, i + 1);    
    plot(mean(stackedPattern, 1), 'Color', [0.7, 0.6, 0.3]);
    
    linkaxes(p, 'xy');
    
    hold off
end