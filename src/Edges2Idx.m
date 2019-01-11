function [rise_idx, fall_idx] = Edges2Idx(rise, fall, nsc)
    rise_idx = NaN(size(rise));
    fall_idx = NaN(size(fall));
    
    for i=1:length(rise)
        rise_idx(i) = floor((rise(i) - 1) * nsc + 1);
        fall_idx(i) = floor((fall(i)) * nsc);
    end
end