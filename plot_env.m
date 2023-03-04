function plot_env(x0,xf,obstacles)
% This function plots the start end and obstacles specified
hold off
plot_start(x0)
hold on
plot_end(xf)
for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3));
end

axis('equal')
axis([0 30 0 25])
grid on

end