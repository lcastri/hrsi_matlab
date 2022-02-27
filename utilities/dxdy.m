function [dx, dy] = dxdy(d, alpha)
%dxdy: decompose distance
% - param d: (float) distance
% - param alpha: (float) angle
% - return dx: (float) distance along x-axis
% - return dy: (float) distance along y-axis

    theta = pi/2 - alpha;
    dx = d*sin(theta);
    dy = d*cos(theta);
end