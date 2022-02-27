function d = distance(xa,ya, xb, yb)
%distance: compute distance [m] between two points
% - param xa: (float) x-coord point A
% - param ya: (float) y-coord point A
% - param xb: (float) x-coord point B
% - param yb: (float) y-coord point B
% - return d: (float) distance A-B

    d = sqrt((xa - xb)^2 + (ya - yb)^2)/1000;
end

