function idx = Edge2Idx(edge, nsc)
    idx = floor((edge - 0.5) * nsc + 1);
end