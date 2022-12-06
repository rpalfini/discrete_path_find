function [c,ceq] = obst_constraints(y)
global x_vals obstacles
% obstacle locations formatted [radius, center_x, center_y]
num_obst = size(obstacles,1);
num_steps = length(x_vals)-2;

c = [];
for jj = 1:num_obst
    c_inter = zeros(1,num_steps);
    for ii = 1:num_steps
        % c(1) = -(y(1)-2).^2 - (y(2)-0.5).^2 + 1;
        c_inter(ii) = -(x_vals(ii+1)-obstacles(jj,2)).^2 - (y(ii)-obstacles(jj,3)).^2 + obstacles(jj,1)^2;
    end
    c = [c c_inter];
end
% c_length = length(c);
% for ii = 1:num_steps
% c(ii+c_length) = -(x_vals(ii+1)-6).^2 - (y(ii)-3).^2 + 0.5^2;
% end
ceq = [];