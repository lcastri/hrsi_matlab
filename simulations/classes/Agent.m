classdef Agent < handle

    properties
        id
        x
        y
        theta
        v
        w
        Ka
        Kr
        eta_0
        color
        rep_force_type
    end
    
    methods
        function obj = Agent(id, color, Ka, Kr, eta_0, x, y, theta, tout, rep_force_type)
            %Agent: class constructor
            % - param id: (integer) number associated to this agent
            % - param color: (char) color associated to this agent (example 'k', 'r')
            % - param Ka: (float) attractive gain
            % - param Kr: (float) repulsive gain
            % - param eta_0: (float) minimum distance from obstacles
            % - param x: (float) initial pos-x
            % - param y: (float) initial pos-y
            % - param theta: (float) initial orientation
            % - param tout: (array) time vector
            % - param rep_force_type: (enum) example REPULSIVE, VORTEX
            
            obj.id = id;
            obj.x = x*ones(length(tout),1);
            obj.y = y*ones(length(tout),1);
            obj.theta = theta*ones(length(tout),1);
            obj.v = zeros(length(tout),1);
            obj.w = zeros(length(tout),1);
            obj.Ka = Ka;
            obj.Kr = Kr;
            obj.eta_0 = eta_0;
            obj.color = color;
            obj.rep_force_type = rep_force_type;

            obj.x(1) = x;
            obj.y(1) = y;
            obj.theta(1) = theta;
            obj.v(1) = 0;
            obj.w(1) = 0;

        end

        function draw(obj, t)
            %draw: Draw current agent position
            % - param t: time step
            
            % draw position
            plot(obj.x(t), obj.y(t), 's', 'MarkerSize', 10, 'Color', obj.color)
            hold on

            % draw id
            text(obj.x(t)+0.25, obj.y(t), string(obj.id), 'Color','red')
            hold on
        end 
    end
end

