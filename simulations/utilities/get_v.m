function v = get_v(Kv, theta, Fx, Fy, task_op, task, t, sat_op, max_v)
%get_v: compute linear velocity
% - param Kv: (float) linear velocity gain
% - param theta: (float) orientation
% - param Fx: (float) total force along x-axis
% - param Fy: (float) total force along y-axis
% - param task_op: (bool) task option
% - param task: (int) task duration (active only if task_op = True)
% - param t: (int) time step
% - param sat_op: (bool) velocity saturation option
% - param max_v: (float) max velocity (active only if sat_op = True)
% - return v: (float) linear velocity

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