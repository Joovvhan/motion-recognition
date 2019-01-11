function PlotPatterns(patternCell, pattern)
    
    figure();
    plotNum = length(patternCell);
    x = floor(sqrt(plotNum));
    y = ceil(plotNum/x);
    
    X = x + 1;
    
    for i=1:plotNum
       subplot(X, y, i + y);
       plot(patternCell{i});
       
    end
    
    subplot(X, y, 1:y);
    plot(pattern);
    
end