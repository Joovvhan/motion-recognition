function corResult1 = AutoCorrelation(data)
    corResult2 = xcorr(data - mean(data));
    [~, idx] = max(corResult2);
    corResult1 = corResult2(idx:end);
    
    L = length(corResult1);
    
    for i=1:L
        corResult1(i) = corResult1(i) * L / (L - i + 1);
    end

end