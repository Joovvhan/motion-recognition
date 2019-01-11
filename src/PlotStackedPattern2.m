function PlotStackedPattern2(stackedPattern)
    figure();
    plotNum = size(stackedPattern, 1);
    hold on
    
    for i=1:size(stackedPattern, 1)
        plot(stackedPattern(i, :), 'Color', [0.3, 0.4, 0.7, 1/plotNum]);
    end
   
    plot(mean(stackedPattern, 1), 'Color', [0.7, 0.6, 0.3]);
    
    hold off
end