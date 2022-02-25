a = 10;
for t = 1 : length(no_nan_A{a}.time)
    data{1,1}.data(t,1) = wrapTo2Pi(no_nan_A{a}.theta_a(t, no_nan_A{a}.goals_seq(t)));
    if t ~= 1 && no_nan_A{a}.goals_seq(t) ~= no_nan_A{a}.goals_seq(t-1)
        data{2,1}.data(t,1) = no_nan_A{a}.d_a(t, no_nan_A{a}.goals_seq(t-1));
    else
        data{2,1}.data(t,1) = no_nan_A{a}.d_a(t, no_nan_A{a}.goals_seq(t));
    end
end
data{3,1}.data(:,1) = medfilt1(abs(no_nan_A{a}.v(:)), 10);