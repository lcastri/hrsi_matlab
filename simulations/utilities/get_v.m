function v = get_v(Kv, theta, Fx, Fy, task_op, task, t, sat_op, max_v)
    if (task_op && t > task) || ~task_op
        v = Kv*(Fx*cos(theta) + Fy*sin(theta));
        if sat_op
            if v > max_v
                v = max_v;
            elseif v < -max_v
                v = -max_v;
            end
        end
    else
        v = 0;
    end
end