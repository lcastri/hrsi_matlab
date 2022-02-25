function [dx, dy] = dxdy(d, alpha)
    theta = pi/2 - alpha;
    dx = d*sin(theta);
    dy = d*cos(theta);
end