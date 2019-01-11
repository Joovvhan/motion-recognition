function [rise, fall] = FindRiseAndFall(coeffVal, thres)
    coeffVal_ = [coeffVal(2:end), NaN];
    rise = find((coeffVal < thres) & (coeffVal_ > thres) == 1);
    fall = find((coeffVal > thres) & (coeffVal_ < thres) == 1);
end