classdef myNoise    
    properties
        name
        mu
        sigma
        values
    end
    
    methods
        function obj = myNoise(tout, name, mu, sigma)
            %Noise: class constructor
            % - param tout: (array) time vector
            % - param name: (string) name associated to this noise
            % - param mu: (float) noise mean
            % - param sigma: (float) noise std
            obj.name = name;
            obj.mu = mu;
            obj.sigma = sigma;
            obj.values = normrnd(mu, sigma, [length(tout), 1]);
        end
    end
end

