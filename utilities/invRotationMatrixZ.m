function R = invRotationMatrixZ(angle)
    % Create a 2x2 rotation matrix around the z-axis
    R = [cos(angle) sin(angle);
         -sin(angle) cos(angle)];
end
