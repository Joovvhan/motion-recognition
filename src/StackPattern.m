function patternMat = StackPattern(data, locs, period)
    
    patternCell = cell(length(locs) - 1, 1);
    
    for i=1:length(locs) - 1
        patternCell{i} = data(locs(i):locs(i) + period)';
    end

    patternMat = cell2mat(patternCell);

end