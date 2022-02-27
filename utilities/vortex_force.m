function Fv = vortex_force(Kr, dx_ho, dy_ho)
%vortex_force: compute vortex force
% - param Kv: (float) vortex gain
% - param dx_ho: (float) distance along x-axis agent-obs
% - param dy_ho: (float) distance along y-axis agent-obs
% - return Fv: (float) vortex force

    Fv = [Kr * dy_ho / (sqrt(dx_ho^2 + dy_ho^2)^3), -Kr * dx_ho / (sqrt(dx_ho^2 + dy_ho^2)^3)];
end

