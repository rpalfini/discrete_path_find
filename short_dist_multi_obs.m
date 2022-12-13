% finds shortest distance with obstacles using constrained solver

% this file reads environment from csv and creates initial guess via ginput

% discrete solution to shortest distance problem
% Set dx to change the step size between intervals

clearvars
global outputFcn_global_data x_vals obstacles 
% outputFcn_global_data allows us to look at the data from each step of the optimization
% xvals and obstacles pass the simulation info to constraint function
test_type = 'short_dist_multi_obst'; % used to identify in output log

figure(88)
clf()
obstacles = read_obstacle_file('obstacle_envs/6_obstacle.txt');
hold on
for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3));
end
x0 = -2; % x start
xf = 25; % x final
y0 = 6;
yf = 12;
plot_start([x0,y0])
plot_end([xf,yf])
axis('equal')
axis([x0-5 xf+5 -5 30])

input_clicks = multi_click_input();

dx = 0.5; % step size x dim; below 0.2 exceeds function evaluation limit

N = (xf-x0)/dx; % num steps
x_span = x0:dx:xf;
x_span_guess = x_span(2:end-1);

y_guess = ones(1,N-1);

input_point_idx = zeros(1,size(input_clicks,1));
for ii = 1:size(input_clicks,1)
    % replaces guesses with ginput click values
    x_click = input_clicks(ii,1)*ones(size(x_span_guess));
    x_diff = abs(x_click-x_span_guess);
    x_idx = find(x_diff==min(x_diff));
    input_point_idx(ii) = x_idx+1; % this is needed b/c x_span_guess is missing entry x0, where as when this is used below, x_span has entry x0
    fprintf('%d idx, %.2f x_click, %.2f x_span\n',x_idx,x_click(1),x_span_guess(x_idx))
    y_guess(x_idx) = input_clicks(ii,2);
end

input_point_idx = sort(input_point_idx);
input_point_idx = [1 input_point_idx length(x_span)];
y_span_guess = [y0 y_guess yf];
for ii = 1:length(input_point_idx)-1
    num_points = input_point_idx(ii+1)-input_point_idx(ii);
    y_at1 = y_span_guess(input_point_idx(ii));
    y_at2 = y_span_guess(input_point_idx(ii+1));
    x_at1 = x_span(input_point_idx(ii));
    x_at2 = x_span(input_point_idx(ii+1));
    slope12 = (y_at2-y_at1)/(x_at2-x_at1);
    dx = x_span(2)-x_span(1);
    for jj = input_point_idx(ii):input_point_idx(ii)+num_points-1
    % creates linear slopes between inputted clicked points
        y_span_guess(jj+1) = y_span_guess(jj) + slope12*dx;
    end
end
y_guess = y_span_guess(2:end-1);
plot(x_span,y_span_guess,'.-','Color',[0.3010 0.7450 0.9330])

% build optimization function
f = @(y)  sqrt(dx^2 + (y(1)-y0)^2);
for ii = 1:N-2
    f = @(y) f(y) + sqrt(dx^2 + (y(ii+1)-y(ii))^2);
end
f = @(y) f(y) + sqrt(dx^2 + (yf - y(N-1))^2);

% f(y_guess)
% options = optimoptions(@fminunc,'Display','iter','OutputFcn',@outputFcn_global);
% options = optimoptions(@fminunc,'Display','iter','MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global);
% options = optimoptions(@fminunc,'MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global,'StepTolerance',1e-8);
options = optimoptions(@fmincon,'MaxIterations',4e4,'MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global,'OptimalityTolerance',1e-8);

% [x,fval,exitflag,output] = fminunc(f,y_guess,options)
x_vals = x_span; % used by constraints function
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
[x,fval,exitflag,output] = fmincon(f,y_guess,A,b,Aeq,beq,lb,ub,@obst_constraints,options)
opt_results = outputFcn_global_data;
%%
% plot results
y_out = [y0 x yf];
x_out = x_span;

figure(25)
plot_start([x0 y0])
plot_end([xf yf])
plot_solution(x_out,y_out)
% plot(x_out,y_out,'b.-')
% plot(x_out,y_out,'.-','Color',[0 0.4470 0.7410])

% plot guess
% plot(x_out,y_span_guess,'.-','Color',[0.3010 0.7450 0.9330])
plot_guess(x_out,y_span_guess)
% plot obstacle
for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3))
end
legend_entries = {'start','end','solution','guess',''};
legend(legend_entries);
% make_title(y_option)
grid on
axis equal
hold off


