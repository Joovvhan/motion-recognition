function [rise, fall] = MergeEdges(rise, fall, dis)

    for i=length(rise) - 1:-1:1
        last = fall(i);
        nextFirst = rise(i+1);
        
        if (nextFirst < last + dis)
            fall(i) = [];
            rise(i+1) = [];
        end
    end
    
end