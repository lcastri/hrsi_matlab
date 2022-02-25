function [xmin, xmax, ymin, ymax] = find_axis(set)
    xmin = 10000000;
    ymin = 10000000;
    xmax = 0;
    ymax = 0;
    for id = cell2mat(keys(set))
        h = set(id);
        h_xmin = min(h.x);
        h_ymin = min(h.y);
        h_xmax = max(h.x);
        h_ymax = max(h.y);

        if h_xmin < xmin
            xmin = h_xmin;
        end
        if h_ymin < ymin
            ymin = h_ymin;
        end
        if h_xmax > xmax
            xmax = h_xmax;
        end
        if h_ymax > ymax
            ymax = h_ymax;
        end
    end
    xmin = xmin - 1000;
    xmax = xmax + 1000;
    ymin = ymin - 1000;
    ymax = ymax + 1000;
end

