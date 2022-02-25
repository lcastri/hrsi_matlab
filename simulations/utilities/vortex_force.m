function Fv = vortex_force(Kr, dx_ho, dy_ho)
    Fv = [Kr * dy_ho / (sqrt(dx_ho^2 + dy_ho^2)^3), -Kr * dx_ho / (sqrt(dx_ho^2 + dy_ho^2)^3)];
end

