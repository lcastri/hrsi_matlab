function w = get_w(Kw, Fx, Fy, theta, v, gFt, task_op, task, t)
%get_w: compute angular velocity
% - param Kw: (float) angular velocity gain
% - param Fx: (float) total force along x-axis
% - param Fy: (float) total force along y-axis
% - param theta: (float) orientation
% - param v: (float) linear velocity
% - param gFt: (float) gradient of total force
% - param task_op: (bool) task option
% - param task: (int) task duration (active only if task_op = True)
% - param t: (int) time step
% - return w: (float) linear velocity

    if (task_op && t > task) || ~task_op
        nFt = sqrt(Fx^2+Fy^2);
        theta_a = atan2(Fy, Fx);
        theta_d = theta - asin(sin(theta - theta_a));

        first_term = -Kw*(theta - theta_d)/(sign(cos(theta - theta_a)));
        if nFt ~= 0 
            second_term = v/power(nFt,2)*([-Fy Fx] * gFt * [cos(theta); sin(theta)]);
        else
            second_term = 0;
        end
        w = sign(v) * (first_term + second_term);
    else
        w = 0;
    end
end