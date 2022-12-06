% finds shortest distance with obstacles using constrained solver

% discrete solution to shortest distance problem
% Set dx to change the step size between intervals

clearvars
global outputFcn_global_data x_vals obstacles 
% outputFcn_global_data allows us to look at the data from each step of the optimization
% xvals and obstacles pass the simulation info to constraint function
test_type = 'short_dist_3obst'; % used to identify in output log

% different initial y guesses
y_option = 1;

% simulation discretizations
dx = 0.1; % step size x dim; below 0.2 exceeds function evaluation limit
x0 = 0; % x start
xf = 10; % x final
N = (xf-x0)/dx; % num steps
x_span = x0:dx:xf;

y0 = 0; % y initial, y(x0)
yf = 0; % y final, y(xf)

% obstacle locations formatted [radius, center_x, center_y]
obstacles = [1 2 0.5;
            0.5 6 3;
            3 4 3];

y_guess = make_y_guess(y_option,N); 

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
plot(x_out,y_out,'b.-')
% plot(x_out,y_out,'.-','Color',[0 0.4470 0.7410])
hold on
% plot guess
y_out_guess = [y0 y_guess yf];
plot(x_out,y_out_guess,'.-','Color',[0.3010 0.7450 0.9330])
% plot obstacle
for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3))
end
legend_entries = {'start','end','solution','guess',''};
legend(legend_entries);
make_title(y_option)
grid on
axis equal
hold off

function y_guess_out = make_y_guess(y_option,N)
% makes initial y value guesses based on number of steps and user input
global x_vals
y_guess = ones(1,N-1); % one less interval than points
switch y_option
    case 1
        y_guess = 4*y_guess;
    case 2
        y_guess = 2*y_guess;
%         for jj = 1:length(y_guess)-1
%             y_guess(jj+1) = y_guess(jj) + 0.1;
%         end
    case 3
        y_guess = -1*y_guess;
%         for jj = 1:length(y_guess)-1
%             y_guess(jj+1) = y_guess(jj) + 0.1;
%         end
%         y_guess = flip(y_guess);
    case 4
        % making more complicated guess
        y_guess = -1*y_guess;
        x_idx1 = 3.2;
        x_idx2 = 5;
        idx1 = find(x_vals < x_idx1);
        idx2 = find(x_vals < x_idx2);
        num_points = idx2(end)-idx1(end);
        y_at1 = -1;
        y_at2 = 4;
        slope12 = (y_at2-y_at1)/(x_idx2-x_idx1);
        dx = x_vals(2)-x_vals(1);
        for ii = idx1(end)-2:idx1(end)-2+num_points-1
            y_guess(ii+1) = y_guess(ii) + slope12*dx;
        end
        y_guess(idx2(end)-2:end) = y_at2;


%         y_guess = [9 8 -2 1];
    otherwise
end
y_guess_out = y_guess;
end

