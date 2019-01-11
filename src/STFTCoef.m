function [coffVal, nsc] = STFTCoef(pattern, fs, thres)
    nsc = 0.1 * fs;

    p = [];
    
    figure();
    p(1) = subplot(3, 1, 1);
    time = 1/fs:1/fs:length(pattern)/fs;
    plot(time, pattern, 'Color', [0.7, 0.6, 0.3]);

    p(2) = subplot(3, 1, 2);
    spectrogram(pattern - mean(pattern), hamming(800), 0, nsc, fs, 'yaxis');
    [~, ~ ,t,Pxx] = spectrogram(pattern - mean(pattern), hamming(nsc), 0, nsc, fs, 'yaxis');
    Sxx = 10 * log10(Pxx);
    meanSxx = mean(mean(Sxx));
%   maxSxx = max(max(Sxx));
%   caxis([meanSxx, maxSxx]);

    colorbar off
    Sxx(Sxx < meanSxx) = NaN;
    p(3) = subplot(3, 1, 3);
    hold on
    coffVal = nanmean(Sxx);
    plot(t, coffVal);
    plot(t, thres * ones(size(t)));
    linkaxes(p, 'x');
    xlim([t(1), t(end)]);
    
end