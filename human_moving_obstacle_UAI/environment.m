%% Boundaries
axis_def = [-10, 10, -10, 10];

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
Goals_h = [[9.4, 4.2];
           %[9 -3.75];
           [-1, -4]; 
           [-9.4, 0]; 
           [1, 4]];
       
% Goals_r = [[4.5 2];
%            [4.5 -2];
%            [-4.5 -2];
%            [-4.5 2]];