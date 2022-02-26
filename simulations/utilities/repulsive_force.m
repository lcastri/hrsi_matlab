function Fr = repulsive_force(Kr, dx_ho, dy_ho)
%repulsive_force: compute repulsive force
% - param Kr: (float) repulsive gain
% - param dx_ho: (float) distance along x-axis agent-obs
% - param dy_ho: (float) distance along y-axis agent-obs
% - return Fr: (float) repulsive force

    Fr = [Kr * dx_ho / (sqrt(dx_ho^2 + dy_ho^2)^3), Kr * dy_ho / (sqrt(dx_ho^2 + dy_ho^2)^3)];
end

