function index = find_longest_path(set)
    longest_path = 0;
    for id = cell2mat(keys(set))
        h = set(id);
        if length(h.x) > longest_path
            longest_path = length(h.x);
            index = id;
        end
    end
end