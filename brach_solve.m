% finds shortest time path from point A to point B, the brachistrone curve,
% discretly
%% solving discrete brachistrone
clearvars
global outputFcn_global_data % this allows us to look at the data from each step of the optimization
test_type = 'brach_solve';
% simulation discretizations
x0 = 0;
xf = 1.5; 
dx = 0.01; % step size x dim
N = abs((xf-x0)/dx); % numer of steps determined by size of dx

y0 = 1; % y initial, y(x0)
yf = 0; % y final is unknown and dependent on curve_f

% different initial y guesses
y_option = 3; % set to 0 to set all guesses equal to 1
y_guess = make_y_guess(y_option,N); % one less interval than points

% build optimization objective function
var_guess = y_guess;
% creating first step based on constraints
f = @(var) (sqrt(1 + ((var(1) - y0)/(dx))^2)/sqrt(y0))*dx; % var is variable vector by guess structure above
for ii = 1:N-2 % N-2 as we skip first and last iteration of loop
    f = @(var) f(var) + (sqrt(1 + ((var(ii + 1) - var(ii))/(dx))^2) ...
        /sqrt(var(ii)))*dx;
end
% creating last step based on constraints
f = @(var) f(var) + (sqrt(1 + ((yf - var(N-1))/(dx))^2) ...
        /sqrt(var(N-1)))*dx;

% f(var_guess)
% options = optimoptions(@fminunc,'Display','iter','MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global);
% options = optimoptions(@fminunc,'Display','iter','MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global,'StepTolerance',1e-8);
options = optimoptions(@fminunc,'MaxFunctionEvaluations',8.2e5,'OutputFcn',@outputFcn_global,'StepTolerance',1e-8);
[var_out,fval,exitflag,output] = fminunc(f,var_guess,options)
opt_results = outputFcn_global_data;

%% creating analytical solution
syms x y
[Sx ,Sy] = solve(x*(y-sin(y))==xf, x*(1-cos(y))==yf);
r=Sx;
kk = 0;
for phi = 0:0.01:Sy
    kk = kk+1;
    x_true(kk)=r*( phi-sin ( phi ) ) ;
    y_true(kk)=r*(1-cos(phi) ) ;
%     plot ( x,-y , ' k . ' )
%     hold on
end

%% plotting data
% pulling solution data
% x_out = [x0 var_out(1:offset_y) xf];
if xf < x0
    dx = -dx;
end
x_out = x0:dx:xf;
y_out = [y0 var_out yf];
y_out = -y_out;

figure(23)
clf
% plot discrete solution
plot(x_out(1),y_out(1),'r^','LineWidth',3)
hold on
plot(x_out,y_out,'b.-')
plot(x_out(end),y_out(end),'go','LineWidth',3)
grid on
% plot analytical solution
plot(x_true,y_true)

hold off
legend('start','','end','actual')
% fprintf('y_final = %.2f at x_final = %.2f\n',y_out(end),x_out(end))
axis equal

function x_guess_out = make_x_guess(x_option,N)
% makes initial x value guesses based on number of steps and user input
x_guess = ones(1,N-1); % N-1 as final point is known, this is default
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
        x_guess(1) = 0.1;
        for jj = 1:length(x_guess)-1
            x_guess(jj+1) = x_guess(jj) + 0.2;
        end
    otherwise
end
x_guess_out = x_guess;

end

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

