figure(88)
obstacles = read_obstacle_file('4_obstacle.txt')

for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3))
end

plot_start([0,6])
plot_end([20,12])

inputs = ginput(size(obstacles,1))

