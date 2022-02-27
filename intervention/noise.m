N = {};

%% noise v2
noise_v2 = Noise(tout, "Noise_v2", 0, 0.1);
N{1,1} = noise_v2;

%% noise D12
noise_D12 = Noise(tout, "Noise_D12", 0, 0.01);
N{2,1} = noise_D12;

%% noise v1
noise_v1 = Noise(tout, "Noise_v1", 0, 0.1);
N{3,1} = noise_v1;

