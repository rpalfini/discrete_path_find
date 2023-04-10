figure(88)
clf()
obstacles = read_obstacle_file('6_obstacle.txt');
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

input_clicks = ginput(size(obstacles,1))
% input_clicks = [1.2673   14.6647;
%                 5.7373    3.9359;
%                 16.5207   12.7405];

dx = 0.1; % step size x dim; below 0.2 exceeds function evaluation limit

N = (xf-x0)/dx; % num steps
x_span = x0:dx:xf;
x_span_guess = x_span(2:end-1);

y_guess = ones(1,N-1);

input_point_idx = zeros(1,size(obstacles,1));
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


plot(x_span,y_span_guess,'.-','Color',[0.3010 0.7450 0.9330])


