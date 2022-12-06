% discrete solution to shortest distance problem
% Set dx to change the step size between intervals

clearvars
global outputFcn_global_data % this allows us to look at the data from each step of the optimization
test_type = 'short_dist_solver'; % used to identify in output log
% simulation discretizations
dx = 0.1; % step size x dim; below 0.2 exceeds function evaluation limit
x0 = 0; % x start
xf = 10; % x final
N = (xf-x0)/dx; % num steps

y0 = 0; % y initial, y(x0)
yf = 0; % y final, y(xf)

% different initial y guesses
y_option = 0;
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
options = optimoptions(@fminunc,'MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global);
[x,fval,exitflag,output] = fminunc(f,y_guess,options)
opt_results = outputFcn_global_data;

% plot results
y_out = [y0 x yf];
x_out = x0:dx:xf;

figure(20)
plot(x_out,y_out,'.-')
grid on

function y_guess_out = make_y_guess(y_option,N)
% makes initial y value guesses based on number of steps and user input
y_guess = ones(1,N-1); % one less interval than points
switch y_option
    case 1
        for jj = 1:length(y_guess)-1
            y_guess(jj+1) = y_guess(jj) + rand;
        end
    case 2
        for jj = 1:length(y_guess)-1
            y_guess(jj+1) = y_guess(jj) + 0.1;
        end
    case 3
        for jj = 1:length(y_guess)-1
            y_guess(jj+1) = y_guess(jj) + 0.1;
        end
        y_guess = flip(y_guess);
    case 4 % only when N = 5
        y_guess = [9 8 -2 1];
    otherwise
end
y_guess_out = y_guess;
end

