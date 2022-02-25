function [cone, collision, risk] = cone_building(A, a, obs, eta, t, DT)
    cone = nan;
    collision = false;
    risk = 0;
    if t < length(A{1}.x)
        Va = [A{a}.x(t) - A{a}.x(t-1);
              A{a}.y(t) - A{a}.y(t-1)];
        Vobs = [A{obs}.x(t) - A{obs}.x(t-1);
                A{obs}.y(t) - A{obs}.y(t-1)];
        if sum(isnan(Va)) == 0 && sum(isnan(Vobs)) == 0
            Vrel = Va - Vobs;
            
            cone_origin = [A{a}.x(t-1) + Vobs(1);
                           A{a}.y(t-1) + Vobs(2)];
        
            % straight line from a to obs = r_{a_obs}
            slope_line_a_obs = (A{obs}.y(t-1) - A{a}.y(t-1)) / (A{obs}.x(t-1) - A{a}.x(t-1));
        
            % straight line perpendicular to r_{a_obs} and passing through obs
            slope_pline = -1/slope_line_a_obs;
            intercept = slope_pline*(-A{obs}.x(t-1)) + A{obs}.y(t-1);
            [x_intersection, y_intersection] = linecirc(slope_pline, intercept, A{obs}.x(t-1), A{obs}.y(t-1), eta*1000);
            x_intersection = x_intersection + Vobs(1);
            y_intersection = y_intersection + Vobs(2);
            
            % cone 
            cone = [cone_origin(1) x_intersection(1) x_intersection(2);
                    cone_origin(2) y_intersection(1) y_intersection(2)];
            
            % collision evaluation
            collision = inpolygon(cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), cone(1,:), cone(2,:));
            if collision
                time_collision_measure = sqrt(Vrel(1)^2 + Vrel(2)^2)*((1/1000)/DT);
                w_effort_measure_1 = point_to_line([cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), 1], [cone_origin', 1], [x_intersection(1), y_intersection(1), 1]);
                w_effort_measure_2 = point_to_line([cone_origin(1) + Vrel(1), cone_origin(2) + Vrel(2), 1], [cone_origin', 1], [x_intersection(2), y_intersection(2), 1]);
                w_effort_measure = min(w_effort_measure_1, w_effort_measure_2);             
                risk = time_collision_measure + w_effort_measure/1000;
            end
        end
    end
end

