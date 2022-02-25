figure
plot(alpha_val, thor_goal_shd, '-', 'LineWidth', 2)
hold on
plot(alpha_val, atc_goal_shd, '-', 'LineWidth', 2)
hold on
plot(alpha_val, thor_interaction_shd, '-', 'LineWidth', 2)
hold on
grid on
ylim([0 3])
xlim([0.001 0.05])
ylabel("SHD", "FontSize", 15)
xlabel("\alpha", "FontSize", 18)
legend(["a", "b", "c"])