function Fr = repulsive_force(Kr, dx_ho, dy_ho)
    Fr = [Kr * dx_ho / (sqrt(dx_ho^2 + dy_ho^2)^3), Kr * dy_ho / (sqrt(dx_ho^2 + dy_ho^2)^3)];
end

