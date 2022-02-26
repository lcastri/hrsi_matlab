N = {};

%% noise Dg
noise_Dg = Noise(tout, "Noise_Dg", 0, 0.06);
N{1,1} = noise_Dg;

%% noise v
noise_v = Noise(tout, "Noise_v", 0, 0.03);
N{2,1} = noise_v;

%% noise risk
noise_risk = Noise(tout, "noise_risk", 0, 0.05);
N{3,1} = noise_risk;


