N = {};

%% noise theta
Noise_theta = myNoise(tout, "Noise_theta", 0, 0.03);
N{1,1} = Noise_theta;

%% noise D
Noise_D = myNoise(tout, "Noise_D", 0, 0.001);
N{2,1} = Noise_D;

%% noise V
Noise_V = myNoise(tout, "Noise_V", 0, 0.01);
N{3,1} = Noise_V;

