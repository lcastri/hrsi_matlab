function gFv = vortex_gradient(Kr, dx_ho, dy_ho)
    eta = sqrt(dx_ho^2 + dy_ho^2);
    dx_Fv_x = -(Kr * 6 * dx_ho * dy_ho) / (2 * eta^5);
    dy_Fv_x = Kr / (eta^3) - (Kr * 6 * dy_ho^2) / (2 * eta^5);
    dx_Fv_y = - Kr / (eta^3) + (Kr * 6 * dx_ho^2) / (2 * eta^5);
    dy_Fv_y = (Kr * 6 * dy_ho * dx_ho) / (2 * eta^5);
    
    gFv = [dx_Fv_x, dy_Fv_x;
           dx_Fv_y, dy_Fv_y];
end

