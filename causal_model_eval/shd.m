function SHD = shd(ground, struct, pval, alphas)
    SHD = zeros(size(alphas));
    for a = 1 : length(alphas)
        % generate new struct matrix by checking alpha threshold
        new_struct = struct;
        for var = 1 : length(struct)
            for parent = 1 : length(struct)
                if pval(var, parent) > alphas(a)
                    new_struct(var, parent) = 0;
                end
            end
        end
    
        % computing SHD
        shd = 0;
        for var = 1 : length(new_struct)
            for parent = 1 : length(new_struct)
                if new_struct(var, parent) ~= ground(var, parent)
                    shd = shd + 1;
                end
            end
        end
        SHD(a) = shd;
    end
end

