function d = point_to_line(pt, v1, v2)
%point_to_line: min distance point to line
% - param pt: (array) point coordinates nx3
% - param v1: (array) vertice on the line 1x3
% - param v2: (array) vertice on the line 1x3
% - return d: (float) min distance

v1 = repmat(v1,size(pt,1),1);
v2 = repmat(v2,size(pt,1),1);
a = v1 - v2;
b = pt - v2;
d = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));
