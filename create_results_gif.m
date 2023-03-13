% this function takes results of fmincon and makes into a gif
tic

% check if gif is on path, and add if it isnt
if isempty(which('gif'))
    addpath(genpath(fullfile('.', 'gif_func')));
end

% options
axis_frame = [0 30 0 25]; % sets axis limits when creating the gif
is_const_dx = 1; % option to specify if using variable dx or not
is_obst = 1; % option to plot obstacles
frame_div = 2; % divides number of frames outputed by this number i.e. shows every 5th frame
gif_delay = 1/15;
gif_title = 'demo_1_below';
legend_loc = 'northeast';

gif_results_path = 'solution_result_gifs\';
gif_name = strcat(gif_results_path,gif_title,'.gif');

% simulation iterations stored in opt_results;
start_point = [x_out(1) y_out(1)];
end_point = [x_out(end) y_out(end)];

obstacles = read_obstacle_file('obstacle_envs/1_obstacle.txt');

out_fig = figure(33);
% out_fig.Visible = 'on'; % turning this off didn't improve output time
clf
num_iter = length(opt_results);
for ii = 1:num_iter
    plot_start(start_point)
    title("guess\_below")
    plot_end(end_point)
%     plot(x_out,y_out_guess,'.-','Color',[0.3010 0.7450 0.9330])
    plot_guess(x_out,y_span_guess)
    if is_obst
%         plot_obstacle(1,[2 0.5]);
%         plot_obstacle(0.5,[6 3]);
        for kk = 1:size(obstacles,1)
            plot_obstacle(obstacles(kk,1),obstacles(kk,2:3));
        end
    end

    if is_const_dx
        [x_data,y_data] = pull_opt_data(opt_results(ii).x,x_out,y_out);
    else
        [x_data,y_data] = pull_opt_data_vardx(opt_results(ii).x,start_point,end_point,offset_y);
    end
%     plot(x_data,y_data,'.-','Color',[0 0.4470 0.7410])
%     plot(x_data,y_data,'b.-','LineWidth',2)
    plot_solution(x_data,y_data)
    legend_entries = {'start','end','guess','','solution'};
    legend(legend_entries,'Location',legend_loc);
%     make_title(y_option)
    hold off
    grid on
    axis(axis_frame);
    axis equal
    if ii == 1
        gif(gif_name,'DelayTime',gif_delay)
    elseif ~mod(ii,frame_div) || ii == num_iter
        gif
    end

end
toc
%% script functions
% this function pulls data if constant dx or step size
function [x_data_out,y_data_out] = pull_opt_data(opt_results_in,x_out,y_out)
    % pulls data from specific iteration step of optimization solver
    y_start = y_out(1);
    y_end = y_out(end);
    y_data = opt_results_in;
    x_data_out = x_out;
    y_data_out = [y_start y_data y_end];
end

% this function pulls data if x-step step size is variable
function [x_data_out,y_data_out] = pull_opt_data_vardx(opt_results_in,start_point,end_point,offset_y)
    % pulls data from specific iteration step of optimization solver
    x_data = opt_results_in(1:offset_y);
    y_data = opt_results_in(offset_y+1:end);
    x_data_out = [start_point(1) x_data end_point(1)];
    y_data_out = [start_point(2) y_data end_point(2)];
end

% function plot_start(fig,x0)
% % x0 is a vector
% % figure(fig)
% plot(x0(1),x0(2),'r^','LineWidth',3)
% hold on
% end

% function plot_end(fig,xf)
% % xf is a vector
% % figure(fig)
% plot(xf(1),xf(2),'go','LineWidth',3)
% 
% % legend('start','','end','Location','best')
% end

% function plot_obstacle(fig,r,center)
% theta = 0:pi/12:2*pi;
% x_out = zeros(1,length(theta));
% y_out = zeros(1,length(theta));
% for ii = 1:length(theta)
%     x_out(ii) = r*cos(theta(ii));
%     y_out(ii) = r*sin(theta(ii));
% end
% x_out = x_out + center(1);
% y_out = y_out + center(2);
% 
% % figure(fig)
% plot(x_out,y_out)
% 
% end
