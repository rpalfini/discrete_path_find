% finds shortest time path from point A to point B, the brachistrone curve,
% discretly

clearvars
test_type = 'brach_solve_var_dx';
% simulation discretizations
% set number of x iterations but leave x locations as variables
N = 10; % number of x steps
x0 = 10;
xf = 0; 

y0 = 10; % y initial, y(x0)
yf = 0; % y final is unknown and dependent on curve_f

% different initial y guesses
y_option = 1; % set to 0 to set all guesses equal to 1
y_guess = make_y_guess(y_option); % one less interval than points

% different initial x guesses
x_option = 3;
x_guess = make_x_guess(x_option);

% build guess structure
% guess = [x1, x2, ..., xN-1, y1, y2, ..., yN-1]', where xN and yN are xf and
% yf
var_guess = [x_guess y_guess];
offset = length(x_guess);
% build optimization function
f = @(var)  sqrt((var(1)-x0)^2 + (var(1+offset)-y0)^2);
for ii = 1:N-2 % N-2 as we skip first and last iteration of loop
    f = @(var) f(var) + sqrt((var(ii+1) - var(ii))^2 + (var(ii+1+offset) - var(ii+offset))^2);
end
f = @(var) f(var) + sqrt((var(N)-var(N-1))^2 + (curve_f(var(N)) - var(N-1+offset))^2);

% f(var_guess)
options = optimoptions(@fminunc,'Display','iter');
[var_out,fval,exitflag,output] = fminunc(f,var_guess,options)

% making plot
% making curve data
x_curve = var_out(offset)-2:0.1:var_out(offset)+2;
y_curve = curve_f(x_curve);

% pulling solution data
x_out = [x0 var_out(1:offset)];
y_out = [y0 var_out(offset+1:end) curve_f(var_out(N))];

figure(24)
clf
plot(x_curve,y_curve)
hold on
plot(x_out,y_out,'.-')
grid on
hold off
% fprintf('y_final = %.2f at x_final = %.2f\n',y_out(end),x_out(end))
axis equal


function x_guess_out = make_x_guess(x_option)
% makes initial x value guesses based on number of steps and user input
x_guess = ones(1,N-1); % N-1 as final point is known
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
        x_guess = zeros(1,length(x_guess));
        for jj = 1:length(x_guess)-1
            x_guess(jj+1) = x_guess(jj) + 0.2;
        end
    otherwise
end
x_guess_out = x_guess;

end

function y_guess_out = make_y_guess(y_option)
% makes initial y value guesses based on number of steps and user input
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
y_guess_out = y_guess;
end

