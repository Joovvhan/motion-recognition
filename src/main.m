clear
close all

load("../data/Data_Challenge.mat");

%% Parameter Setting
fs = 8000;
guessPeriod = 10;

%% Data1
thresSTFT = -102;
minEdgeDis = 1;

%% Data2
% thresSTFT = -102.5;
% minEdgeDis = 3;

%% 
targetData = data(:, 1);

%%
autoCor = AutoCorrelation(targetData);
autoCor = autoCor(1:floor(length(autoCor) * 4/5));

%%
[pks,locs] = findpeaks(autoCor, 'MinPeakDistance', guessPeriod * fs);
PlotPeak(autoCor, locs);

%%
meanPeriod = floor(mean(diff(locs)));
patternMat = StackPattern(targetData, locs, meanPeriod);
patternDet = mean(patternMat, 1);

PlotStackedPattern(patternMat);
PlotStackedPattern2(patternMat);

%%
[coeffVal, nsc] = STFTCoef(patternDet, fs, thresSTFT);
[edgeRise, edgeFall] = FindRiseAndFall(coeffVal, thresSTFT);

[edgeRise, edgeFall] = MergeEdges(edgeRise, edgeFall, minEdgeDis);
[idx_rise, idx_fall] = Edges2Idx(edgeRise,edgeFall, nsc);

patterns = cell(length(idx_rise), 1);
patternIdxes = NaN(length(idx_rise), 1);
for i=1:length(patterns)
    patterns{i} = patternDet(idx_rise(i):idx_fall(i));
    patternIdxes(i) = idx_rise(i);
end

%%
PlotPatterns(patterns, patternDet);

for i=1:length(patterns)
    patLen = length(patterns{i});
    
    plotNum = floor((length(targetData) - meanPeriod - patternIdxes(i))/meanPeriod);
    x = floor(sqrt(plotNum));
    y = ceil(plotNum/x);
    
    p=[];
    
    figure();
    for j=1:plotNum
        p(j) = subplot(x, y, j);
        start = patternIdxes(i) + meanPeriod  * (j - 1);
        last = start + patLen;
        startGuess = start - floor(patLen/4);
        corV = -inf(ceil(patLen/2), 1);
        
        parfor k=1:floor(1/2 * patLen)
            corV(k) = targetData(startGuess + k:startGuess + k + patLen - 1)' * patterns{i}';
        end
        
        [~, idx] = max(corV);
        optStart = startGuess + idx;
        optLast = optStart + patLen;
        plot(targetData(optStart:optLast));
    end
    
    linkaxes(p, 'xy');
end