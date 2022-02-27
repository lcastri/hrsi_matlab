function gFa = attractive_gradient(Ka)
%attractive_gradient: compute gradient attractive force
% - param Ka: (float) attractive gain
% - return gFa: (float) gradient attractive force

    gFa = [-Ka, 0; 
             0 -Ka];

end

