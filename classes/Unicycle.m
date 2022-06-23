classdef Unicycle < Agent

    properties
        Kv
        Kw
        d_a
        theta_a
        risk_a
        collision_a
        g_seq
        g
        g_changed
        interaction
        sat_op
        max_v
        task_op
        task
        obs
        L
        risk
        collision
        just_turn
    end
    
    methods (Access=public)
        function obj = Unicycle(id, color, Ka, Kr, eta_0, x, y, theta, tout, rep_force_type, n_agent, L, sat_op, max_v, task_op, Kv, Kw)
            %Unicycle: class constructor
            % - param id: (integer) number associated to this agent
            % - param color: (char) color associated to this agent (example 'k', 'r')
            % - param Ka: (float) attractive gain
            % - param Kr: (float) repulsive gain
            % - param eta_0: (float) minimum distance from obstacles
            % - param x: (float) initial pos-x
            % - param y: (float) initial pos-y
            % - param theta: (float) initial orientation
            % - param tout: (array) time vector
            % - param n_agent: (int) number of agent in the scenario
            % - param L: (float) length orientation arrow
            % - param sat_op: (bool) velocity saturation option
            % - param max_v: (float) max velocity (active only if sat_op = True)
            % - param task_op: (bool) task option
            % - param Kv: (float) linear velocity gain
            % - param Kw: (float) angular velocity gain
            
            % parent constructor
            obj@Agent(id, color, Ka, Kr, eta_0, x, y, theta, tout, rep_force_type);
            obj.x = zeros(length(tout),1);
            obj.y = zeros(length(tout),1);
            obj.theta = zeros(length(tout),1);
            obj.d_a = zeros(length(tout), n_agent);
            obj.theta_a = zeros(length(tout), n_agent);
            obj.risk_a = zeros(length(tout), n_agent);
            obj.collision_a = zeros(length(tout), n_agent);
            obj.g_seq = zeros(length(tout), 1);
            obj.g_changed = zeros(length(tout), 1);
            obj.interaction = zeros(length(tout), n_agent);
            obj.risk = zeros(length(tout), 1);
            
            obj.Kv = Kv;
            obj.Kw = Kw;
            obj.x(1) = x;
            obj.y(1) = y;
            obj.theta(1) = theta;
            obj.v(1) = 0;
            obj.w(1) = 0;
            obj.L = L;
            obj.sat_op = sat_op;
            obj.max_v = max_v;
            obj.task_op = task_op;
            obj.task = 0;

        end

        function draw(obj, t)
            % draw: Draw unicycle as a point and an arrow.
            
            % draw position
            plot(obj.x(t), obj.y(t), '.', 'MarkerSize', 35, 'Color', obj.color)
            hold on

            % draw id
            text(obj.x(t)+0.35, obj.y(t), string(obj.id), 'Color','m')
            hold on

            % draw orientation
            quiver(obj.x(t), obj.y(t), obj.L*cos(obj.theta(t)), obj.L*sin(obj.theta(t)), 0, 'Color', obj.color, 'MaxHeadSize', 1);
            hold on

            % draw goal bearing
            line([obj.x(t) obj.x(t) + obj.L*cos(obj.theta_a(t, obj.g_seq(t)))], [obj.y(t) obj.y(t) + obj.L*sin(obj.theta_a(t, obj.g_seq(t)))], 'Color', obj.color);

            % draw interactions
            for o = obj.obs
                if obj.interaction(t, o.id)
                    line([obj.x(t) o.x(t)], [obj.y(t) o.y(t)], 'Color', 'm');
                end
            end
        end
        
        function set_obs(obj, obs, t)
            %set_obs: Set an agent as obstacle
            % - param obs: (agent) agent to set as obstacle for this agent

            obj.obs = obs;
            if t == 1
                obj.measure_obs(t)
            end
        end
        
        function obs = get_closest_obs(obj, t)
            %get_closest_obs: return the closest obstacle
            % - param t: (int) time step
            % - return obs: (agent) closest obstacle
            
            n_goals = size(obj.d_a,2) - length(obj.obs);
            d_obs = obj.d_a(t, n_goals + 1 : end);
            [~, min_index] = min(d_obs);
            obs = obj.obs(min_index);
        end
        
        function measure_risk(obj, t, varargin)
            %measure_risk: measure risk by cone analysis
            % - param t: (int) time step
            % - param varargin: [optional] (float) risk noise

            minArgs = 2;
            noise_risk = zeros(size(obj.d_a));
            if nargin > minArgs
                noise_risk = varargin{1};
            end
            
            if ~isempty(obj.obs)
                for o = obj.obs
                    obj.risk_a(t, o.id) = exp(obj.v(t-1));
                    if obj.d_a(t-1, o.id) < obj.eta_0
                        [col, r] = obj.build_cone(o, t);
                        if col
                            obj.risk_a(t, o.id) = obj.risk_a(t, o.id)*exp(r);
                        end
                        obj.collision_a(t, o.id) = col;
                    end
                    obj.risk_a(t, o.id) = obj.risk_a(t, o.id) + noise_risk;
                end
                obj.risk(t) = sum(obj.risk_a(t, :));

            end
        end

        function measure_obs(obj, t, varargin)
            %measure_obs: wrap function for range_obs and bearing_obs
            % - param t: (int) time step
            % - param varargin1: [optional] (float) range noise
            % - param varargin2: [optional] (float) bearing noise

            minArgs = 2;
            noise_range = 0;
            noise_bearing = 0;
            if nargin > minArgs
                noise_range = varargin{1};
                noise_bearing = varargin{2};
            end
            for o = obj.obs
                obj.range_obs(t, o, noise_range);
                obj.bearing_obs(t, o, noise_bearing);
            end
        end

        function measure_g(obj, t, varargin)
            %measure_g: wrap function for range_g and bearing_g
            % - param t: (int) time step
            % - param varargin1: [optional] (float) range noise
            % - param varargin2: [optional] (float) bearing noise
            
            minArgs = 2;
            noise_range = 0;
            noise_bearing = 0;
            if nargin > minArgs
                noise_range = varargin{1};
                noise_bearing = varargin{2};
            end
            obj.range_g(t, noise_range);
            obj.bearing_g(t,noise_bearing);
        end

        function set_goal(obj, goal, t)
            %set_goal: set position goal (agent)
            % - param goal: (agent) agent to reach
            % - param t: (int) time step
            if t > 1
                if goal.id ~= obj.g_seq(t-1)
                    obj.just_turn = true;
                end
            end
            obj.g_seq(t) = goal.id;
            obj.g = goal;
            if t == 1
                obj.measure_g(t)
            end
        end
        
        function compute_next_state(obj, t, DT)
            %compute_next_state: compute next state x,y,theta
            % - param t: (int) time step
            % - param DT: (float) delta time
            
            obj.x(t) = obj.x(t-1) + DT*obj.v(t-1)*cos(obj.theta(t-1));
            obj.y(t) = obj.y(t-1) + DT*obj.v(t-1)*sin(obj.theta(t-1));
            obj.theta(t) = obj.theta(t-1) + DT*obj.w(t-1);
        end

        function compute_v(obj, t, Ft, varargin)
            %compute_v: compute new linear velocity
            % - param t: (int) time step
            % - param Ft: (float) total force
            % - param varargin: [optional] (float) linear velocity noise
            
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            Fx = Ft(1);
            Fy = Ft(2);
            if (obj.task_op && t > obj.task) || ~obj.task_op
                v = obj.Kv*(Fx*cos(obj.theta(t-1)) + Fy*sin(obj.theta(t-1)));
                if obj.sat_op
                    if v > obj.max_v
                        v = obj.max_v;
                    elseif v < -obj.max_v
                        v = -obj.max_v;
                    end
                end
            else
                v = 0;
            end
            obj.v(t) = v + noise;
        end

        function compute_w(obj, t, Ft, gFt, varargin)
            %compute_w: compute new angular velocity
            % - param t: (int) time step
            % - param Ft: (float) total force
            % - param gFt: (float) gradient of total force
            % - param varargin: [optional] (float) angular velocity noise
            
            minArgs = 4;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            Fx = Ft(1);
            Fy = Ft(2);
            if (obj.task_op && t > obj.task) || ~obj.task_op
                nFt = sqrt(Fx^2+Fy^2);
                t_a = atan2(Fy, Fx);
                theta_d = obj.theta(t-1) - asin(sin(obj.theta(t-1) - t_a));
        
                first_term = -obj.Kw*(obj.theta(t-1) - theta_d)/(sign(cos(obj.theta(t-1) - t_a)));
                if nFt ~= 0 
                    second_term = obj.v(t-1)/power(nFt,2)*([-Fy Fx] * gFt * [cos(obj.theta(t-1)); sin(obj.theta(t-1))]);
                else
                    second_term = 0;
                end
                w = first_term + second_term;
                if obj.v(t-1) ~= 0
                    w = sign(obj.v(t-1)) * w;
                end
            else
                w = 0;
            end
            obj.w(t) = w + noise;
        end
        
        function compute_next_inputs(obj, t, Ft, gFt, varargin)
            %compute_w: wrap function for compute_v and compute_w
            % - param t: (int) time step
            % - param Ft: (float) total force
            % - param gFt: (float) gradient of total force
            % - param varargin1: [optional] (float) linear velocity noise
            % - param varargin2: [optional] (float) angular velocity noise

            
            minArgs = 4;
            noise = [0 0];
            if nargin > minArgs
                noise(1) = varargin{1};
                noise(2) = varargin{2};
            end
            if obj.just_turn
                if abs(obj.theta_a(t, obj.g_seq(t)) - obj.theta(t)) > 0.01
                    obj.v(t) = noise(1);
                    obj.w(t) = obj.Kw * (atan2(Ft(2), Ft(1)) - obj.theta(t)) + noise(2);

                else
                    obj.just_turn = false;
                end
            else
                obj.compute_v(t, Ft, noise(1))
                obj.compute_w(t, Ft, gFt, noise(2))     
            end
        end
        
        function range_g(obj, t, varargin)
            %range_g: compute distance to the goal
            % - param t: (int) time step
            % - param varargin: [optional] (float) range noise

            minArgs = 2;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.d_a(t, obj.g_seq(t)) = sqrt((obj.g.x(t) - obj.x(t))^2 + (obj.g.y(t) - obj.y(t))^2) + noise;
        end

        function bearing_g(obj, t, varargin)
            %bearing_g: compute angle to the goal
            % - param t: (int) time step
            % - param varargin: [optional] (float) bearing noise
            
            minArgs = 2;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.theta_a(t, obj.g_seq(t)) = atan2(obj.g.y(t) - obj.y(t), obj.g.x(t) - obj.x(t)) + noise;
        end

        function range_obs(obj, t, obs, varargin)
            %range_obs: compute distance to the obstacle
            % - param t: (int) time step
            % - param obs: (agent) obstacle
            % - param varargin: [optional] (float) range noise
            
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.d_a(t, obs.id) = sqrt((obj.x(t) - obs.x(t))^2 + (obj.y(t) - obs.y(t))^2) + noise;
        end

        function bearing_obs(obj, t, obs, varargin)
            %bearing_obs: compute angle to the obstacle
            % - param t: (int) time step
            % - param obs: (agent) obstacle
            % - param varargin: [optional] (float) beearing noise
            
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.theta_a(t, obs.id) = atan2(obj.y(t) - obs.y(t), obj.x(t) - obs.x(t)) + noise;
        end
        
        function [Ft, gFt] = total_force_field(obj, t)
            %total_force_field: compute attractive and repulsive forces
            % - param t: (int) time step
            % - return Ft: (float) total force
            % - return gFt: (float) gradient of total force
            
            Fr = [0 0];
            gFr = [0 0; 0 0];
            [Fa, gFa] = obj.goal_force(t);
            for o = obj.obs
                [Fr_o, gFr_o] = obj.obs_force(t, o, obj.collision_a(t, o.id));
                Fr = Fr + Fr_o;
                gFr = gFr + gFr_o;

            end
            Ft = Fa + Fr;
            gFt = gFa + gFr;
        end
        
    end
    
    methods (Access=private)
        
        function [collision, risk] = build_cone(obj, obs, t)
            %build_cone: cone analysis between two agents
            % - param obs: (agent) obstacle for cone computation
            % - param t: (int) time step
            % - return collision: (bool) collision detected by cone analysis
            % - return risk: (float) risk measure

            
            risk = 0;
            
            Va = [obj.x(t) - obj.x(t-1);
                  obj.y(t) - obj.y(t-1)];
            Vobs = [obs.x(t) - obs.x(t-1);
                    obs.y(t) - obs.y(t-1)];
            Vrel = Va - Vobs;

            cone_origin = [obj.x(t-1) + Vobs(1);
                           obj.y(t-1) + Vobs(2)];

            % straight line from a to obs = r_{a_obs}
            slope_line_obj_obs = (obs.y(t-1) - obj.y(t-1)) / (obs.x(t-1) - obj.x(t-1));

            % straight line perpendicular to r_{obj_obs} and passing through obs
            slope_pline = -1/slope_line_obj_obs;
            intercept = slope_pline*(-obs.x(t-1)) + obs.y(t-1);
            [x_intersection, y_intersection] = linecirc(slope_pline, intercept, obs.x(t-1), obs.y(t-1), obj.eta_0);
            x_intersection = x_intersection + Vobs(1);
            y_intersection = y_intersection + Vobs(2);

            % cone 
            cone = [cone_origin(1) x_intersection(1) x_intersection(2);
                    cone_origin(2) y_intersection(1) y_intersection(2)];

            % collision evaluation
            collision = inpolygon(cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), cone(1,:), cone(2,:));
            if collision
                time_collision_measure = sqrt(Vrel(1)^2 + Vrel(2)^2);
                w_effort_measure_1 = point_to_line([cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), 1], [cone_origin', 1], [x_intersection(1), y_intersection(1), 1]);
                w_effort_measure_2 = point_to_line([cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), 1], [cone_origin', 1], [x_intersection(2), y_intersection(2), 1]);
                w_effort_measure = min(w_effort_measure_1, w_effort_measure_2);             
                risk = time_collision_measure + w_effort_measure;
            end
        end
               
        function [Fa, gFa] = goal_force(obj, t)
            %goal_force: compute attractive force due to the goal
            % - param t: (int) time step
            % - return Fa: (float) attractive force
            % - return gFa: (float) gradient of attractive force
            
            [dx_gh, dy_gh] = dxdy(obj.d_a(t-1, obj.g_seq(t-1)), obj.theta_a(t-1, obj.g_seq(t-1)));
            Fa = attractive_force(obj.g.Ka, dx_gh, dy_gh);
            gFa = attractive_gradient(obj.g.Ka);
        end

        function [Fr, gFr] = obs_force(obj, t, obs, collision)
            %goal_force: compute repulsive or vortex force due to the obstacle
            % - param t: (int) time step
            % - param obs: (agent) obstacle
            % - param collision: (bool) collision bit compute by measure_risk
            % - return Fr: (float) repulsive or vortex force
            % - return gFr: (float) gradient of repulsive or vortex force
            
            Fr = [0 0];
            gFr = [0 0; 0 0];
            [dx_hh, dy_hh] = dxdy(obj.d_a(t-1, obs.id), obj.theta_a(t-1, obs.id));

            if collision && obj.d_a(t-1, obs.id) < obs.eta_0
                obj.interaction(t, obs.id) = true;
                switch obs.rep_force_type
                    case Rep_force.REPULSIVE
                        Fr = repulsive_force(obs.Kr, dx_hh, dy_hh);
                        gFr = repulsive_gradient(obs.Kr, dx_hh, dy_hh);
                    case Rep_force.VORTEX
                        Fr =  vortex_force(obs.Kr, dx_hh, dy_hh);
                        gFr = vortex_gradient(obs.Kr, dx_hh, dy_hh);
                end
            end
        end
    end
end

