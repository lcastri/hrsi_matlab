function g = get_free_place(H, t, main_g, goals)
    places = 1 : length(goals);
    occupied_places = [];
    for i = 1 : length(H)
        occupied_places(i) = H{i}.g_seq(t);
    end
    
    dist_from_main_g = [];
    free_places = setdiff(places, occupied_places); 
    for i = 1 : length(free_places)
        dist_from_main_g(i) = sqrt((goals(i,1)-main_g(1))^2+(goals(i,2)-main_g(2))^2);
    end
    [~, min_i] = min(dist_from_main_g);
    g = free_places(min_i);
end

