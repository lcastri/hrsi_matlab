function Fa = attractive_force(Ka, dx_gh, dy_gh)
%attractive_force: compute attractive force
% - param Ka: (float) attractive gain
% - param dx_gh: (float) distance along x-axis agent-goal
% - param dy_gh: (float) distance along y-axis agent-goal
% - return Fa: (float) attractive force

    Fa = [Ka * dx_gh, Ka * dy_gh];
end

