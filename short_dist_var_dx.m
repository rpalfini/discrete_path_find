% using the solver method of short_dist_curv but to point instead of curve.
% This uses variable dx to find solution

clearvars
test_type = 'short_dist_var_dx';
global outputFcn_global_data
% simulation discretizations
% set number of x iterations but leave x locations as variables
N = 10; % number of x steps
% dx = 0.2; % step size x dim; below 0.2 exceeds function evaluation limit
x0 = 0;
xf = 10;

y0 = 0; % y initial, y(x0)
yf = 10; % y final is unknown and dependent on curve_f
% curve_f = @(x) (x-7).^2 + 25; % equation for curve representing  

% different initial y guesses
y_option = 1; % set to 0 to set all guesses equal to 1
y_guess = ones(1,N-1); % one less interval than points
switch y_option
    case 1
        for jj = 1:length(y_guess)-1
            y_guess(jj+1) = y_guess(jj) + rand;
        end
    case 2
        for jj = 1:length(y_guess)-1
            y_guess(jj+1) = y_guess(jj) + 1;
        end
    otherwise
end

% different initial x guesses
x_option = 3;
x_guess = ones(1,N-1);
% x_guess = ones(1,N);
switch x_option
    case 1
        for jj = 1:length(x_guess)-1
            x_guess(jj+1) = x_guess(jj) + rand;
        end
    case 2
        for jj = 1:length(x_guess)-1
            x_guess(jj+1) = x_guess(jj) + 0.5;
        end
    case 3
        for jj = 1:length(x_guess)-1
            x_guess(jj+1) = x_guess(jj) + 0.2;
        end
    otherwise
end

% build guess structure
% guess = [x1, x2, ..., xN, y1, y2, ..., yN-1]', where xN and yN are xf and
% yf
var_guess = [x_guess y_guess];
offset_y = length(x_guess);
% build optimization function
f = @(var)  sqrt((var(1)-x0)^2 + (var(1+offset_y)-y0)^2);
for ii = 1:N-2 % N-2 as we skip first and last iteration of loop
    f = @(var) f(var) + sqrt((var(ii+1) - var(ii))^2 + (var(ii+1+offset_y) - var(ii+offset_y))^2);
end
f = @(var) f(var) + sqrt((xf - var(N-1))^2 + (yf - var(N-1+offset_y))^2);

% f(var_guess)
options = optimoptions(@fminunc,'Display','iter','OutputFcn',@outputFcn_global);
[var_out,fval,exitflag,output] = fminunc(f,var_guess,options)
opt_results = outputFcn_global_data;

% making plot
% making curve data
% x_curve = 0:0.1:7;
% y_curve = curve_f(x_curve);

% pulling solution data
x_out = [x0 var_out(1:offset_y) xf];
y_out = [y0 var_out(offset_y+1:end) yf];

figure(22)
clf
% plot(x_curve,y_curve)
% hold on
plot(x_out,y_out,'.-')
grid on
hold off
fprintf('y_final = %.2f at x_final = %.2f\n',y_out(end),x_out(end))
