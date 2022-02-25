classdef Noise    
    properties
        name
        mu
        sigma
        values
    end
    
    methods
        function obj = Noise(tout, name, mu, sigma)
            obj.name = name;
            obj.mu = mu;
            obj.sigma = sigma;
            obj.values = normrnd(mu, sigma, [length(tout), 1]);
        end
    end
end

