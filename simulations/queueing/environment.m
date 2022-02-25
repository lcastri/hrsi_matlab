%% Boundaries
axis_def = [-6, 6, -6, 6];

step_bound = 0.001;

ul = [-5 5];
ur = [5 5];
br = [5 -5];
bl = [-5 -5];

Boundaries = [ul;
              ur;
              br;
              bl;
              ul];                   
          
%% Goals
checkout = [4 0];
exit = [4 -4];
Goals_h = [[-4 0]; 
           [-2 0];
           [0 0];
           [2 0];
           checkout;
           exit];

