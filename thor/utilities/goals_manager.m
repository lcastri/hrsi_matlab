G1 = [3915.15 6649.11];
G2 = [6000 3543.81];
G3 = [1930 -4020];
G4 = [-4700 -4700];
G5 = [-207.612 3875.55];
Garray = [G1; G2; G3; G4; G5]; % [mm]
Rarray = [2; 0.750; 2; 2; 1.50]; % [m]

G = {};
for i = 1 : length(Garray)
    g.id = i;
    g.name = "G"+i;
    g.x = Garray(i,1);
    g.y = Garray(i,2);
    g.r = Rarray(i);
    G{i,1} = g;
end
clear g G1 G2 G3 G4 G5 Garray Rarray i