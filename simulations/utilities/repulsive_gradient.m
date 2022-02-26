function gFr = repulsive_gradient(Kr, dx_ho, dy_ho)
%repulsive_gradient: compute gradient repulsive force
% - param Kr: (float) repulsive gain
% - param dx_ho: (float) distance along x-axis agent-obs
% - param dy_ho: (float) distance along y-axis agent-obs
% - return gFr: (float) gradient repulsive force

    eta = sqrt(dx_ho^2 + dy_ho^2);
    dx_Fr_x = Kr / (eta^3) - (Kr * 6 * dx_ho^2) / (2 * eta^5);
    dy_Fr_x = -(Kr * 6 * dy_ho * dx_ho) / (2 * eta^5);
    dx_Fr_y = -(Kr * 6 * dx_ho * dy_ho) / (2 * eta^5);
    dy_Fr_y = Kr / (eta^3) - (Kr * 6 * dy_ho^2) / (2 * eta^5);

    gFr = [dx_Fr_x, dy_Fr_x;
           dx_Fr_y, dy_Fr_y];
end


