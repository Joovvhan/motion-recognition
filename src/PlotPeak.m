function PlotPeak(data, locs)
    figure();
    hold on
    plot(data);
    plot(locs, data(locs), 'o', 'markersize', 5);
end