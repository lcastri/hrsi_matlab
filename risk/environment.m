%% Boundaries
axis_def = [-6, 6, -6, 6];

ul = [-9.4 4.2];
ur = [9.4 4.2];
br = [9.4 -4.2];
bl = [-9.4 -4.2];

boundaries = [ul;
              ur;
              br;
              bl;
              ul];                  
          
%% Goals
Goals_h = [0 0];
       
Goals_r = [[-5 0];
           [5 0];
           [0 5];
           [0 -5]];
