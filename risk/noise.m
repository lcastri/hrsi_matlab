N = {};

%% noise theta
Noise_theta = Noise(tout, "Noise_theta", 0, 0.03);
N{1,1} = Noise_theta;

%% noise D
Noise_D = Noise(tout, "Noise_D", 0, 0.001);
N{2,1} = Noise_D;

%% noise V
Noise_V = Noise(tout, "Noise_V", 0, 0.01);
N{3,1} = Noise_V;

